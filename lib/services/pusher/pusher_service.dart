import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sanmiwago_user/constants/api_constants.dart';
import 'package:sanmiwago_user/constants/pusher_constants.dart';
import 'package:sanmiwago_user/services/base_client.dart';
import 'package:sanmiwago_user/services/pusher/driver_location_update.dart';
import 'package:sanmiwago_user/services/pusher/order_wait_helper.dart';
import 'package:sanmiwago_user/services/pusher/pusher_fallback_creds.dart';

/// Lazy Pusher connection for order-status waiting and driver live tracking.
/// Credentials are session-cached in memory only (see [prefetchCredentials]).
class PusherService {
  PusherService._();

  static final PusherService instance = PusherService._();

  static const int _credentialMaxAttempts = 3;
  static const Duration _credentialRetryDelay = Duration(seconds: 2);

  late PusherChannelsFlutter _pusher;
  bool _isInitialized = false;
  bool _isConnected = false;
  bool _intentionalDisconnect = false;

  bool _wantsOrderUpdateChannel = false;
  bool _isSubscribedToOrderUpdate = false;

  bool _wantsDriverTrackingChannel = false;
  bool _isSubscribedToDriverTracking = false;
  String? _driverTrackingOrderId;

  String? _cachedPusherKey;
  bool _usingFallbackCredentials = false;
  Future<void>? _prefetchFuture;
  Future<void>? _connectFuture;

  String? _waitingForOrderId;
  String? _bufferedTerminalStatus;

  final StreamController<String> _statusController = StreamController<String>.broadcast();
  final StreamController<DriverLocationUpdate> _driverLocationController =
      StreamController<DriverLocationUpdate>.broadcast();

  Stream<String> get statusStream => _statusController.stream;
  Stream<DriverLocationUpdate> get driverLocationStream => _driverLocationController.stream;

  String? terminalStatusFor(String orderId) {
    if (_waitingForOrderId != orderId) return null;
    return _bufferedTerminalStatus;
  }

  Future<void> prefetchCredentials() {
    _prefetchFuture ??= _fetchAndCacheCredentials();
    return _prefetchFuture!;
  }

  /// Connect and subscribe to `order-update` for order waiting.
  Future<void> ensureConnected() {
    _wantsOrderUpdateChannel = true;
    return _ensureConnectionAndSubscriptions();
  }

  /// Connect and subscribe to `driver-live-tracking-{orderId}` for the map page.
  Future<void> ensureDriverTrackingSubscribed(String orderId) async {
    if (orderId.isEmpty) {
      log('PusherService: cannot subscribe driver tracking — empty orderId');
      return;
    }

    if (_driverTrackingOrderId != null &&
        _driverTrackingOrderId != orderId &&
        _isSubscribedToDriverTracking) {
      await _unsubscribeDriverTracking();
    }

    _driverTrackingOrderId = orderId;
    _wantsDriverTrackingChannel = true;
    await _ensureConnectionAndSubscriptions();
  }

  /// Unsubscribe driver tracking. Disconnects the socket only if order-wait is not active.
  Future<void> stopDriverTracking() async {
    _wantsDriverTrackingChannel = false;
    await _unsubscribeDriverTracking();
    _driverTrackingOrderId = null;
    await _maybeDisconnectSocket();
  }

  Future<void> _fetchAndCacheCredentials() async {
    if (_cachedPusherKey != null && _cachedPusherKey!.isNotEmpty) return;

    for (var attempt = 1; attempt <= _credentialMaxAttempts; attempt++) {
      try {
        final response = await BaseClient().get(ApiConstants.baseUrl, ApiConstants.fetchPusherInfoEndpoint);
        if (response == null) {
          log('PusherService: fetch-pusher-info returned null (attempt $attempt)');
        } else {
          final Map<String, dynamic> json =
              response is Map<String, dynamic> ? response : Map<String, dynamic>.from(response as Map);

          final key = json['pusher_key']?.toString();
          if (key != null && key.isNotEmpty) {
            _cachedPusherKey = key;
            _usingFallbackCredentials = false;
            log('PusherService: credentials cached from API (attempt $attempt)');
            return;
          }

          log('PusherService: fetch-pusher-info returned empty pusher_key (attempt $attempt)');
        }
      } catch (e, st) {
        log('PusherService: credential fetch attempt $attempt failed: $e', stackTrace: st);
      }

      if (attempt < _credentialMaxAttempts) {
        await Future<void>.delayed(_credentialRetryDelay);
      }
    }

    _applyFallbackCredentials();
  }

