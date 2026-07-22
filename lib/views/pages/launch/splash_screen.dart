import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_images.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/data/local_db.dart';
import 'package:sanmiwago_user/data/shared_pref.dart';
import 'package:sanmiwago_user/services/notification_service.dart';
import 'package:sanmiwago_user/services/pusher/pusher_service.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:sanmiwago_user/views/pages/restaurants_list/restaurants_list_page.dart';
import 'package:upgrader/upgrader.dart';

import '../../../main.dart';
import '../../../utils/snack_bar.dart';
import '../../widgets/my_button.dart';
import '../staging_page/staging_page.dart';
import '../../../firebase_options.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<void> _initFuture = _initializeApp();

  Future<void> _initializeApp() async {
    // Initialize Firebase and local resources in parallel where possible.
    final List<Future<void>> tasks = [];

    initializeControllers();

    // tasks.add(Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform));

    tasks.add(LocalDatabase.initialize());
    tasks.add(LocalSharedPrefDatabase.init());

    // Set up notifications (channel + permissions + local notifications)
    tasks.add(_setupNotifications());

    // Initialize GetX controllers - moved out to start to avoid putting it in future
    // tasks.add(
    //   Future<void>(() {
    //     initializeControllers();
    //   }),
    // );

    // Optional update check (Android only). Do not block other tasks; run in parallel.
    if (Platform.isAndroid) {
      tasks.add(checkForUpdate());
    } else {
      AppConstants.fallbackToUpgrader = true;
    }

    /// delayed because we need to wait for the controllers to get initialized
    tasks.add(apiController.getSiteInfo());
    tasks.add(apiController.getSalesTax());
    // tasks.add(Future.delayed(Duration(milliseconds: 150), () => apiController.getSiteInfo()));
    // tasks.add(Future.delayed(Duration(milliseconds: 150), () => apiController.getSalesTax()));

    await Future.wait(tasks);

    tasks.clear();

    /// call the local cart load here because we have got the sales tax by this point
    tasks.add(orderController.loadCartFromDb());

    await Future.wait(tasks);

    // Notify NotificationService that controllers are ready after base initialization.
    await NotificationService.instance.onControllersReady();

    // Prefetch Pusher key only (no socket). Connect happens on place/redeem.
    unawaited(PusherService.instance.prefetchCredentials());
  }

  Future<void> _setupNotifications() async {
    try {
      channel = AndroidNotificationChannel('high_importance_channel_sanmi_user', 'Sanmiwago User', importance: Importance.max);
      // final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel!);
      await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

      await NotificationService.initLocalNotifications();
      await NotificationService.instance.initialize();
    } catch (e) {
      log("Notification setup failed: $e");
    }
  }

  Future<void> checkForUpdate() async {
    AppUpdateInfo? updateInfo;

    InAppUpdate.checkForUpdate()
        .then((info) {
          // setState(() {
          updateInfo = info;
          if (updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
            if (AppConstants.shouldRequireUpdate) {
              InAppUpdate.performImmediateUpdate().catchError((e) {
                // showMsg(
                //   msg: "Something went wrong. Please update the app from Play store to keep using the app.",
                //   time: const Duration(seconds: 4),
                // );

                AppConstants.fallbackToUpgrader = true;

                log("error in app update: ${e.toString()}");
                return AppUpdateResult.inAppUpdateFailed;
              });
            } else {
              InAppUpdate.startFlexibleUpdate()
                  .whenComplete(() {
                    InAppUpdate.completeFlexibleUpdate();
                  })
                  .catchError((e) {
                    // showMsg(
                    //   msg: "Something went wrong. Please update the app from Play store to keep using the app.",
                    //   time: const Duration(seconds: 4),
                    // );

                    AppConstants.fallbackToUpgrader = true;

                    log("error in app update: ${e.toString()}");
                    return AppUpdateResult.inAppUpdateFailed;
                  });
            }
          }
          // });
        })
        .catchError((e) {
          AppConstants.fallbackToUpgrader = true;

          // showMsg(
          //   msg: "Something went wrong while checking for updates. Please update the app "
          //       "from Play store for latest bug fixes and improvements.",
          //   time: const Duration(seconds: 4),
          // );
        });
  }

  @override
  void initState() {
    super.initState();
    _initFuture.whenComplete(() {
      if (!mounted) return;
      Future.delayed(const Duration(seconds: 1), () {
        if (Get.currentRoute == '/SplashScreen' || Get.currentRoute == '/') {
          navigate(type: PageType.offAll, page: const StagingPage());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    log("AppConstants.fallbackToUpGrader: ${AppConstants.fallbackToUpgrader}");
    return Scaffold(
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.splashPadding),
                child: Center(child: Image.asset(AppImages.appbarLogo, height: AppSizes.splashLogoHeight)),
              ),
              const SizedBox(height: 24),
              if (snapshot.connectionState == ConnectionState.waiting || snapshot.connectionState == ConnectionState.done)
                const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 2.8, color: AppColors.kLogoBasedColor))
              else if (snapshot.hasError)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    'Something went wrong while starting the app.\nPlease try again.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
