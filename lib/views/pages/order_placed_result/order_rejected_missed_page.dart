import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:sanmiwago_user/views/pages/home/home_menu_page.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderRejectedMissedPage extends StatelessWidget {
  const OrderRejectedMissedPage({
    super.key,
    required this.isRejected,
  });

  final bool isRejected;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //+ clear cart and everything.
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
          title: "Order ${isRejected ? "Rejected" : "Missed"}",
          haveBackIcon: false,
        ),
        body: MyFormPage(
          pageTopPadding: Get.height * 0.05,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.kPureRedColor,
                borderRadius: BorderRadius.circular(10),
              ),
              // height: Get.height * 0.6,
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                children: [
                  MyText(
                    text: "Your order was ${isRejected ? "Rejected" : "Missed"}",
                    color: AppColors.kWhiteColor,
                    align: TextAlign.center,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    paddingTop: 10,
                    paddingLeft: 10,
                    paddingRight: 10,
                    paddingBottom: 10,
                  ),
                  MyText(
                    text: "Invoice #: ${orderController.selectedOrderData.value.order.invoiceNumber}",
                    // text: "Order #: ${orderController.selectedOrderData.value.order.orderId}",
                    color: AppColors.kWhiteColor,
                    align: TextAlign.center,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    paddingTop: 10,
                    paddingLeft: 10,
                    paddingRight: 10,
                    paddingBottom: 10,
                  ),
                  const MyText(
                    text: "We are extremely sorry. We cannot serve your order at this time. "
                        "Your payment method has not been charged yet. We look forward to serving "
                        "you in the future!",
                    color: AppColors.kWhiteColor,
                    align: TextAlign.center,
                    fontSize: 18,
                    paddingTop: 0,
                    paddingLeft: 10,
                    paddingRight: 10,
                    paddingBottom: 40,
                  ),
                ],
              ),
            ),
            const MyText(
              text: "Generally this happens if: ",
              align: TextAlign.left,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              paddingTop: 20,
              paddingBottom: 10,
              paddingLeft: 10,
              paddingRight: 10,
            ),
            Row(
              children: [
                const SizedBox(width: 25),
                const Icon(Icons.circle, size: 10, color: AppColors.kBlackColor),
                const SizedBox(width: 9),
                Expanded(
                  child: MyText(
                    text: isRejected ? "You are outside our delivery area." : "Our staff is super busy and unable to handle your order so fast.",
                    height: 1.3,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    align: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 25),
                const Icon(Icons.circle, size: 10, color: AppColors.kBlackColor),
                const SizedBox(width: 9),
                Expanded(
                  child: MyText(
                    text: isRejected ? "We ran out of the item you ordered." : "We are experiencing issues connecting to our servers.",
                    overflow: TextOverflow.ellipsis,
                    height: 1.3,
                    maxLines: 2,
                    align: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const SizedBox(width: 25),
                const Icon(Icons.circle, size: 10, color: AppColors.kBlackColor),
                const SizedBox(width: 9),
                Expanded(
                  child: MyText(
                    text: isRejected ? "We have other operational issue." : "There are other technical problems.",
                    overflow: TextOverflow.ellipsis,
                    height: 1.3,
                    maxLines: 2,
                    align: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: MyButton(
                  text: "Menu",
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
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                child: MyButton(
                  text: isRejected ? restaurantController.selectedRestaurantPhone.value : "Try again",
                  icon: isRejected ? Icons.wifi_calling_3_outlined : Icons.refresh,
                  fontSize: isRejected ? 16 : 18,
                  // height: 52,
                  // width: Get.width * .60,
                  padding: 0,
                  marginBottom: 10,
                  color: AppColors.kGreenColor,
                  onPressed: () async {
                    if (!isRejected) {
                      if (!apiController.isPlacingOrder.value) {
                        apiController.placeOrder();
                      }
                    } else {
                      final call = Uri.parse('tel:${restaurantController.selectedRestaurantPhone.value}');
                      if (await canLaunchUrl(call)) {
                        launchUrl(call);
                      } else {
                        showMsg(msg: "Could not make a call.");
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
