import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';
import 'package:sanmiwago_user/data/local_db.dart';
import 'package:sanmiwago_user/firebase_options.dart';
import 'package:sanmiwago_user/views/pages/cart/cart_page.dart';
import 'package:sanmiwago_user/views/pages/home/home_menu_page.dart';
import 'package:sanmiwago_user/views/pages/restaurants_list/restaurants_list_page.dart';

import '../constants/controller_instances.dart';
import '../controllers/auth_controller.dart';
import '../controllers/bottom_nav_bar_controller.dart';
import '../main.dart';
import '../views/pages/bottom_nav_bar/bottom_nav_bar.dart';
import '../views/pages/login/login_page.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  bool _isInitialized = false;
  bool _controllersReady = false;
  String? _pendingFcmToken;
  String? _cachedFcmToken;

  String? get cachedFcmToken => _cachedFcmToken;

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await _messaging.setAutoInitEnabled(true);

    await _requestPermission();
    await _messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedAppMessage);
    _messaging.onTokenRefresh.listen(_handleTokenRefresh);

    final token = await _messaging.getToken();
    if (token != null) {
      log('NotificationService: Current FCM token => $token');
      _cacheToken(token);
      await _persistToken(token);
    }

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true, provisional: false);
    log('NotificationService: Authorization status => ${settings.authorizationStatus}');
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    _logMessage('onMessage', message);

    // Don't show cart_reminder notifications when app is in foreground
    final type = message.data['type']?.toString().toLowerCase();
    if (type == 'cart_reminder') {
      log('NotificationService: Suppressing cart_reminder notification in foreground and ${message.data}');
      return;
    }

    await _showFlutterNotification(message);
  }

  void _handleOpenedAppMessage(RemoteMessage message) {
    _logMessage('onMessageOpenedApp', message);
    _handleNavigationFromMessage(message);
  }

  void _handleInitialMessage(RemoteMessage message) {
    _logMessage('getInitialMessage', message);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigationFromMessage(message);
    });
  }

  void _cacheToken(String token) {
    _cachedFcmToken = token;
  }

  Future<void> _persistToken(String token) async {
    _pendingFcmToken = token;
    if (!_controllersReady || !Get.isRegistered<AuthController>()) {
      log('NotificationService: Controllers not ready; deferring token persistence');
      return;
    }

    try {
      await authController.saveUserFCM(token: token);
      _pendingFcmToken = null;
    } catch (e) {
      log('NotificationService: Failed to persist token => $e');
    }
  }

  Future<void> onControllersReady() async {
    _controllersReady = true;
    final token = _pendingFcmToken;
    if (token != null) {
      await _persistToken(token);
    }
  }

  void _handleTokenRefresh(String token) {
    log('NotificationService: FCM token refreshed => $token');
    _cacheToken(token);
    _persistToken(token);
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    _logMessage('onBackgroundMessage', message);
    // await _showFlutterNotification(message);
  }

  void _logMessage(String source, RemoteMessage message) {
    log(
      'NotificationService:$source id=${message.messageId} '
      'title=${message.notification?.title} data=${message.data}',
    );
  }

  Future<void> _showFlutterNotification(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title']?.toString();
    final body = notification?.body ?? message.data['body']?.toString();

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    final payload = message.data.isEmpty ? null : jsonEncode(message.data);

    final androidDetails = AndroidNotificationDetails(
      channel?.id ?? 'high_importance_channel_sanmi_user',
      channel?.name ?? 'Sanmiwago User',
      channelDescription: channel?.description,
      importance: Importance.max,
      priority: Priority.high,
      icon: notification?.android?.smallIcon, // ?? 'ic_stat_notification',
      styleInformation: BigTextStyleInformation(body ?? title ?? '', contentTitle: title, htmlFormatBigText: false, htmlFormatContent: false),
    );

    const iosDetails = DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true);

    final notificationId = notification?.hashCode ?? message.hashCode;

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }

  void _handleNavigationFromMessage(RemoteMessage message) {
    _handleNavigationFromData(message.data);
  }

  Future<void> _handleNavigationFromData(Map<String, dynamic> data) async {
    final type = data['type']?.toString().toLowerCase();
    final status = data['status']?.toString().toLowerCase();
    print("NotificationService: type from notification is: $type");
    if (type == 'order') {
      if (status == "accept") {
        final orderId = data['order_id']?.toString();
        if (orderId != null) {
          print("NotificationService: Order accepted (orderId: $orderId), clearing cart...");

          // Opening Isar
          var isar = Isar.getInstance("default");
          print("NotificationService: before cart clear, isar is: $isar");

          initializeControllers();
          await LocalDatabase.initialize(doFurtherInitializations: false);

          // Clear all order data (cart, discounts, tips, etc.) from memory
          orderController.clearOrderData(clearLocalCart: false);
          print("NotificationService: Order data cleared from memory (cart, discounts, tips, etc.)");

          // Wait for database clear to complete (clearOrderData() calls clearLocalCartFromDb() but doesn't await it)
          // We need to ensure the database is actually cleared before loading
          await orderController.clearLocalCartFromDb();
          print("NotificationService: Cart cleared from database");

          // Load cart (will be empty now)
          await orderController.loadCartFromDb();
          print("NotificationService: Cart reloaded (should be empty)");

          print("NotificationService: after cart clear, isar is: $isar");
        }
      }
      _navigateToOrdersTab();
    }
    /* + This is getting executed again from getInitialMessage's data so commenting it for now  + */
    // else if (type == 'cart_reminder') {
    //   _navigateToCart();
    // }
  }

  void _navigateToOrdersTab() {
    if (!Get.isRegistered<BottomNavBarController>() || Get.key.currentState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToOrdersTab());
      return;
    }
    log("Get.currentRoute: ${Get.currentRoute}");
    if (Get.currentRoute == '/BottomNavBarPage') {
      bottomNavBarController.updateIndex(2);
    } else {
      bottomNavBarController.updateIndex(2);
      Get.offAll(() => const BottomNavBarPage());
    }
  }

  /* + This is getting executed again from getInitialMessage's data so commenting it for now  + */
  // Future<void> _navigateToCart() async {
  //   if (!Get.isRegistered<BottomNavBarController>() || Get.key.currentState == null) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToOrdersTab());
  //     return;
  //   }
  //   log("Get.currentRoute: ${Get.currentRoute}");
  //   // await Future.delayed(Duration(milliseconds: 1500));
  //   if (authController.userData.value.id.isNotEmpty || authController.isContinuedAsGuest.value) {
  //     if (restaurantController.selectedRestaurant.value.id.isEmpty) {
  //       Get.off(() => const RestaurantsListPage());
  //     } else {
  //       // Get.to(() => const CartPage());
  //       bottomNavBarController.updateIndex(0);
  //       Get.off(() => const BottomNavBarPage(homeReload: true));
  //     }
  //   } else {
  //     Get.off(() => LoginPage(isFromCart: false));
  //     // Get.to(() => LoginPage(isFromCart: true));
  //   }
  // }

  void _handleLocalNotificationPayload(String payload) {
    try {
      final dynamic decoded = jsonDecode(payload);
      if (decoded is Map<String, dynamic>) {
        _handleNavigationFromData(decoded);
      } else if (decoded is Map) {
        _handleNavigationFromData(decoded.map((key, value) => MapEntry(key.toString(), value)));
      }
    } catch (e) {
      log('NotificationService: Failed to parse notification payload => $e');
    }
  }

  static Future<void> initLocalNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: const AndroidInitializationSettings('@drawable/ic_stat_notification'),
          iOS: const DarwinInitializationSettings(requestSoundPermission: true, requestBadgePermission: true, requestAlertPermission: true),
        ),
        onDidReceiveNotificationResponse: (details) {
          final payload = details.payload;
          if (payload != null && payload.isNotEmpty) {
            NotificationService.instance._handleLocalNotificationPayload(payload);
          }
        },
      );
    } catch (e) {
      log('NotificationService: Failed to initialize local notifications => $e');
    }
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.handleBackgroundMessage(message);
}
