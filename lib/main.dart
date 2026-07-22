import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/api_constants.dart';
import 'package:sanmiwago_user/constants/app_strings.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/theme/light_theme.dart';
import 'firebase_options.dart';
import 'views/pages/launch/splash_screen.dart';

AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  const env = String.fromEnvironment("env");
  log("env from dart custom env came out to be: $env");

  ApiConstants.setEnvironment(newEnv: env.isNotEmpty ? env : EnvType.merge);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (ApiConstants.env == EnvType.dev ||
        ApiConstants.env == EnvType.merge ||
        ApiConstants.env == EnvType.ddev ||
        ApiConstants.env == EnvType.prod1 ||
        ApiConstants.env == EnvType.prod1old ||
        ApiConstants.env == EnvType.prod1new ||
        // ApiConstants.env == EnvType.prod2 ||
        ApiConstants.env == EnvType.prodaws ||
        ApiConstants.env == EnvType.prodbackup) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Banner(
          location: BannerLocation.topStart,
          color: Colors.redAccent,
          message: ApiConstants.appTag,
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: appName,
            theme: lightTheme,
            themeMode: ThemeMode.light,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                child: child!,
              );
            },
            home: const SplashScreen(),
            // home: const BottomNavBarPage(),
          ),
        ),
      );
    } else {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: lightTheme,
        themeMode: ThemeMode.light,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.noScaling,
              // textScaler: TextScaler.linear(1.0).clamp(maxScaleFactor: 1.2),
            ),
            child: child!,
          );
        },
        home: const SplashScreen(),
        // home: const BottomNavBarPage(),
      );
    }
  }
}