  void _applyFallbackCredentials() {
    if (_cachedPusherKey != null && _cachedPusherKey!.isNotEmpty) return;

    final fallbackKey = PusherFallbackCreds.keyForEnv(ApiConstants.env);
    if (fallbackKey.isEmpty) {
      log('PusherService: no fallback pusher_key for env ${ApiConstants.env}');
      return;
    }

    _cachedPusherKey = fallbackKey;
    _usingFallbackCredentials = true;
    log(
      'PusherService: using env fallback pusher_key for ${ApiConstants.env} '
      '(fetch-pusher-info unavailable)',
    );
  }

  void _invalidateCredentials() {
    _cachedPusherKey = null;
    _usingFallbackCredentials = false;
    _prefetchFuture = null;
  }

  void _handleCredentialError() {
    if (_usingFallbackCredentials) {
      log('PusherService: fallback credentials rejected by Pusher');
      return;
    }

    _invalidateCredentials();
    _applyFallbackCredentials();
    if (_cachedPusherKey == null || _cachedPusherKey!.isEmpty) {
      return;
    }

    _isInitialized = false;
    _isConnected = false;
    _isSubscribedToOrderUpdate = false;
    _isSubscribedToDriverTracking = false;
    unawaited(_ensureConnectionAndSubscriptions());
  }

  Future<void> _ensureConnectionAndSubscriptions() {
    _connectFuture ??= _ensureConnectionAndSubscriptionsInternal();
    return _connectFuture!.whenComplete(() {
      _connectFuture = null;
    });
  }

  bool get _subscriptionsSatisfied =>
      (!_wantsOrderUpdateChannel || _isSubscribedToOrderUpdate) &&
      (!_wantsDriverTrackingChannel || _isSubscribedToDriverTracking);

  Future<void> _ensureConnectionAndSubscriptionsInternal() async {
    await prefetchCredentials();
    if (_cachedPusherKey == null || _cachedPusherKey!.isEmpty) {
      _prefetchFuture = null;
      await _fetchAndCacheCredentials();
    }
    if (_cachedPusherKey == null || _cachedPusherKey!.isEmpty) {
      log('PusherService: cannot connect — no pusher_key available');
      return;
    }

    if (_isInitialized && _isConnected && _subscriptionsSatisfied) {
      return;
    }

    if (!_isInitialized) {
      await _initPusher();
    } else if (!_isConnected) {
      await _pusher.connect();
    } else {
      await _resubscribeActiveChannels();
    }
  }

