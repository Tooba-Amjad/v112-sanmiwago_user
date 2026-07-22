import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/my_orders_model.dart';
import 'package:sanmiwago_user/models/order_view_model.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/profile/my_orders_pages/my_order_details_item_widget.dart';
import 'package:sanmiwago_user/views/widgets/common_widgets.dart';
import 'package:sanmiwago_user/views/widgets/my_refund_details_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../../utils/enums.dart';
import '../../location/osm_map.dart';

class DoorDashOrderDetailPage extends StatelessWidget {
  final MyOrder? order;

  const DoorDashOrderDetailPage({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "Invoice # ${myOrdersController.selectedOrderData.value.order.invoiceNumber}",
        // title: "Order # ${myOrdersController.selectedOrderData.value.order.orderId}",
        haveBackIcon: true,
        actions: [
          myOrdersController.selectedOrderData.value.order.refundType.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  clipBehavior: Clip.none,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: MyText(
                      text: "${myOrdersController.selectedOrderData.value.order.refundType.replaceAll("_", " ").capitalizeFirst} Refunded",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox(),

          // + Map button to see driver location.
          (myOrdersController.selectedOrderData.value.order.refundType.isEmpty &&
                  myOrdersController.selectedOrderData.value.order.dmId.isNotEmpty &&
                  myOrdersController.selectedOrderData.value.order.orderType.toLowerCase() == "delivery" &&
                  myOrdersController.selectedOrderData.value.order.status.toLowerCase() == "out_to_deliver")
              ? GestureDetector(
                  onTap: () {
                    locationController.isLoadingDriverLocation.value = true;
                    navigate(
                      type: PageType.to,
                      page: DriverOSMMap(
                        order: myOrdersController.selectedOrderData.value,
                        driverId: myOrdersController.selectedOrderData.value.order.dmId,
                        orderId: myOrdersController.selectedOrderData.value.order.orderId,
                        invoiceNumber: myOrdersController.selectedOrderData.value.order.invoiceNumber,
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: MyText(
                        text: "Track Driver",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),

          myOrdersController.selectedOrderData.value.order.refundType.isEmpty
              ? GestureDetector(
                  onTap: () async {
                    log("Tracking Url is ${myOrdersController.doorDashSelectedOrderData.value.doordashRecords?.trackingUrl}");
                    if (myOrdersController.doorDashSelectedOrderData.value.doordashRecords?.trackingUrl != null) {
                      String url = "${myOrdersController.doorDashSelectedOrderData.value.doordashRecords?.trackingUrl}";
                      String urlFlutter = 'https://flutter.dev';
                      await launchUrlExternal(url);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: MyText(
                        text: "Track Order",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
        onBackPressed: () {
          Get.back();
        },
      ),
      body: Container(
        height: Get.height,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: Colors.white,
        child: Obx(() {
          return myOrdersController.selectedOrderData.value.orderItems.isNotEmpty &&
                  !apiController.isLoadingMyOrderDetails.value &&
                  !apiController.isLoadingDoorDashOrderDetails.value
              ? ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    /* + Locations + */
                    myOrdersController.selectedOrderData.value.order.orderType.toLowerCase() == "delivery"
                        ? TimelineWidget(
                            fromAddress: myOrdersController.selectedOrderData.value.restaurantInfo.isNotEmpty
                                ? myOrdersController.selectedOrderData.value.restaurantInfo.first.address
                                : "",
                            toAddress: getFormattedAddress(
                                myOrdersController.selectedOrderData.value.order.houseNo,
                                myOrdersController.selectedOrderData.value.order.street,
                                myOrdersController.selectedOrderData.value.order.landmark,
                                myOrdersController.selectedOrderData.value.order.city,
                                myOrdersController.selectedOrderData.value.order.state,
                                myOrdersController.selectedOrderData.value.order.zipcode),
                          )
                        : const SizedBox(),
                    dividerCommon(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
                          MyText(
                            text: "${myOrdersController.doorDashSelectedOrderData.value.message}",
                            color: AppColors.kBlackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                text: 'DoorDash Status:',
                                color: AppColors.kGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: "${myOrdersController.doorDashSelectedOrderData.value.doordashStatus}",
                                  color: AppColors.kGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                text: 'Tracking ID:',
                                color: AppColors.kGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: "${myOrdersController.doorDashSelectedOrderData.value.doordashRecords?.supportReference}",
                                  color: AppColors.kGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: AppSizes.formsSizeBoxHeight / 2),

                          // const MyText(
                          //   text: 'PickUp Estimated Time:',
                          //   color: AppColors.kBlackColor,
                          //   fontSize: 16,
                          //   fontWeight: FontWeight.w600,
                          // ),
                          // Obx(() {
                          //   return MyText(
                          //     text: "${myOrdersController.doorDashSelectedOrderData.value.doordashRecords?.pickupTimeEstimated}",
                          //     color: AppColors.kGreyColor,
                          //     fontSize: 16,
                          //     fontWeight: FontWeight.w600,
                          //   );
                          // }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                text: 'Pickup Time:',
                                color: AppColors.kGreyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: myOrdersController.doorDashSelectedOrderData.value.doordashRecords?.pickupTimeEstimated != null
                                      ? AppConstants.dateFormatWithTime.format(DateTime.tryParse(
                                              myOrdersController.doorDashSelectedOrderData.value.doordashRecords?.pickupTimeEstimated?.toString().split(".")[0] ?? "") ??
                                          DateTime.now())
                                      : "",
                                  color: AppColors.kGreyColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          ),
                          SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                text: 'Drop-off Time:',
                                color: AppColors.kGreyColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: myOrdersController.doorDashSelectedOrderData.value.doordashRecords?.dropoffTimeEstimated != null
                                      ? AppConstants.dateFormatWithTime.format(DateTime.tryParse(
                                              myOrdersController.doorDashSelectedOrderData.value.doordashRecords?.dropoffTimeEstimated.toString().split(".")[0] ?? "") ??
                                          DateTime.now())
                                      : "",
                                  color: AppColors.kGreyColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppSizes.formsSizeBoxHeight / 2),

                    dividerCommon(),

                    /* + Items + */
                    Obx(() {
                      return ListView.builder(
                        shrinkWrap: true,
                        // reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: myOrdersController.selectedOrderData.value.orderItems.length,
                        itemBuilder: (BuildContext context, int index) {
                          OrderItem orderItem = myOrdersController.selectedOrderData.value.orderItems[index];

                          return Column(
                            children: [
                              MyOrderDetailsItemWidget(
                                index: index,
                                orderItem: orderItem,
                                totalItemPrice: double.tryParse(orderItem.finalCost) ?? 0.0,
                              ),
                              dividerCommon(),
                            ],
                          );
                        },
                      );
                    }),
                    const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
                    /* + Delivery Note + */
                    Obx(() {
                      return myOrdersController.selectedOrderData.value.order.deliveryNote.isNotEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const MyText(
                                  text: 'Delivery Note:',
                                  color: AppColors.kGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                Expanded(
                                  child: MyText(
                                    text: myOrdersController.selectedOrderData.value.order.deliveryNote,
                                    color: AppColors.kGreyColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    paddingLeft: 10,
                                  ),
                                )
                                // Obx(() {
                                //   return ;
                                // }),
                              ],
                            )
                          : const SizedBox();
                    }),
                    const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),

                    Obx(() {
                      return myOrdersController.selectedOrderData.value.order.deliveryNote.isNotEmpty
                          ? Column(
                              children: [
                                dividerCommon(),
                                const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
                              ],
                            )
                          : const SizedBox();
                    }),

                    Obx(() {
                      return (double.tryParse(myOrdersController.selectedOrderData.value.order.discount) ?? 0.0) != 0
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const MyText(
                                  text: 'Discount:',
                                  color: AppColors.kGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                MyText(
                                  text: '-\$${myOrdersController.selectedOrderData.value.order.discount}',
                                  color: AppColors.kGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )
                                // Obx(() {
                                //   return ;
                                // }),
                              ],
                            )
                          : const SizedBox();
                    }),

                    /*+ Sub total Row +*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MyText(
                          text: 'Sub-Total:',
                          color: AppColors.kGreyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        Obx(() {
                          return MyText(
                            text: myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes" &&
                                    myOrdersController.selectedOrderData.value.order.couponPercentage.isEmpty
                                ? "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.realSubtotal) ?? 0.0).toStringAsFixed(2)}"
                                // ? "\$${((double.tryParse(myOrdersController.selectedOrderData.value.order.totalCost) ?? 0.0) - (double.tryParse(myOrdersController.selectedOrderData.value.order.salesTax) ?? 0.0) - (double.tryParse(myOrdersController.selectedOrderData.value.order.staffTip) ?? 0.0)).toStringAsFixed(2)}"
                                : "\$${myOrdersController.selectedOrderData.value.orderItems.fold(0.0, (previousValue, item) => previousValue + (double.tryParse(item.finalCost) ?? 0.0)).toPrecision(2).toStringAsFixed(2)}",
                            // "\$${((double.tryParse(myOrdersController.selectedOrderData.value.order.totalCost) ?? 0.0) - (double.tryParse(myOrdersController.selectedOrderData.value.order.salesTax) ?? 0.0)).toStringAsFixed(2)}",
                            color: AppColors.kGreyColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          );
                        }),
                      ],
                    ),

                    /*+ Discount Row +*/
                    myOrdersController.selectedOrderData.value.order.couponPercentage.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: 'Discount (${(double.tryParse(myOrdersController.selectedOrderData.value.order.couponPercentage) ?? 0.0).formatNumber()}%):',
                                color: AppColors.kGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: "- \$${myOrdersController.selectedOrderData.value.order.couponDiscount}",
                                  // "\$${myOrdersController.selectedOrderData.value.orderItems.fold(0.0, (previousValue, item) => previousValue + (double.tryParse(item.finalCost) ?? 0.0)).toPrecision(2).toStringAsFixed(2)}",
                                  // "\$${((double.tryParse(myOrdersController.selectedOrderData.value.order.totalCost) ?? 0.0) - (double.tryParse(myOrdersController.selectedOrderData.value.order.salesTax) ?? 0.0)).toStringAsFixed(2)}",
                                  color: AppColors.kGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          )
                        : const SizedBox(),

                    myOrdersController.selectedOrderData.value.order.couponPercentage.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: dividerCommon(),
                          )
                        : const SizedBox(),

                    /*+ Discounted Sub total Row +*/
                    myOrdersController.selectedOrderData.value.order.couponPercentage.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                text: 'Sub-Total (Discounted):',
                                color: AppColors.kGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes"
                                      ? "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.realSubtotal) ?? 0.0).toStringAsFixed(2)}"
                                      // ? "\$${((double.tryParse(myOrdersController.selectedOrderData.value.order.totalCost) ?? 0.0) - (double.tryParse(myOrdersController.selectedOrderData.value.order.salesTax) ?? 0.0) - (double.tryParse(myOrdersController.selectedOrderData.value.order.staffTip) ?? 0.0)).toStringAsFixed(2)}"
                                      : "\$${myOrdersController.selectedOrderData.value.orderItems.fold(0.0, (previousValue, item) => previousValue + (double.tryParse(item.finalCost) ?? 0.0)).toPrecision(2).toStringAsFixed(2)}",
                                  // "\$${((double.tryParse(myOrdersController.selectedOrderData.value.order.totalCost) ?? 0.0) - (double.tryParse(myOrdersController.selectedOrderData.value.order.salesTax) ?? 0.0)).toStringAsFixed(2)}",
                                  color: AppColors.kGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          )
                        : const SizedBox(),

                    /*+ Delivery Fee Row +*/
                    myOrdersController.selectedOrderData.value.order.orderType.toLowerCase() == "delivery"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                text: 'Delivery fee:',
                                color: AppColors.kGreyColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes"
                                      ? "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.doordashDeliveryFee) ?? 0.0).toPrecision(2).toStringAsFixed(2)}"
                                      : "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.doordashDeliveryFee) ?? 0.0).toPrecision(2).toStringAsFixed(2)}",
                                  // "\$${((double.tryParse(myOrdersController.selectedOrderData.value.order.totalCost) ?? 0.0) - (double.tryParse(myOrdersController.selectedOrderData.value.order.salesTax) ?? 0.0)).toStringAsFixed(2)}",
                                  color: AppColors.kGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          )
                        : const SizedBox(),

                    /*+ Sales Tax Row +*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyText(
                          text: 'Sales Tax (${siteDataController.salesTax.value}%):',
                          color: AppColors.kGreyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        Obx(() {
                          return MyText(
                            text:
                                "\$${myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes" ? (double.tryParse(myOrdersController.selectedOrderData.value.order.realSaleTax) ?? 0.0).toStringAsFixed(2) : "0.00"}",
                            color: AppColors.kGreyColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          );
                        }),
                      ],
                    ),

                    /*+ Tip Row +*/
                    /*+ Commented As Requested by Allen +*/
                    /*+ Un-Commented As Requested by Allen on Aug-13-2024 +*/
                    Obx(() {
                      return myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes"
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const MyText(
                                  text: 'Staff Tip:',
                                  color: AppColors.kGreyColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                Obx(() {
                                  return MyText(
                                    text: "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.staffTip) ?? 0.0).toStringAsFixed(2)}",
                                    color: AppColors.kGreyColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  );
                                }),
                              ],
                            )
                          : const SizedBox();
                    }),

                    /*+ DriverTip Row +*/
                    /*+ Also Commented Because Allen Requested to Comment out Staff Tip from Order Details page + */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MyText(
                          text: 'Driver Tip:',
                          color: AppColors.kGreyColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        Obx(() {
                          return MyText(
                            text: "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.doordashDriverTip) ?? 0.0).toStringAsFixed(2)}",
                            // text: "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.driverTip) ?? 0.0).toStringAsFixed(2)}",
                            color: AppColors.kGreyColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          );
                        }),
                      ],
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: dividerCommon(),
                    ),

                    /*+ Total Row +*/
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const MyText(
                          text: 'Total:',
                          color: AppColors.kBlackColor,
                          fontSize: 16,
                          paddingTop: 0,
                          fontWeight: FontWeight.w600,
                        ),
                        Obx(() {
                          return MyText(
                            text: myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes"
                                ? "\$${myOrdersController.selectedOrderData.value.order.realCost}"
                                // ? "\$${myOrdersController.selectedOrderData.value.order.totalCost}"
                                : "\$0.00",
                            color: AppColors.kBlackColor,
                            fontSize: 16,
                            paddingTop: 0,
                            fontWeight: FontWeight.w600,
                          );
                        }),
                      ],
                    ),

                    /*+ Paid Amount Row +*/
                    (myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "hybrid" ||
                            myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "cash" ||
                            myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "stripe" ||
                            myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "card" ||
                            myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "redeemgift")
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MyText(
                                text: myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "hybrid" ||
                                        myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "stripe" ||
                                        myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "card"
                                    ? 'Card Amount:'
                                    : myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "redeemgift"
                                        ? 'Redeem Giftcard Amount:'
                                        : 'Paid Amount:',
                                color: AppColors.kBlackColor,
                                fontSize: 16,
                                paddingTop: 0,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "redeemgift"
                                      ? "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.totalCost) ?? 0.0).toPrecision(2).toStringAsFixed(2)}"
                                      : "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.realCost) ?? 0.0).toPrecision(2).toStringAsFixed(2)}",
                                  color: AppColors.kBlackColor,
                                  fontSize: 16,
                                  paddingTop: 0,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          )
                        : const SizedBox(),

                    //+ Giftcard Amount
                    myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "hybrid"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                text: 'Giftcard Amount:',
                                color: AppColors.kBlackColor,
                                fontSize: 16,
                                paddingTop: 0,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text:
                                      "\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.hybridRedeemGiftAmount) ?? 0.0).toPrecision(2).toStringAsFixed(2)}",
                                  color: AppColors.kBlackColor,
                                  fontSize: 16,
                                  paddingTop: 0,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          )
                        : const SizedBox(),

                    //+ Redeem Points
                    myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "redeempoint"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                text: 'Points Redeemed:',
                                color: AppColors.kBlackColor,
                                fontSize: 16,
                                paddingTop: 0,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: "${myOrdersController.selectedOrderData.value.order.noOfPointsRedeemed}",
                                  color: AppColors.kBlackColor,
                                  fontSize: 16,
                                  paddingTop: 0,
                                  fontWeight: FontWeight.w600,
                                );
                              }),
                            ],
                          )
                        : const SizedBox(),

                    /*+ Payment Method Row +*/
                    myOrdersController.selectedOrderData.value.order.paymentType.isNotEmpty
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const MyText(
                                text: 'Payment type:',
                                color: AppColors.kBlackColor,
                                fontSize: 16,
                                paddingTop: 0,
                                fontWeight: FontWeight.w600,
                              ),
                              Obx(() {
                                return MyText(
                                  text: (myOrdersController.selectedOrderData.value.order.paymentType).toLowerCase() == "stripe" ||
                                          (myOrdersController.selectedOrderData.value.order.paymentType).toLowerCase() == "card"
                                      ? "Card (${myOrdersController.selectedOrderData.value.order.stripeCardNo})"
                                      : (myOrdersController.selectedOrderData.value.order.paymentType).capitalizeItsFirst(),
                                  color: AppColors.kBlackColor,
                                  fontSize: 16,
                                  paddingTop: 0,
                                  fontWeight: FontWeight.w600,
                                );
                              })
                            ],
                          )
                        : const SizedBox(),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: dividerCommon(),
                    ),
                    /* + Refund Section + */
                    /* + Refund Section + */
                    /* + Refund Section + */

                    myOrdersController.selectedOrderData.value.order.refundType.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const MyText(
                                text: "Refund Details:",
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                align: TextAlign.start,
                                paddingTop: 10,
                                paddingBottom: 10,
                                // decoration: TextDecoration.underline,
                              ),
                              /*+ Refund Type Row +*/
                              myOrdersController.selectedOrderData.value.order.refundType.isNotEmpty
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const MyText(
                                          text: 'Refund type:',
                                          color: AppColors.kBlackColor,
                                          fontSize: 16,
                                          paddingTop: 0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Obx(() {
                                          return MyText(
                                            // text: AppConstants.dateFormatWithTime.format(DateTime.parse(myOrdersController.selectedOrderData.value.order.refundDateTime)),
                                            text: "${(myOrdersController.selectedOrderData.value.order.refundType).capitalizeItsFirst()}  Refund",
                                            color: AppColors.kBlackColor,
                                            fontSize: 16,
                                            paddingTop: 0,
                                            fontWeight: FontWeight.w600,
                                          );
                                        })
                                      ],
                                    )
                                  : const SizedBox(),
                              /*+ Refund Date Row - Not coming right now +*/
                              myOrdersController.selectedOrderData.value.order.refundDateTime.isNotEmpty
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const MyText(
                                          text: 'Refunded On:',
                                          color: AppColors.kBlackColor,
                                          fontSize: 16,
                                          paddingTop: 0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Obx(() {
                                          return MyText(
                                            text: AppConstants.dateFormatWithTime.format(DateTime.parse(myOrdersController.selectedOrderData.value.order.refundDateTime)),
                                            color: AppColors.kBlackColor,
                                            fontSize: 16,
                                            paddingTop: 0,
                                            fontWeight: FontWeight.w600,
                                          );
                                        })
                                      ],
                                    )
                                  : const SizedBox(),
                              /* + Refund Tip Row - Commented because tips are currently commented + */
                              /*+ Un-Commented As Requested by Allen on Aug-13-2024 +*/
                              //
                              /* + Refunded Staff tip + */
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const MyText(
                                    text: 'Refund Staff Tip:',
                                    color: AppColors.kBlackColor,
                                    fontSize: 16,
                                    paddingTop: 0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Obx(() {
                                    return MyText(
                                      text: myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes"
                                          ? "-\$${myOrdersController.selectedOrderData.value.order.refundStaffTip}"
                                          // ? "\$${myOrdersController.selectedOrderData.value.order.totalCost}"
                                          : "-\$0.00",
                                      color: AppColors.kBlackColor,
                                      fontSize: 16,
                                      paddingTop: 0,
                                      fontWeight: FontWeight.w600,
                                    );
                                  }),
                                ],
                              ),

                              /* + Refunded Driver Tip + */
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const MyText(
                                    text: 'Refund Driver Tip:',
                                    color: AppColors.kBlackColor,
                                    fontSize: 16,
                                    paddingTop: 0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Obx(() {
                                    return MyText(
                                      text: myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes"
                                          ? "-\$${myOrdersController.selectedOrderData.value.order.refundDriverTip}"
                                          // ? "\$${myOrdersController.selectedOrderData.value.order.totalCost}"
                                          : "-\$0.00",
                                      color: AppColors.kBlackColor,
                                      fontSize: 16,
                                      paddingTop: 0,
                                      fontWeight: FontWeight.w600,
                                    );
                                  }),
                                ],
                              ),

                              /* + Refund Sub-Total Row + */
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const MyText(
                                    text: 'Refund Sub-Total:',
                                    color: AppColors.kBlackColor,
                                    fontSize: 16,
                                    paddingTop: 0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Obx(() {
                                    return MyText(
                                      text: myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes"
                                          ? "-\$${((double.tryParse(myOrdersController.selectedOrderData.value.order.refundAmount) ?? 0) - ((double.tryParse(myOrdersController.selectedOrderData.value.order.refundStaffTip) ?? 0) + (double.tryParse(myOrdersController.selectedOrderData.value.order.refundDriverTip) ?? 0) + (double.tryParse(myOrdersController.selectedOrderData.value.order.refundTax) ?? 0.0))).toPrecision(2).toStringAsFixed(2)}"
                                          // ? "\$${myOrdersController.selectedOrderData.value.order.totalCost}"
                                          : "-\$0.00",
                                      color: AppColors.kBlackColor,
                                      fontSize: 16,
                                      paddingTop: 0,
                                      fontWeight: FontWeight.w600,
                                    );
                                  }),
                                ],
                              ),
                              /* + Refund Sales-Tax Row + */
                              Obx(() {
                                return myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes"
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          MyText(
                                            text: 'Refund Sales Tax (${siteDataController.salesTax.value}%):',
                                            color: AppColors.kBlackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          Obx(() {
                                            return MyText(
                                              text: "-\$${(double.tryParse(myOrdersController.selectedOrderData.value.order.refundTax) ?? 0.0).toStringAsFixed(2)}",
                                              color: AppColors.kBlackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            );
                                          }),
                                        ],
                                      )
                                    : const SizedBox();
                              }),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: dividerCommon(),
                              ),
                              /* + Refund Total Row + */
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const MyText(
                                    text: 'Refund Total:',
                                    color: AppColors.kBlackColor,
                                    fontSize: 16,
                                    paddingTop: 0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Obx(() {
                                    return MyText(
                                      text: myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes"
                                          ? "-\$${myOrdersController.selectedOrderData.value.order.refundAmount}"
                                          // ? "\$${myOrdersController.selectedOrderData.value.order.totalCost}"
                                          : "-\$0.00",
                                      color: AppColors.kBlackColor,
                                      fontSize: 16,
                                      paddingTop: 0,
                                      fontWeight: FontWeight.w600,
                                    );
                                  }),
                                ],
                              ),
                              //+ Refund Redeem Points Added By SAIF ON 12-12-2024 08: 21
                              myOrdersController.selectedOrderData.value.order.paymentType.toLowerCase() == "redeempoint"
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const MyText(
                                          text: 'Refund Redeemed Points:',
                                          color: AppColors.kBlackColor,
                                          fontSize: 16,
                                          paddingTop: 0,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        Obx(() {
                                          return MyText(
                                            text: "${myOrdersController.selectedOrderData.value.order.noOfPointsRedeemed}",
                                            color: AppColors.kBlackColor,
                                            fontSize: 16,
                                            paddingTop: 0,
                                            fontWeight: FontWeight.w600,
                                          );
                                        }),
                                      ],
                                    )
                                  : const SizedBox(),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: dividerCommon(),
                              ),
                              myOrdersController.selectedOrderData.value.order.refundType.isNotEmpty
                                  ? const MyText(
                                      text: "Refund History:",
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      align: TextAlign.start,
                                      paddingTop: 10,
                                      paddingBottom: 10,
                                      // decoration: TextDecoration.underline,
                                    )
                                  : const SizedBox(),
                              Row(
                                children: [
                                  SizedBox(
                                    width: Get.width - 20,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: myOrdersController.selectedOrderData.value.refundHistory.length,
                                      itemBuilder: (BuildContext context, int refundIndex) {
                                        RefundHistory refund = myOrdersController.selectedOrderData.value.refundHistory[refundIndex];

                                        return MyRefundDetailsListTile(
                                          leading: Icon(
                                            Icons.monetization_on_outlined,
                                            color: Colors.green,
                                            size: 34,
                                          ),
                                          title: MyText(
                                            text: getRefundTypeText((refund.jsonData?.refundType ?? "").toLowerCase()),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              MyText(
                                                text: "Type: ${refund.type.capitalizeFirst}",
                                                fontSize: 14,
                                                color: AppColors.kGreyColor,
                                              ),
                                              MyText(
                                                text:
                                                    "Date: ${refund.refundDate.isNotEmpty ? AppConstants.dateFormatWithTime.format(DateTime.parse(refund.refundDate)) : ""}",

                                                // text: "Date: ${refund.refundDate}",
                                                fontSize: 14,
                                                color: AppColors.kGreyColor,
                                              ),
                                            ],
                                          ),
                                          trailing: MyText(
                                            text:
                                                "\$${myOrdersController.selectedOrderData.value.order.isPointsRedeemed.toLowerCase() != "yes" ? refund.amount : "0.00"}",
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          trailingTopPadding: 0,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                child: dividerCommon(),
                              ),
                            ],
                          )
                        : const SizedBox(),

                    const SizedBox(height: AppSizes.formsSizeBoxHeight),
                  ],
                )
              : apiController.isLoadingMyOrderDetails.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.kLogoBasedColor,
                      ),
                    )
                  : const Center(
                      child: MyText(
                        text: "Could not fetch order data. Please go back to try again",
                        fontSize: 16,
                      ),
                    );
        }),
      ),
    );
  }
}

