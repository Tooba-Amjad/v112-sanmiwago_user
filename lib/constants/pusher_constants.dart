class PusherConstants {
  static const String cluster = 'ap2';
  static const String orderUpdateChannel = 'order-update';

  /// Per-order driver tracking channel prefix — full name is `driver-live-tracking-{order_id}`.
  static const String driverLiveTrackingChannelPrefix = 'driver-live-tracking-';
  static const String driverLocationUpdateEvent = 'driver-location-update';

  /// Terminal statuses on `order-update` — event name equals status (e.g. accept, cancelled).
  static const Set<String> terminalEventNames = {
    'accept',
    'delivered',
    'missed',
    'cancelled',
  };

  static String driverLiveTrackingChannel(String orderId) => '$driverLiveTrackingChannelPrefix$orderId';
}
