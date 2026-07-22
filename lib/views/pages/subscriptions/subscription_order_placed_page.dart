import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:sanmiwago_user/views/pages/home/home_menu_page.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class SubscriptionOrderPlacedPage extends StatelessWidget {
  final String orderId;
  final String invoiceNumber;

  const SubscriptionOrderPlacedPage({super.key, required this.orderId, required this.invoiceNumber});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        orderController.clearOrderData();
        navigate(
          type: PageType.offAll,
          page: !authController.isLoggedIn.value ? const BottomNavBarPage(homeReload: false) : const BottomNavBarPage(),
          // page: !authController.isLoggedIn.value ? const HomeMenuPage(reload: false) : const BottomNavBarPage(),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.kSkyLightDullColor,
        appBar: simpleAppBar(
          title: "Order Confirmed",
          haveBackIcon: false,
        ),
        body: SizedBox(
          width: Get.width,
          child: MyFormPage(
            pageTopPadding: Get.height * 0.15,
            children: [
              const Center(
                child: MyText(
                  text: "Your order is Confirmed 🤗",
                  color: AppColors.kGreenColor,
                  align: TextAlign.center,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  paddingLeft: 15,
                  paddingRight: 15,
                  paddingBottom: 20,
                  paddingTop: 40,
                ),
              ),
              Center(
                child: MyText(
                  text: invoiceNumber.isNotEmpty ? "Invoice #: $invoiceNumber" : "Order #: $orderId",
                  align: TextAlign.center,
                  fontSize: 32,
                  paddingTop: 10,
                  paddingBottom: 20,
                  paddingLeft: 20,
                  paddingRight: 20,
                ),
              ),
              Center(
                child: SizedBox(
                  width: Get.width * .60,
                  child: MyButton(
                    text: "Go To Menu",
                    icon: Icons.arrow_back_ios_rounded,
                    padding: 0,
                    marginBottom: 10,
                    color: AppColors.kRedColor,
                    onPressed: () {
                      orderController.clearOrderData();
                      navigate(
                        type: PageType.offAll,
                        page: !authController.isLoggedIn.value ? const BottomNavBarPage(homeReload: false) : const BottomNavBarPage(),
                        // page: !authController.isLoggedIn.value ? const HomeMenuPage(reload: false) : const BottomNavBarPage(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