class TimelineWidget extends StatelessWidget {
  final String fromAddress;
  final String toAddress;
  final List<Map<String, String>> timelineData = [
    {'from': '123 Main St, City A', 'to': '456 Market St, City B'},
    {'from': '456 Market St, City B', 'to': '789 Elm St, City C'},
    {'from': '789 Elm St, City C', 'to': '101 Pine St, City D'},
  ];

  TimelineWidget({
    super.key,
    required this.fromAddress,
    required this.toAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: ListView(
        shrinkWrap: true,
        children: [
          TimelineTile(
            nodeAlign: TimelineNodeAlign.start,
            contents: Card(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'From',
                      color: AppColors.kGreyColor2,
                      fontSize: 16,
                    ),
                    MyText(
                      text: fromAddress,
                      color: AppColors.kLogoBasedColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ),
            node: TimelineNode(
              indicator: Icon(
                Icons.location_on_outlined,
                color: AppColors.kLogoBasedColor,
                size: 28,
              ),
              // indicator: DotIndicator(),
              // startConnector: SolidLineConnector(),
              endConnector: DashedLineConnector(
                color: AppColors.kLogoBasedColor,
              ),
            ),
          ),
          TimelineTile(
            nodeAlign: TimelineNodeAlign.start,
            contents: Card(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: 'To',
                      color: AppColors.kGreyColor2,
                      fontSize: 16,
                    ),
                    MyText(
                      text: '$toAddress ',
                      color: AppColors.kLogoBasedColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
              ),
            ),
            node: TimelineNode(
              indicator: Icon(
                Icons.location_on,
                color: AppColors.kLogoBasedColor,
                size: 28,
              ),
              // indicator: DotIndicator(),
              startConnector: DashedLineConnector(
                color: AppColors.kLogoBasedColor,
              ),
              // endConnector: SolidLineConnector(),
            ),
          ),
          // TimelineNode(
          //   indicator: Card(
          //     margin: EdgeInsets.zero,
          //     child: Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: Text('Complex: ${timelineData[0]["from"]}'),
          //     ),
          //   ),
          //   startConnector: DashedLineConnector(),
          //   endConnector: DashedLineConnector(),
          // ),
          // TimelineNode(
          //   indicator: Card(
          //     margin: EdgeInsets.zero,
          //     child: Padding(
          //       padding: EdgeInsets.all(8.0),
          //       child: Text('Complex: ${timelineData[0]["to"]}'),
          //     ),
          //   ),
          //   startConnector: DashedLineConnector(),
          //   endConnector: DashedLineConnector(),
          // ),
        ],
      ),
    );