  Future<void> _initPusher() async {
    try {
      _pusher = PusherChannelsFlutter.getInstance();
      await _pusher.init(
        apiKey: _cachedPusherKey!,
        cluster: PusherConstants.cluster,
        pongTimeout: 120000,
        activityTimeout: 86400000,
        onConnectionStateChange: (currentState, previousState) {
          log('PusherService: connection $previousState -> $currentState');
          final normalized = currentState.toLowerCase();
          _isConnected = normalized == 'connected';

          if (normalized == 'connected') {
            _isConnected = true;
            unawaited(_resubscribeActiveChannels());
          } else if (normalized == 'reconnecting') {
            _isConnected = false;
          } else if (normalized == 'disconnected') {
            _isConnected = false;
            if (_intentionalDisconnect) {
              _intentionalDisconnect = false;
              _isSubscribedToOrderUpdate = false;
              _isSubscribedToDriverTracking = false;
            } else {
              log('PusherService: unexpected disconnect (SDK handles transport reconnect)');
            }
          } else if (normalized == 'failed' || normalized == 'unavailable') {
            _isConnected = false;
            _isSubscribedToOrderUpdate = false;
            _isSubscribedToDriverTracking = false;
            log('PusherService: connection $normalized');
          }
        },
        onError: (message, code, e) {
          if (_intentionalDisconnect && message.toLowerCase().contains('disconnecting')) {
            return;
          }
          log('PusherService: error message=$message code=$code e=$e');
          final lower = message.toLowerCase();
          if (lower.contains('key') || lower.contains('auth')) {
            _handleCredentialError();
          }
        },
        onSubscriptionSucceeded: (channelName, data) {
          log('PusherService: subscribed to $channelName');
          if (channelName == PusherConstants.orderUpdateChannel) {
            _isSubscribedToOrderUpdate = true;
          } else if (_driverTrackingOrderId != null &&
              channelName == PusherConstants.driverLiveTrackingChannel(_driverTrackingOrderId!)) {
            _isSubscribedToDriverTracking = true;
          }
        },
        onSubscriptionError: (message, e) {
          log('PusherService: subscription error $message $e');
        },
        onEvent: _onEvent,
      );

      _isInitialized = true;
      await _pusher.connect();
    } catch (e, st) {
      log('PusherService: init failed: $e', stackTrace: st);
      _isInitialized = false;
    }
  }

  Future<void> _resubscribeActiveChannels() async {
    if (_wantsOrderUpdateChannel) {
      await _subscribeOrderUpdate();
    }
    if (_wantsDriverTrackingChannel) {
      await _subscribeDriverTracking();
    }
  }

  Future<void> _subscribeOrderUpdate() async {
    if (!_wantsOrderUpdateChannel || _isSubscribedToOrderUpdate) return;
    try {
      await _pusher.subscribe(channelName: PusherConstants.orderUpdateChannel);
    } catch (e, st) {
      log('PusherService: order-update subscribe failed: $e', stackTrace: st);
    }
  }

  Future<void> _subscribeDriverTracking() async {
    if (!_wantsDriverTrackingChannel || _driverTrackingOrderId == null || _isSubscribedToDriverTracking) {
      return;
    }
    try {
      final channel = PusherConstants.driverLiveTrackingChannel(_driverTrackingOrderId!);
      await _pusher.subscribe(channelName: channel);
    } catch (e, st) {
      log('PusherService: driver tracking subscribe failed: $e', stackTrace: st);
    }
  }

  Future<void> _unsubscribeDriverTracking() async {
    if (!_isInitialized || !_isSubscribedToDriverTracking || _driverTrackingOrderId == null) {
      _isSubscribedToDriverTracking = false;
      return;
    }
    try {
      final channel = PusherConstants.driverLiveTrackingChannel(_driverTrackingOrderId!);
      await _pusher.unsubscribe(channelName: channel);
      _isSubscribedToDriverTracking = false;
      log('PusherService: unsubscribed from $channel');
    } catch (e, st) {
      log('PusherService: driver tracking unsubscribe failed: $e', stackTrace: st);
      _isSubscribedToDriverTracking = false;
    }
  }

  void setWaitingOrderId(String orderId) {
    _waitingForOrderId = orderId;
    log('PusherService: waiting for order $orderId');

    if (_bufferedTerminalStatus != null && OrderWaitHelper.isTerminalStatus(_bufferedTerminalStatus)) {
      _emitTerminalStatus(_bufferedTerminalStatus!);
    }
  }

