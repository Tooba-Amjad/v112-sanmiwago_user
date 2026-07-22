import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';

import '../../widgets/common_widgets.dart';

class CartTotalSection extends StatelessWidget {
  final bool isFromCart;

  const CartTotalSection({
    super.key,
    this.isFromCart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // !isFromCart && checkoutController.selectedPaymentType.value == "redeemPoint"
        //     ? Container(
        //         width: Get.width,
        //         margin: const EdgeInsets.symmetric(horizontal: 3),
        //         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        //         decoration: BoxDecoration(
        //           color: Colors.green[50],
        //           borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
        //         ),
        //         child: Row(
        //           children: [
        //             const SizedBox(height: 10),
        //             Icon(
        //               Icons.info_outline,
        //               color: Colors.green[700],
        //               size: 18,
        //             ),
        //             Expanded(
        //               child: MyText(
        //                 color: Colors.green[600],
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w600,
        //                 maxLines: 3,
        //                 text: "When redeeming points, 1\$ = 10 points for the staff tips, driver tips, and delivery fee.",
        //                 align: TextAlign.left,
        //                 // paddingTop: 10,
        //                 // paddingBottom: 10,
        //                 paddingLeft: 6,
        //                 // paddingRight: 10,
        //               ),
        //             ),
        //           ],
        //         ),
        //       )
        //     : const SizedBox(),

        /* + Real Sub total Row + */
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
                text: '\$${(orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice)).toStringAsFixed(2)}',
                color: AppColors.kGreyColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              );
            }),
          ],
        ),

        /* + Discount Row + */
        Obx(() {
          log("orderController.discount.value: ${orderController.discount.value}");
          return orderController.discount.value != 0.0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyText(
                      text: 'Discount (${checkoutController.couponPercentageForOrder.value.formatNumber()}%):',
                      color: AppColors.kGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    MyText(
                      text: '-\$${orderController.discount.value.toStringAsFixed(2)}',
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
        Obx(() {
          return orderController.discount.value != 0.0
              ? Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: dividerCommon(),
                )
              : const SizedBox();
        }),

        /* + Discounted Sub total Row + */
        Obx(() {
          return orderController.discount.value != 0.0
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
                        text:
                            '\$${(orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) - orderController.discount.value).toStringAsFixed(2)}',
                        color: AppColors.kGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      );
                    }),
                  ],
                )
              : const SizedBox();
        }),

        /* + Delivery fee Row + */
        Obx(() {
          return checkoutController.orderType.value == "delivery"
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
                        text: '\$${checkoutController.deliveryFeeTotal.value}',
                        color: AppColors.kGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      );
                    }),
                  ],
                )
              : SizedBox();
        }),

        /*+ Sales Tax Row +*/
        Obx(() {
          return checkoutController.selectedPaymentType.value == "redeemPoint"
              ? const SizedBox()
              : Row(
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
                        text: '\$${orderController.calculatedSalesTax.value.toPrecision(2).toStringAsFixed(2)}',
                        color: AppColors.kGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      );
                    }),
                  ],
                );
        }),

        /*+ Tip Row +*/
        /*+ Commented As Requested by Allen +*/
        /*+ Un-Commented As Requested by Allen on Aug-13-2024 +*/

        Obx(() {
          if (((checkoutController.tipTotal.value != 0.0 && isFromCart) || !isFromCart) && checkoutController.selectedPaymentType.value != "redeemPoint") {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'Staff Tip (${checkoutController.tipPercentage.value.round()}%):',
                  color: AppColors.kGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                Obx(() {
                  return MyText(
                    text: '\$${checkoutController.tipTotal.value.toStringAsFixed(2)}',
                    color: AppColors.kGreyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  );
                }),
              ],
            );
          } else {
            return const SizedBox();
          }
        }),

        /* + Driver Tip + */
        /* + Commented on 12:52 AM Nov-27-2024 as requested by Allen+ */

        Obx(() {
          if ((checkoutController.driverTipTotal.value != 0.0 && isFromCart) ||
              (!isFromCart && checkoutController.orderType.value == "delivery" && checkoutController.selectedPaymentType.value != "redeemPoint")) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText(
                  text: 'Driver Tip (${checkoutController.driverTipPercentage.value.round()}%):',
                  color: AppColors.kGreyColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                Obx(() {
                  return MyText(
                    text: '\$${checkoutController.driverTipTotal.value.toStringAsFixed(2)}',
                    color: AppColors.kGreyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  );
                }),
              ],
            );
          } else {
            return const SizedBox();
          }
        }),

        /*+ Available Giftcard Amount Row +*/
        Obx(() {
          return checkoutController.selectedPaymentType.value == "redeemGift"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(
                      text: 'Total Giftcard Amount:',
                      color: AppColors.kGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    Obx(() {
                      return MyText(
                        text: giftCardController.myGiftCardDetails.value.data?.totalAmount,
                        color: AppColors.kGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      );
                    }),
                  ],
                )
              : const SizedBox();
        }),

        /*+ Giftcard Amount To Redeem Row +*/
        Obx(() {
          return checkoutController.selectedPaymentType.value == "redeemGift"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(
                      text: 'Amount To Redeem:',
                      color: AppColors.kGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    Obx(() {
                      return MyText(
                        text: (orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) +
                                orderController.calculatedSalesTax.value +
                                checkoutController.tipTotal.value +
                                checkoutController.driverTipTotal.value -
                                orderController.discount.value)
                            .toPrecision(2)
                            .toStringAsFixed(2),
                        color: AppColors.kGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      );
                    }),
                  ],
                )
              : const SizedBox();
        }),

        /*+ Available Redeem Points Row +*/
        Obx(() {
          return checkoutController.selectedPaymentType.value == "redeemPoint"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(
                      text: 'Point Available:',
                      color: AppColors.kGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    Obx(() {
                      return MyText(
                        text: authController.userData.value.userPoints,
                        color: AppColors.kGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      );
                    }),
                  ],
                )
              : const SizedBox();
        }),

        /*+ Redeem Points Row +*/
        Obx(() {
          log("tipppp points: ${(checkoutController.tipPointsTotal.value + checkoutController.driverTipPointsTotal.value + checkoutController.deliveryFeePointsTotal.value).toPrecision(0)}");
          log("tipppp points: ${(checkoutController.tipPointsTotal.value + checkoutController.driverTipPointsTotal.value + checkoutController.deliveryFeePointsTotal.value)}");
          return checkoutController.selectedPaymentType.value == "redeemPoint"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyText(
                      text: 'Point Redeem:',
                      color: AppColors.kGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    Obx(() {
                      return MyText(
                        text: (orderController.cartItems
                                    .fold(0.0, (previousValue, cartItem) => previousValue + (cartItem.itemCount * (double.tryParse(cartItem.pointsToPurchase) ?? 0.0))) +
                                checkoutController.tipPointsTotal.value +
                                checkoutController.driverTipPointsTotal.value +
                                checkoutController.deliveryFeePointsTotal.value)
                            .toPrecision(0)
                            .toStringAsFixed(0),
                        color: AppColors.kGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      );
                    }),
                  ],
                )
              : const SizedBox();
        }),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: dividerCommon(),
        ),

        /*+ Discount Row +*/
        Obx(() {
          return checkoutController.selectedPaymentType.value != "redeemPoint" && !isFromCart
              ? Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 35,
                        child: MyTextField(
                          padding: EdgeInsets.only(left: 0, right: 10),
                          contentPadding: EdgeInsets.only(left: 10, right: 10),
                          hint: "Coupon Code",
                          // disableErrorText: true,
                          controller: checkoutController.couponCodeController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          validator: (String? value) {
                            String val = value ?? "";
                            return null;
                          },
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 135,
                          height: 30,
                          child: Obx(() {
                            return MyButton(
                              width: 140,
                              height: 50,
                              padding: 0,
                              text: "Apply Coupon",
                              textColor: apiController.isLoadingCouponCodeDetails.value ? AppColors.kWhiteColor : AppColors.kBlackColor,
                              fontSize: 14,
                              color: apiController.isLoadingCouponCodeDetails.value ? AppColors.kGreenColor : AppColors.kSkyLightDullColor,
                              onPressed: () {
                                hideKeyboard(context);
                                //! apply coupon code
                                if (checkoutController.selectedPaymentType.value != "redeemPoint") {
                                  if (!apiController.isLoadingCouponCodeDetails.value &&
                                      checkoutController.couponCodeController.text.trim() != checkoutController.couponCodeApplied) {
                                    apiController.getCouponDiscountCodeDetails(checkoutController.couponCodeController.text.trim());
                                  } else if (checkoutController.couponCodeController.text.trim() == checkoutController.couponCodeApplied) {
                                    showMsg(
                                      msg:
                                          "You just applied this code, if ${orderController.discount.value == 0.0 ? "this did not work, please try with a different one" : "you want to try with another one, please do that"}.",
                                      time: const Duration(seconds: 4),
                                    );
                                  }
                                } else if (checkoutController.selectedPaymentType.value == "redeemPoint") {
                                  showMsg(msg: "Discount code cannot be applied when Redeeming Points.", time: const Duration(seconds: 3));
                                }
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                )
              : const SizedBox();
        }),

        /*+ Total Row +*/
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const MyText(
              text: 'Total:',
              color: AppColors.kBlackColor,
              fontSize: 16,
              paddingTop: 5,
              fontWeight: FontWeight.w600,
            ),
            Obx(() {
              return MyText(
                text: checkoutController.selectedPaymentType.value == "redeemPoint"
                    ? "\$0.00"
                    : '\$${(orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) + orderController.calculatedSalesTax.value - orderController.discount.value + checkoutController.tipTotal.value + checkoutController.driverTipTotal.value + checkoutController.deliveryFeeTotal.value).toPrecision(2).toStringAsFixed(2)}',
                color: AppColors.kBlackColor,
                fontSize: 16,
                paddingTop: 5,
                fontWeight: FontWeight.w600,
              );
            }),
          ],
        ),
      ],
    );
  }
}