    // Timeline.tileBuilder(
    //   shrinkWrap: true,
    //   builder: TimelineTileBuilder.connectedFromStyle(
    //     contentsAlign: ContentsAlign.basic,
    //     indicatorStyleBuilder: (context, index) => IndicatorStyle.container,
    //     // indicatorStyle: IndicatorStyle.outlined,
    //     // connectorStyle: ConnectorStyle.dashedLine,
    //     contentsBuilder: (context, index) {
    //       if (index == 0) {
    //         return Padding(
    //           padding: const EdgeInsets.all(24.0),
    //           child: Text('From ${timelineData[index]['from']}'),
    //         );
    //       }
    //       return Padding(
    //         padding: const EdgeInsets.all(24.0),
    //         child: Text('To  ${timelineData[index]['from']}'),
    //       );
    //     },
    //     itemCount: 2,
    //   ),
    // );

    //  ListView.builder(
    //   itemCount: timelineData.length,
    //   shrinkWrap: true,
    //   itemBuilder: (context, index) {
    //     return MyTimelineTile(
    //       fromAddress: timelineData[index]['from']!,
    //       toAddress: timelineData[index]['to']!,
    //       isFirst: index == 0,
    //       isLast: index == timelineData.length - 1,
    //     );
    //   },
    // );
  }
}

class MyTimelineTile extends StatelessWidget {
  final String fromAddress;
  final String toAddress;
  final bool isFirst;
  final bool isLast;

  const MyTimelineTile({
    super.key,
    required this.fromAddress,
    required this.toAddress,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and icon
        Column(
          children: [
            Container(
              width: 20,
              child: Column(
                children: [
                  // Top line
                  if (!isFirst)
                    Container(
                      height: 20,
                      width: 2,
                      color: Colors.grey,
                    ),
                  // Circle icon
                  Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 20,
                  ),
                  // Bottom line
                  if (!isLast)
                    Container(
                      height: 20,
                      width: 2,
                      color: Colors.grey,
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(width: 10),
        // Address information
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: 'From: $fromAddress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              MyText(
                text: 'To: $toAddress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
