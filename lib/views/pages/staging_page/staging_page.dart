import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/pages/restaurants_list/restaurants_list_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:upgrader/upgrader.dart';

import '../../../constants/app_constants.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_sizes.dart';
import '../../../utils/enums.dart';
import '../../../utils/helpers.dart';

class StagingPage extends StatelessWidget {
  const StagingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppConstants.fallbackToUpgrader
        ? UpgradeAlert(
            // canDismissDialog: !AppConstants.shouldRequireUpdate,
            showIgnore: false,
            showLater: false,
            dialogStyle: Platform.isAndroid ? UpgradeDialogStyle.material : UpgradeDialogStyle.cupertino,
            upgrader: Upgrader(),
            child: Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.splashPadding),
                    child: Center(
                      child: Image.asset(
                        AppImages.appbarLogo,
                        height: AppSizes.splashLogoHeight,
                      ),
                    ),
                  ),
                  Center(
                    child: MyButton(
                      text: "Order Now",
                      color: AppColors.kLogoBasedColor,
                      width: Get.width * .6,
                      marginTop: 0,
                      onPressed: () {
                        if (!authController.isLoggedIn.value) {
                          navigate(
                            type: PageType.to,
                            page: const LoginPage(isFromSplash: true),
                            // page: const BottomNavBarPage(),
                          );
                        } else {
                          navigate(
                            type: PageType.to, // offAll,
                            page: const RestaurantsListPage(isFromSplash: true),
                            // page: const BottomNavBarPage(),
                            // page: const HomeMenuPage(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.splashPadding),
                  child: Center(
                    child: Image.asset(
                      AppImages.appbarLogo,
                      height: AppSizes.splashLogoHeight,
                    ),
                  ),
                ),
                Center(
                  child: MyButton(
                    text: "Order Now",
                    color: AppColors.kLogoBasedColor,
                    width: Get.width * .6,
                    marginTop: 0,
                    onPressed: () {
                      if (!authController.isLoggedIn.value) {
                        navigate(
                          type: PageType.to,
                          page: const LoginPage(isFromSplash: true),
                          // page: const BottomNavBarPage(),
                        );
                      } else {
                        navigate(
                          type: PageType.to, // offAll,
                          page: const RestaurantsListPage(isFromSplash: true),
                          // page: const BottomNavBarPage(),
                          // page: const HomeMenuPage(),
                        );
                      }
                      // navigate(
                      //   type: PageType.to,
                      //   page: const RestaurantsListPage(isFromSplash: true),
                      //   // page: const BottomNavBarPage(),
                      // );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