  void _onEvent(PusherEvent event) {
    if (_driverTrackingOrderId != null &&
        event.channelName == PusherConstants.driverLiveTrackingChannel(_driverTrackingOrderId!)) {
      _onDriverLocationEvent(event);
      return;
    }

    if (event.channelName != PusherConstants.orderUpdateChannel) return;

    final status = _parseTerminalStatus(event);
    if (status == null) return;

    log('PusherService: terminal status event=${event.eventName} status=$status');

    if (_waitingForOrderId == null) return;

    final eventOrderId = _extractOrderId(event);
    if (eventOrderId == null || eventOrderId != _waitingForOrderId) return;

    _emitTerminalStatus(status);
  }

  void _onDriverLocationEvent(PusherEvent event) {
    if (event.eventName != PusherConstants.driverLocationUpdateEvent) {
      log('PusherService: driver channel ignored event=${event.eventName}');
      return;
    }

    final payload = _parseEventData(event);
    if (payload == null) return;

    final orderId = payload['order_id']?.toString() ?? '';
    if (_driverTrackingOrderId != null && orderId.isNotEmpty && orderId != _driverTrackingOrderId) {
      log('PusherService: driver update ignored — order $orderId != $_driverTrackingOrderId');
      return;
    }

    final lat = double.tryParse(payload['lat']?.toString() ?? '') ?? 0.0;
    final lon = double.tryParse(payload['lon']?.toString() ?? '') ?? 0.0;
    if (lat == 0.0 && lon == 0.0) return;

    final update = DriverLocationUpdate(
      orderId: orderId.isNotEmpty ? orderId : (_driverTrackingOrderId ?? ''),
      driverId: payload['driver_id']?.toString() ?? '',
      lat: lat,
      lon: lon,
    );

    log('PusherService: driver-location-update lat=$lat lon=$lon order=${update.orderId}');
    if (!_driverLocationController.isClosed) {
      _driverLocationController.add(update);
    }
  }

  Map<String, dynamic>? _parseEventData(PusherEvent event) {
    try {
      if (event.data is String) {
        return jsonDecode(event.data as String) as Map<String, dynamic>;
      }
      if (event.data is Map) {
        return Map<String, dynamic>.from(event.data as Map);
      }
    } catch (e, st) {
      log('PusherService: failed to parse event data: $e', stackTrace: st);
    }
    return null;
  }

  String? _parseTerminalStatus(PusherEvent event) {
    if (PusherConstants.terminalEventNames.contains(event.eventName)) {
      return event.eventName;
    }
    return null;
  }

  String? _extractOrderId(PusherEvent event) {
    final eventData = _parseEventData(event);
    if (eventData == null) return null;

    final orderData = eventData['order_data'];
    if (orderData is Map) {
      return orderData['order_id']?.toString();
    }
    return null;
  }

  void _emitTerminalStatus(String status) {
    _bufferedTerminalStatus = status;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  /// Tear down order-update listening. Keeps driver tracking alive when active.
  Future<void> disconnect() async {
    _waitingForOrderId = null;
    _bufferedTerminalStatus = null;
    _wantsOrderUpdateChannel = false;

    if (_isInitialized) {
      try {
        if (_isSubscribedToOrderUpdate) {
          await _pusher.unsubscribe(channelName: PusherConstants.orderUpdateChannel);
          _isSubscribedToOrderUpdate = false;
        }
      } catch (e, st) {
        log('PusherService: order-update unsubscribe error: $e', stackTrace: st);
      }
    }

    await _maybeDisconnectSocket();
    log('PusherService: order-wait disconnected');
  }

  Future<void> _maybeDisconnectSocket() async {
    if (_wantsOrderUpdateChannel || _wantsDriverTrackingChannel) {
      log('PusherService: socket kept alive (orderWait=$_wantsOrderUpdateChannel driver=$_wantsDriverTrackingChannel)');
      return;
    }

    if (!_isInitialized) return;

    try {
      _intentionalDisconnect = true;
      await _pusher.disconnect();
      _isConnected = false;
      log('PusherService: socket disconnected');
    } catch (e, st) {
      log('PusherService: disconnect error: $e', stackTrace: st);
    }
  }
}
