import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/my_orders_model.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_order_details_page.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_order_door_dash_detail_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_listtile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';

// ignore_for_file: must_be_immutable
class MyOrderContainer extends StatelessWidget {
  MyOrderContainer({
    super.key,
    required this.id,
    required this.status,
    required this.price,
    required this.paymentType,
    required this.isPointRedeemed,
    required this.dateTime,
    this.isReferralOrder = false,
    this.userName = "",
    this.userEmail = "",
    this.userPhone = "",
    required this.order,
  });

  final String id;
  final String status;
  final String price;
  final String paymentType;
  final String isPointRedeemed;
  final String dateTime;
  final bool isReferralOrder;
  RxBool isClicked = false.obs;

  final String userName;
  final String userEmail;
  final String userPhone;
  final MyOrder order;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColors.kSkyLightDullColor, width: 2),
      ),
      child: Obx(() {
        return Column(
          children: [
            MyListTile(
              onTap: () {
                log("clicked order thingy");
                isClicked.value = !isClicked.value;
                myOrdersController.clickedOrderId.value = id;
              },
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              title: MyText(
                text: "(Invoice # ${order.invoiceNumber})",
                // text: "(Order # $id)",
                fontSize: 16,
              ),
              subtitle: MyText(
                text: getStatus(status),
                fontSize: 14,
                color: getColour(status),
              ),
              trailing: MyText(
                text: "\$${order.isPointsRedeemed.toLowerCase() != "yes" ? price : "0.0"}",
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              trailingTopPadding: 10,
            ),
            isClicked.value && myOrdersController.clickedOrderId.value == id
                ? !isReferralOrder
                    ? Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xffefa581), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MyText(
                              text: "Payment Details",
                              fontSize: 15,
                              color: AppColors.kBlackColor,
                              paddingTop: 5,
                              paddingBottom: 10,
                            ),
                            MyText(
                              text:
                                  "Item total: \$${order.isPointsRedeemed.toLowerCase() == "yes"
                                      ? order.status == "undeliverable_and_refunded" ? ((double.tryParse(order.totalCost) ?? 0.0) ).toPrecision(2).toStringAsFixed(2)
                                      : ((double.tryParse(order.totalCost) ?? 0.0) - (double.tryParse(order.salesTax) ?? 0.0)).toPrecision(2).toStringAsFixed(2)
                                      : price}",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                            ),
                            MyText(
                              text: "Is Points Redeemed: $isPointRedeemed",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                            ),
                            order.isPointsRedeemed.toLowerCase() == "yes"
                                ? MyText(
                                    text: "No of points redeemed: ${order.noOfPointsRedeemed}",
                                    fontSize: 14,
                                    color: AppColors.kGreyColor,
                                  )
                                : const SizedBox(),
                            // order.isPointsRedeemed.toLowerCase() == "yes"
                            //     ? MyText(
                            //         text: "Points value: \$${order.noOfPointsRedeemed}",
                            //         fontSize: 14,
                            //         color: AppColors.kGreyColor,
                            //       )
                            //     : const SizedBox(),
                            order.paymentType.toLowerCase() == "stripe"
                                ? MyText(
                                    text: "Card: \$$price",
                                    fontSize: 14,
                                    color: AppColors.kGreyColor,
                                  )
                                : const SizedBox(),
                            order.paymentType.toLowerCase() == "hybrid"
                                ? MyText(
                                    text: "GiftCard Amount: \$${order.hybridRedeemGiftAmount}",
                                    fontSize: 14,
                                    color: AppColors.kGreyColor,
                                  )
                                : const SizedBox(),
                            order.paymentType.toLowerCase() == "hybrid"
                                ? MyText(
                                    text: "Card Amount: \$${order.paidAmount}",
                                    fontSize: 14,
                                    color: AppColors.kGreyColor,
                                  )
                                : const SizedBox(),

                            order.paymentType.toLowerCase() == "redeemgift"
                                ? MyText(
                                    text: "Redeem Gift Amount: \$${(double.tryParse(price) ?? 0.0).toPrecision(2).toStringAsFixed(2)}",
                                    fontSize: 14,
                                    color: AppColors.kGreyColor,
                                  )
                                : const SizedBox(),
                            paymentType.isNotEmpty
                                ? MyText(
                                    text: "Payment mode: ${getPaymentTypeText(paymentType, order.planType)}",
                                    // text: "Payment mode: ${paymentType.toLowerCase() == "stripe" ? "Card" : paymentType.capitalizeItsFirst()}",
                                    fontSize: 14,
                                    color: AppColors.kGreyColor,
                                  )
                                : const SizedBox(),
                            MyText(
                              text: "Ordered Date: ${dateTime.isNotEmpty ? AppConstants.dateFormatWithTime.format(DateTime.tryParse(dateTime) ?? DateTime.now()) : ""}",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                              paddingBottom: 10,
                            ),
                            Obx(() {
                              return MyButton(
                                text: "Details",
                                height: 35,
                                width: Get.width * .25,
                                fontSize: 16,
                                padding: 0,
                                // marginBottom: 10,
                                color: (apiController.isLoadingMyOrderDetails.value) ? AppColors.kGreenColor : AppColors.kButtonRedColor,
                                onPressed: () async {
                                  if (order.deliveryPlatform == "Driver App") {
                                    showCircularLoading();
                                    await myOrdersController.getOrderDetails(id, shouldDismiss: true);
                                    Get.to(
                                      () => const OrderDetailsPage(),
                                      transition: Transition.rightToLeftWithFade,
                                      duration: const Duration(milliseconds: 500),
                                    );
                                  } else {
                                    /// DoorDash Plat Form not implemented yet.
                                    log("DoorDash Plat Form not implemented yet WOrking ");
                                    showCircularLoading();
                                    await myOrdersController.getOrderDetails(id, shouldDismiss: true);
                                    await myOrdersController.getDoorDashOrderDetails(id);
                                    Get.to(
                                      () => DoorDashOrderDetailPage(
                                        order: order,
                                      ),
                                      transition: Transition.rightToLeftWithFade,
                                      duration: const Duration(milliseconds: 500),
                                    );
                                  }
                                },
                              );
                            }),
                          ],
                        ),
                      )
                    //+ isReferralOrder == true
                    : Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: const Color(0xffefa581), width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //+ user details
                            const MyText(
                              text: "User Details",
                              fontSize: 15,
                              color: AppColors.kBlackColor,
                              paddingTop: 5,
                              paddingBottom: 5,
                            ),
                            MyText(
                              text: "Name: $userName",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                            ),
                            MyText(
                              text: "Email: $userEmail",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                            ),
                            MyText(
                              text: "Phone: $userPhone",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                            ),

                            //+ order details
                            const MyText(
                              text: "Order Details",
                              fontSize: 15,
                              color: AppColors.kBlackColor,
                              paddingTop: 5,
                              paddingBottom: 5,
                            ),
                            MyText(
                              text: "Invoice #: ${order.invoiceNumber}",
                              // text: "Order #: $id",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                            ),
                            MyText(
                              text: "Status: ${status.capitalizeFirst}",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                            ),
                            MyText(
                              text: "Item total: $price",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                            ),
                            // MyText(
                            //   text: "Is Points Redeemed: $isPointRedeemed",
                            //   fontSize: 14,
                            //   color: AppColors.kGreyColor,
                            // ),
                            MyText(
                              text: "Payment: ${paymentType.toLowerCase() == "stripe" ? "Card" : paymentType.capitalizeItsFirst()}",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                            ),
                            MyText(
                              text: "Date Time: $dateTime",
                              fontSize: 14,
                              color: AppColors.kGreyColor,
                              paddingBottom: 10,
                            ),
                            Obx(() {
                              return MyButton(
                                text: "Details",
                                height: 35,
                                width: Get.width * .25,
                                fontSize: 16,
                                padding: 0,
                                // marginBottom: 10,
                                color: apiController.isLoadingMyOrderDetails.value ? AppColors.kGreenColor : AppColors.kButtonRedColor,
                                onPressed: () async {
                                  if (order.deliveryPlatform == "Driver App") {
                                    showCircularLoading();
                                    await myOrdersController.getOrderDetails(id, shouldDismiss: true);
                                    Get.to(
                                      () => const OrderDetailsPage(),
                                      transition: Transition.rightToLeftWithFade,
                                      duration: const Duration(milliseconds: 500),
                                    );
                                  } else {
                                    /// DoorDash Plat Formn not implemented yet.
                                    log("DoorDash Plat Formn not implemented yet");
                                  }
                                },
                              );
                            }),
                          ],
                        ),
                      )
                : const SizedBox(),
          ],
        );
      }),
    );
  }
}
