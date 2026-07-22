// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/custom_scroll_behavior.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/checkout/components/checkout_page_container.dart';
import 'package:sanmiwago_user/views/pages/checkout/components/pay_online_cards_widget.dart';
import 'package:sanmiwago_user/views/pages/checkout/components/checkout_delivery_map_address_section_widget.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/privacy_policy.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/terms_of_use.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

import '../../../utils/formatters/us_phone_number_formatter.dart';
import '../../../utils/tip_thumb_shape.dart';
import '../../../utils/validators/us_phone_number_validator.dart';
import '../cart/cart_total_section.dart';

class CheckoutPage extends StatefulWidget {
  static RxBool isGiftcardValidated = false.obs;

  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final ScrollController sc = ScrollController();

    return Scaffold(
      // backgroundColor: AppColors.kGreyColor,
      backgroundColor: AppColors.kSkyLightDullColor,
      appBar: simpleAppBar(
        title: "Checkout",
        haveBackIcon: true,
        onBackPressed: () {
          Get.back();
          Future.delayed(const Duration(milliseconds: 500), () {
            /*+ Commented As Requested by Allen +*/
            /*+ Un-Commented As Requested by Allen on Aug-13-2024 +*/
            checkoutController.clearTips();
            checkoutController.clearAll();
            checkoutController.getDiscountedPayableTotal();
            locationController.clearPickedLocation();
          });
        },
      ),
      body: WillPopScope(
        onWillPop: () async {
          Future.delayed(const Duration(milliseconds: 500), () {
            /*+ Commented As Requested by Allen +*/
            /*+ Un-Commented As Requested by Allen on Aug-13-2024 +*/
            checkoutController.clearTips();
            checkoutController.clearAll();
            checkoutController.getDiscountedPayableTotal();
            locationController.clearPickedLocation();
          });
          return true;
        },
        child: GestureDetector(
          onTap: () => hideKeyboard(context),
          child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: ListView(
              controller: sc,
              children: [
                //+ User details
                authController.userData.value.userId.isEmpty
                    ? CheckoutPageContainer(
                        isForm: true,
                        formKey: checkoutController.userInfoFormKey,
                        // height: 390,
                        headerNumber: "1",
                        headerText: "User Info",
                        children: [
                          //+ Email
                          const MyText(text: "Your Email", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                          MyTextField(
                            hint: "Please Enter Your Email",
                            // disableErrorText: true,
                            controller: checkoutController.emailController,
                            keyboardType: TextInputType.emailAddress,
                            autoFillHints: const [AutofillHints.email],
                            validator: (String? val) {
                              String value = val ?? "";
                              if (value.isEmpty == true) {
                                return "Email is required";
                              } else if (!GetUtils.isEmail(value.trim())) {
                                return "Please enter a valid email address";
                              }
                              return null;
                            },
                            onFieldSubmitted: (val) {
                              if (GetUtils.isEmail(val)) {
                                checkoutController.getUserInfoAndAddressForCheckout();
                              }
                            },
                            onChanged: (val) {
                              if (GetUtils.isEmail(val)) {
                                checkoutController.getUserInfoAndAddressForCheckout();
                              }
                            },
                          ),

                          //+ Name
                          const MyText(text: "Your Name", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                          MyTextField(
                            hint: "Please Enter Your Name",
                            // disableErrorText: true,
                            controller: checkoutController.nameController,
                            keyboardType: TextInputType.name,
                            autoFillHints: const [
                              AutofillHints.name,
                              AutofillHints.familyName,
                              AutofillHints.givenName,
                              AutofillHints.middleName,
                              AutofillHints.nickname,
                            ],
                            validator: (String? value) {
                              String val = value ?? "";

                              RegExp regex = RegExp(r"\s{2,}");
                              bool hasMultipleSpaces = regex.hasMatch(val);
                              if (value?.isEmpty == true) {
                                return "Name is required";
                              } else if (val.trim().length != val.length || hasMultipleSpaces) {
                                return "Please remove extra space(s) from last name";
                              }
                              return null;
                            },
                          ),

                          //+ phone
                          const MyText(text: "Your Phone Number", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                          MyTextField(
                            hint: "Please Enter Your Phone Number",
                            // disableErrorText: true,
                            controller: checkoutController.phoneController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            autoFillHints: const [
                              AutofillHints.telephoneNumber,
                              AutofillHints.telephoneNumberDevice,
                              AutofillHints.telephoneNumberLocal,
                              AutofillHints.telephoneNumberNational,
                            ],
                            inputFormatters: [LengthLimitingTextInputFormatter(14), FilteringTextInputFormatter.digitsOnly, UsNumberTextInputFormatter()],

                            // inputFormatters: [
                            //   LengthLimitingTextInputFormatter(10),
                            //   FilteringTextInputFormatter.digitsOnly,
                            // ],
                            // onFieldSubmitted: (val) {
                            //   log("onFieldSubmitted onFieldSubmitted onFieldSubmitted");
                            //   log("valid: ${checkoutController.userInfoFormKey.currentState?.validate()}");
                            //   if (checkoutController.userInfoFormKey.currentState?.validate() ?? false) {
                            //     TextInput.finishAutofillContext();
                            //   }
                            // },
                            validator: (String? val) {
                              String value = val ?? "";
                              final usPhoneValidity = validateUsPhoneNumber(value);
                              /* ! We may not need this as this was especially for the purpose of updating the signup_otp_section_widget ! */
                              // authController.isNumValid.value = (usPhoneValidity == null);
                              return usPhoneValidity;

                              // String value = val ?? "";
                              // if (value.isEmpty == true) {
                              //   return "Phone Number is required";
                              // } else if (!value.isNumericOnly) {
                              //   return 'Please enter a valid digit only phone number';
                              // } else if (value.trim().length != 10) {
                              //   return "Please enter your 10 digit phone number";
                              // }
                              // return null;
                            },
                          ),
                          Obx(() {
                            return MyCheckBoxTile(
                              title: "Send text message for order status",
                              value: checkoutController.shouldSendMessage.value,
                              color: AppColors.kLogoBasedColor,
                              borderRadius: 10,
                              onChanged: (value) {
                                checkoutController.shouldSendMessage.value = value ?? false;
                              },
                            );
                          }),
                        ],
                      )
                    : const SizedBox(),

                authController.userData.value.userId.isNotEmpty
                    ? CheckoutPageContainer(
                        // height: 150,
                        headerNumber: "1",
                        headerText: "User Info",
                        children: [
                          Container(
                            color: AppColors.kSkyLightDullColor,
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                            // height: 70,
                            child: Obx(() {
                              return MyCheckBoxTile(
                                title: "Send text message to \"${authController.userData.value.phone}\" for order status",
                                value: checkoutController.shouldSendMessage.value,
                                color: AppColors.kLogoBasedColor,
                                borderRadius: 10,
                                onChanged: (value) {
                                  checkoutController.shouldSendMessage.value = value ?? false;
                                },
                              );
                            }),
                          ),
                        ],
                      )
                    : const SizedBox(),

                //+ Pickup/Delivery address
                Obx(() {
                  log("(checkoutController.isDeliveryOrderAllowed.value in Obx :  ${checkoutController.deliveryAllowedModel.value.isDeliveryOrderAllow}");
                  // if (checkoutController.deliveryOrderModel.value.isDeliveryOrderAllow == "No") {
                  //   return SizedBox();
                  // }
                  return CheckoutPageContainer(
                    isForm: true,
                    formKey: checkoutController.deliveryInfoFormKey,
                    // height: checkoutController.orderType.value == "delivery" ? 520 : 180,
                    headerNumber: "2",
                    headerText: "Order Type",
                    children: [
                      Container(
                        color: AppColors.kSkyLightDullColor,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        // height: checkoutController.orderType.value == "delivery" ? 450 : 100,
                        width: Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            SizedBox(
                              height: 30,
                              width: Get.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 110,
                                    child: Obx(() {
                                      return MyCheckBoxTile(
                                        title: "Pickup",
                                        value: checkoutController.orderType.value == "pickup",
                                        color: AppColors.kLogoBasedColor,
                                        borderRadius: 10,
                                        onChanged: (val) {
                                          checkoutController.orderType.value = "pickup";
                                          checkoutController.getUserInfoAndAddressForCheckout();
                                          checkoutController.driverTipPercentage.value = 0.0;
                                          checkoutController.driverTipTotal.value = 0.0;
                                          checkoutController.driverTipPointsTotal.value = 0.0;
                                          checkoutController.deliveryFeeTotal.value = 0.0;
                                          checkoutController.deliveryFeePointsTotal.value = 0.0;
                                          checkoutController.getDiscountedPayableTotal();
                                        },
                                      );
                                    }),
                                  ),
                                  const SizedBox(width: 5),
                                  SizedBox(
                                    width: 110,
                                    child: Obx(() {
                                      return checkoutController.deliveryAllowedModel.value.isDeliveryOrderAllow != "No"
                                          ? MyCheckBoxTile(
                                              title: "Delivery",
                                              value: checkoutController.orderType.value == "delivery",
                                              color: AppColors.kLogoBasedColor,
                                              borderRadius: 10,
                                              onChanged: (val) async {
                                                // showMyAnimatedDialog(
                                                //   context: context,
                                                //   child: MyNewConfirmDialog(
                                                //     title: "Agree to Delivery Terms?",
                                                //     msg:
                                                //         "To proceed with a delivery order, a delivery fee — starting at a base rate of \$9.75 and varying by distance — must be paid when placing your order. If you prefer not to pay the delivery fee, you can choose the pickup option instead. Do you agree to these terms?",
                                                //     rightButtonText: "I Agree",
                                                //     leftButtonText: "No",
                                                //     rightButtonWidth: 120,
                                                //     leftButtonWidth: 120,
                                                //     yesOnPressed: () async {
                                                /* + Added this as requested in the #248 (https://github.com/expressgfa/Currently-Working-project/issues/248) + */
                                                if (checkoutController.selectedPaymentType.value == "redeemPoint") {
                                                  showMsg(
                                                    msg:
                                                        "A delivery order cannot be placed using Redeem Points method. We are deselecting the Redeem Points method for you.",
                                                  );
                                                  checkoutController.selectedPaymentType.value = "";
                                                  // return;
                                                }

                                                locationController.clearPickedLocation();
                                                checkoutController.orderType.value = "delivery";

                                                /// added based on the #248 request to make sure that
                                                /// the redeem section is not shown when the user selects
                                                /// the delivery option.
                                                checkoutController.shouldShowRedeemSection();

                                                await checkoutController.getUserInfoAndAddressForCheckout();
                                                if (checkoutController.selectedPaymentType.value == "redeemPoint") {
                                                  /* + Commented this as requested in the #248 (https://github.com/expressgfa/Currently-Working-project/issues/248) + */
                                                  // checkoutController.shouldShowRedeemSection();
                                                }
                                                checkoutController.getDiscountedPayableTotal();

                                                if ((checkoutController.addressLat == 0.0 && checkoutController.addressLng == 0.0) &&
                                                        locationController.currentLatitude == null ||
                                                    locationController.currentLongitude == null) {
                                                  log("this seems to have been called");
                                                  showMsg(msg: "Fetching your location. Please wait!");
                                                  locationController.determinePosition(context, showLoading: true);
                                                }

                                                //   },
                                                //   noOnPressed: () {},
                                                // ),
                                                // );
                                              },
                                            )
                                          : SizedBox();
                                    }),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() {
                              return checkoutController.orderType.value == "pickup"
                                  ? MyText(
                                      text: restaurantController.selectedRestaurantAddress.value.isNotEmpty
                                          ? restaurantController.selectedRestaurantAddress.value
                                          : "90 Bowery, New York 10013",
                                      //+ enter Restaurant branch based address
                                      fontSize: 15,
                                      align: TextAlign.left,
                                      fontWeight: FontWeight.normal,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      paddingLeft: 18,
                                      paddingRight: 18,
                                      paddingTop: 10,
                                      paddingBottom: 10,
                                    )
                                  : const SizedBox();
                            }),
                            SizedBox(height: 15),
                            Obx(() {
                              return checkoutController.orderType.value == "delivery" ? const CheckoutDeliveryMapAddressSectionWidget() : const SizedBox();
                            }),
                          ],
                        ),
                      ),
                    ],
                  );
                }),

                //+ Redeem points
                Obx(() {
                  return authController.userData.value.id.isNotEmpty && checkoutController.shouldShowRedeemSection() && checkoutController.orderType.value != "delivery"
                      ? CheckoutPageContainer(
                          // height: 250,
                          headerNumber: checkoutController.deliveryAllowedModel.value.isDeliveryOrderAllow == "No" ? "2" : "3",
                          headerText: "Redeem Points",
                          children: [
                            Obx(() {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.kSkyLightDullColor,
                                  borderRadius: BorderRadius.circular(1),
                                  border: Border.all(color: AppColors.kSkyLightDullColor, width: 1),
                                ),
                                // height: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 35,
                                          width: 35,
                                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: AppColors.kLogoBasedColor.withOpacity(0.5),
                                            borderRadius: BorderRadius.circular(30),
                                            // border: Border.all(color: AppColors.kLightGreyColor, width: 1),
                                          ),
                                          child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.kLogoBasedColor, size: 20),
                                        ),

                                        Obx(() {
                                          return MyText(
                                            text: "${authController.userData.value.userPoints} Points",
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            paddingLeft: 0,
                                            paddingTop: 0,
                                            paddingBottom: 0,
                                          );
                                        }),
                                        // Image.asset(Assets.iconsDiscover),
                                      ],
                                    ),
                                    MyText(
                                      text:
                                          "Would you like to redeem your "
                                          "${orderController.cartItems.fold(0.0, (previousValue, cartItem) => previousValue + (cartItem.itemCount * (double.tryParse(cartItem.pointsToPurchase) ?? 0.0))).toPrecision(0).toStringAsFixed(0)}"
                                          " points to purchase this order?",
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      color: AppColors.kGreyColor,
                                      paddingLeft: 10,
                                      paddingRight: 10,
                                      paddingTop: 0,
                                      paddingBottom: 0,
                                    ),
                                    Obx(() {
                                      return MyCheckBoxTile(
                                        title: "Redeem",
                                        value: checkoutController.selectedPaymentType.value == "redeemPoint",
                                        color: AppColors.kLogoBasedColor,
                                        borderRadius: 10,
                                        onChanged: (value) {
                                          checkoutController.isRedeemPointCheckout.value = value ?? false;
                                          log("checkoutController.isRedeemPointCheckout.value ${checkoutController.isRedeemPointCheckout.value}");
                                          if (value ?? false) {
                                            checkoutController.selectedPaymentType.value = "redeemPoint";
                                            if (checkoutController.membershipCardController.text.trim().isNotEmpty ||
                                                checkoutController.spDiscountCodeController.text.trim().isNotEmpty ||
                                                checkoutController.couponPercentageForOrder.value != 0.0) {
                                              showMsg(msg: "Discount cannot be applied when Redeeming Points. So it is being removed.", time: const Duration(seconds: 4));
                                              checkoutController.clearMembershipDiscountData();
                                              checkoutController.clearSpDiscountData();
                                              checkoutController.clearCouponDiscountData();
                                              checkoutController.getDiscountedPayableTotal();
                                            }
                                            /* + COMMENTED ON 28-DEC-2024 BECAUSE NOW TIP IS ALLOWED WITH POINTS WHERE $1 = 10 POINTS + */
                                            /* + UNCOMMENTED ON 19-Jan-2025 BECAUSE NOW TIP IS NOT ALLOWED when redeeming points + */
                                            else if (checkoutController.tipPercentage.value != 0.0 || checkoutController.driverTipPercentage.value != 0.0) {
                                              showMsg(
                                                msg: "Staff or Driver Tip cannot be applied when Redeeming Points. So it is being removed.",
                                                time: const Duration(seconds: 4),
                                              );
                                              checkoutController.tipPercentage.value = 0.0;
                                              checkoutController.driverTipPercentage.value = 0.0;
                                              checkoutController.getDiscountedPayableTotal();
                                            }
                                          } else {
                                            checkoutController.selectedPaymentType.value = "";
                                          }
                                        },
                                      );
                                    }),
                                  ],
                                ),
                              );
                            }),
                          ],
                        )
                      : authController.userData.value.id.isNotEmpty && checkoutController.orderType.value != "delivery"
                      ? CheckoutPageContainer(
                          // height: 250,
                          headerNumber: checkoutController.deliveryAllowedModel.value.isDeliveryOrderAllow == "No" ? "2" : "3",
                          headerText: "Redeem Points",
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 35,
                                  width: 35,
                                  margin: const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.kSkyLightDullColor,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: AppColors.kSkyLightDullColor, width: 1),
                                  ),
                                  child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.kRedColor, size: 20),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                    child: RichText(
                                      maxLines: 7,
                                      textAlign: TextAlign.left,
                                      text: TextSpan(
                                        text: "You do not have enough points to redeem for this order. You require ",
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 15, fontFamily: GoogleFonts.poppins().fontFamily),
                                        children: [
                                          TextSpan(
                                            text:
                                                "${orderController.cartItems.fold(0.0, (previousValue, cartItem) => previousValue + (cartItem.itemCount * (double.tryParse(cartItem.pointsToPurchase) ?? 0.0))).toPrecision(0).toStringAsFixed(0)} points",
                                            style: TextStyle(
                                              color: AppColors.kRedColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                            ),
                                          ),
                                          TextSpan(
                                            text: " to purchase this order but you only have ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                            ),
                                          ),
                                          TextSpan(
                                            text: "${double.tryParse(authController.userData.value.userPoints)?.toPrecision(0).toStringAsFixed(0) ?? 0} points",
                                            style: TextStyle(
                                              color: AppColors.kRedColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ". ",
                                            // "We may contact you regarding your submission.",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              fontFamily: GoogleFonts.poppins().fontFamily,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox();
                }),

                //+ Gift card
                CheckoutPageContainer(
                  isForm: checkoutController.shouldShowRedeemSection(),
                  formKey: checkoutController.checkoutGiftFormKey,
                  // height: 340,
                  headerNumber: checkoutController.shouldShowRedeemSection() ? "4" : "3",
                  headerText: "Gift Card",
                  children: [
                    //+ Gift Card No.
                    Obx(() {
                      return MyCheckBoxTile(
                        title: "Pay with Gift Card",
                        value: checkoutController.selectedPaymentType.value == "redeemGift",
                        // value: checkoutController.payWithGiftCard.value,
                        color: AppColors.kLogoBasedColor,
                        borderRadius: 10,
                        onChanged: (value) {
                          // checkoutController.payWithGiftCard.value = value ?? false;
                          if (value == true) {
                            checkoutController.selectedPaymentType.value = "redeemGift";
                          } else {
                            checkoutController.selectedPaymentType.value = "";
                          }
                        },
                      );
                    }),
                    const MyText(text: "Gift Card No.", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                    MyTextField(
                      hint: "Enter Gift Card (16)",
                      maxLength: 16,
                      disableErrorText: true,
                      controller: checkoutController.checkoutGiftCardController,
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        if (checkoutController.checkoutGiftFormKey.currentState?.validate() ?? false) {
                          CheckoutPage.isGiftcardValidated.value = true;
                        } else {
                          CheckoutPage.isGiftcardValidated.value = false;
                        }
                      },
                      validator: (String? value) {
                        if (value?.isEmpty == true) {
                          return "Giftcard No. required";
                        } else if ((value?.trim().length ?? 0) != 16) {
                          return "Giftcard No. has to be 16 digits";
                        }
                        return null;
                      },
                    ),

                    //+ Gift Card Pin
                    const MyText(text: "Pin", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 0, paddingBottom: 5),
                    MyTextField(
                      hint: "Enter Pin Code (4)",
                      maxLength: 4,
                      isObSecure: true,
                      controller: checkoutController.checkoutGiftPinController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      onChanged: (val) {
                        if (checkoutController.checkoutGiftFormKey.currentState?.validate() ?? false) {
                          CheckoutPage.isGiftcardValidated.value = true;
                        } else {
                          CheckoutPage.isGiftcardValidated.value = false;
                        }
                      },
                      validator: (String? value) {
                        if (value?.isEmpty == true) {
                          return "Giftcard Pin is required";
                        } else if ((value?.trim().length ?? 0) != 4) {
                          return "Giftcard Pin has to be 4 elements";
                        }
                        return null;
                      },
                    ),
                    // //+ apply button
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Obx(() {
                    //       return MyButton(
                    //         width: 200,
                    //         height: 50,
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w700,
                    //         text: "Pay with Gift Card",
                    //         textColor: apiController.isCheckingGiftCardBalance.value
                    //             ? AppColors.kWhiteColor
                    //             : isGiftcardValidated.value
                    //                 ? AppColors.kWhiteColor
                    //                 : AppColors.kLightGreyColor,
                    //         color: apiController.isCheckingGiftCardBalance.value
                    //             ? AppColors.kRedColor
                    //             : isGiftcardValidated.value
                    //                 ? AppColors.kGreenColor
                    //                 : AppColors.kSkyLightDullColor,
                    //         onPressed: () async {
                    //           applyGiftCard();
                    //         },
                    //       );
                    //     }),
                    //   ],
                    // ),
                    const SizedBox(height: 10),
                  ],
                ),

                //+ Payment method
                CheckoutPageContainer(
                  // height: 200,
                  headerNumber: checkoutController.shouldShowRedeemSection() ? "5" : "4",
                  headerText: "Payment",
                  children: [
                    Obx(() {
                      return PayOnlineCardsWidget(
                        checkBoxValue: checkoutController.selectedPaymentType.value == "stripe",
                        onChanged: (bool? value) async {
                          if (value == true) {
                            if (checkoutController.selectedPaymentType.value == "hybrid") {
                              showMsg(
                                msg:
                                    "You are paying via a split method to split the bill between GiftCard and Card Payment. "
                                    "If you do not want to do that, go back to Cart page and come to the Checkout page again to"
                                    " reset the selected payment method.",
                                time: const Duration(seconds: 4),
                              );
                            } else {
                              checkoutController.selectedPaymentType.value = "stripe";
                              Future.delayed(const Duration(milliseconds: 100), () {
                                sc.animateTo(sc.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                              });
                              await Future.delayed(const Duration(milliseconds: 300));
                              FocusScope.of(context).requestFocus(focus);
                            }
                          } else {
                            checkoutController.selectedPaymentType.value = "";
                          }
                          checkoutController.isPaymentStripeSelected.value = (value ?? false);
                        },
                      );
                    }),
                  ],
                ),

                /* */
                //+ Membership card
                /*! Moved down to combined section !*/
                // authController.userData.value.id.isNotEmpty
                //     ? CheckoutPageContainer(
                //         isForm: true,
                //         formKey: checkoutController.membershipFormKey,
                //         // height: 260,
                //         headerNumber: "",
                //         headerText: "Membership Card",
                //         children: [
                //           //+ Membership Card No.
                //           const MyText(
                //             text: "Membership Card No.",
                //             fontSize: 15,
                //             fontWeight: FontWeight.bold,
                //             paddingLeft: 15,
                //             paddingTop: 10,
                //             paddingBottom: 5,
                //           ),
                //           MyTextField(
                //             hint: "Apply Membership Card (16)",
                //             // maxLength: 16,
                //             controller: checkoutController.membershipCardController,
                //             keyboardType: TextInputType.number,
                //             inputFormatters: [
                //               LengthLimitingTextInputFormatter(16),
                //             ],
                //             validator: (String? value) {
                //               return null;
                //             },
                //           ),
                //           const MyText(
                //             text: "ⓘ Membership discount only works with simple card payments. "
                //                 "It will be removed if you use the Giftcard, Points, or Hybrid method of payment.",
                //             color: AppColors.kRedColor,
                //             fontWeight: FontWeight.normal,
                //             maxLines: 3,
                //             fontSize: 14,
                //             paddingTop: 5,
                //             paddingLeft: 15,
                //             paddingRight: 5,
                //           ),
                //           //+ apply button
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.end,
                //             children: [
                //               Obx(() {
                //                 return MyButton(
                //                   width: 100,
                //                   height: 50,
                //                   text: "Apply",
                //                   textColor: apiController.isLoadingMembershipCardDetails.value ? AppColors.kWhiteColor : AppColors.kLightGreyColor,
                //                   fontSize: 14,
                //                   color: apiController.isLoadingMembershipCardDetails.value ? AppColors.kGreenColor : AppColors.kSkyLightDullColor,
                //                   onPressed: () {
                //                     //! apply membership card
                //                     // TextInput.finishAutofillContext();
                //                     String val = checkoutController.membershipCardController.text.trim();
                //                     if (val.isNotEmpty && val.isNum && val.length == 16) {
                //                       if (checkoutController.selectedPaymentType.value != "hybrid" &&
                //                           checkoutController.selectedPaymentType.value != "redeemGift" &&
                //                           checkoutController.selectedPaymentType.value != "redeemPoint") {
                //                         if (!apiController.isLoadingMembershipCardDetails.value &&
                //                             checkoutController.membershipCardController.text.trim() != checkoutController.membershipCardNoApplied) {
                //                           membershipController.getMembershipCardDetails();
                //                         } else if (checkoutController.membershipCardController.text.trim() == checkoutController.membershipCardNoApplied) {
                //                           showMsg(
                //                             msg:
                //                                 "You just applied this card, if ${orderController.discount.value == 0.0 ? "this did not work, please try with a different one" : "you want to try with another one, please do that"}.",
                //                             time: const Duration(seconds: 4),
                //                           );
                //                         }
                //                       } else if (checkoutController.selectedPaymentType.value == "redeemGift") {
                //                         showMsg(msg: "Membership discount cannot be applied when using a Giftcard.", time: const Duration(seconds: 4));
                //                       } else if (checkoutController.selectedPaymentType.value == "redeemPoint") {
                //                         showMsg(msg: "Membership discount cannot be applied when Redeeming Points.", time: const Duration(seconds: 4));
                //                       }
                //                     } else {
                //                       showMsg(msg: "Please enter a valid 16 digit membership card no.");
                //                     }
                //                   },
                //                 );
                //               }),
                //             ],
                //           ),
                //           const SizedBox(height: 10),
                //         ],
                //       )
                //     : const SizedBox(),

                /* */

                //+ Combined Discount part
                /* ! The giftcard part is moved back up and no other discount is available as of now. ! */
                // CheckoutPageContainer(
                //   isForm: true,
                //   // height: 260,
                //   headerNumber: checkoutController.shouldShowRedeemSection() ? "5" : "4",
                //   headerText: "Discount",
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                //       width: Get.width - 5,
                //       child: Row(
                //         children: [
                //           SizedBox(
                //             width: 95,
                //             child: Obx(() {
                //               return MyCheckBoxTile(
                //                 cbh: 30,
                //                 cbw: 30,
                //                 title: "Giftcard",
                //                 value: checkoutController.selectedDiscountOption.value == DT.gift.name,
                //                 color: AppColors.kLogoBasedColor,
                //                 borderRadius: 10,
                //                 onChanged: (value) {
                //                   checkoutController.selectedDiscountOption.value = DT.gift.name;
                //                   // checkoutController.shouldSendMessage.value = value ?? false;
                //                 },
                //               );
                //             }),
                //           ),
                //
                //           /* +++ COMMENTING THIS PART TO GET A BUILD WITHOUT THESE SECTIONS +++ */
                //           /* +++ BUT NOT COMMENTING ITS WIDGETS IN THE COLUMN UNDERNEATH IT BECAUSE THEY WILL NEVER BE VISIBLE WITHOUT THESE  +++ */
                //           // Obx(() {
                //           //   return authController.userData.value.id.isNotEmpty
                //           //       ? SizedBox(
                //           //           width: 130,
                //           //           child: MyCheckBoxTile(
                //           //             cbh: 30,
                //           //             cbw: 30,
                //           //             title: "Membership Discount",
                //           //             value: checkoutController.selectedDiscountOption.value == DT.msdiscount.name,
                //           //             color: AppColors.kLogoBasedColor,
                //           //             borderRadius: 10,
                //           //             onChanged: (value) {
                //           //               checkoutController.selectedDiscountOption.value = DT.msdiscount.name;
                //           //             },
                //           //           ),
                //           //         )
                //           //       : const SizedBox();
                //           // }),
                //           // Expanded(
                //           //   child: Obx(() {
                //           //     return MyCheckBoxTile(
                //           //       cbh: 30,
                //           //       cbw: 30,
                //           //       title: "Sales Person Discount",
                //           //       value: checkoutController.selectedDiscountOption.value == DT.spdiscount.name,
                //           //       color: AppColors.kLogoBasedColor,
                //           //       borderRadius: 10,
                //           //       onChanged: (value) {
                //           //         value:
                //           //         checkoutController.selectedDiscountOption.value = DT.spdiscount.name;
                //           //         // checkoutController.shouldSendMessage.value = value ?? false;
                //           //       },
                //           //     );
                //           //   }),
                //           // ),
                //         ],
                //       ),
                //     ),
                //     Obx(() {
                //       return Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           //+ Gift card
                //           /*! Moved back up !*/
                //           // if (checkoutController.selectedDiscountOption.value == DT.gift.name) ...[
                //           //   //+ Gift Card No.
                //           //   const MyText(
                //           //     text: "Gift Card No.",
                //           //     fontSize: 15,
                //           //     fontWeight: FontWeight.bold,
                //           //     paddingLeft: 15,
                //           //     paddingTop: 10,
                //           //     paddingBottom: 5,
                //           //   ),
                //           //   MyTextField(
                //           //     hint: "Enter Gift Card (16)",
                //           //     maxLength: 16,
                //           //     disableErrorText: true,
                //           //     controller: checkoutController.checkoutGiftCardController,
                //           //     keyboardType: TextInputType.number,
                //           //     validator: (String? value) {
                //           //       if (value?.isEmpty == true) {
                //           //         return "Giftcard No. required";
                //           //       } else if ((value?.trim().length ?? 0) != 16) {
                //           //         return "Giftcard No. has to be 16 digits";
                //           //       }
                //           //       return null;
                //           //     },
                //           //   ),
                //           //
                //           //   //+ Gift Card Pin
                //           //   const MyText(
                //           //     text: "Pin",
                //           //     fontSize: 15,
                //           //     fontWeight: FontWeight.bold,
                //           //     paddingLeft: 15,
                //           //     paddingTop: 0,
                //           //     paddingBottom: 5,
                //           //   ),
                //           //   MyTextField(
                //           //     hint: "Enter Pin Code (4)",
                //           //     maxLength: 4,
                //           //     isObSecure: true,
                //           //     controller: checkoutController.checkoutGiftPinController,
                //           //     keyboardType: TextInputType.number,
                //           //     textInputAction: TextInputAction.done,
                //           //     validator: (String? value) {
                //           //       if (value?.isEmpty == true) {
                //           //         return "Giftcard Pin is required";
                //           //       } else if ((value?.trim().length ?? 0) != 4) {
                //           //         return "Giftcard Pin has to be 4 elements";
                //           //       }
                //           //       return null;
                //           //     },
                //           //   ),
                //           //   //+ apply button
                //           //   Row(
                //           //     mainAxisAlignment: MainAxisAlignment.end,
                //           //     children: [
                //           //       Obx(() {
                //           //         return MyButton(
                //           //           width: 100,
                //           //           height: 50,
                //           //           text: "Apply",
                //           //           textColor: apiController.isCheckingGiftCardBalance.value ? AppColors.kWhiteColor : AppColors.kLightGreyColor,
                //           //           fontSize: 14,
                //           //           color: apiController.isCheckingGiftCardBalance.value ? AppColors.kGreenColor : AppColors.kSkyLightDullColor,
                //           //           onPressed: () async {
                //           //             //! apply gift card
                //           //             // TextInput.finishAutofillContext();
                //           //             if (!apiController.isCheckingGiftCardBalance.value && !apiController.isPlacingOrder.value) {
                //           //               if (checkoutController.checkoutGiftCardController.text.trim().isNotEmpty &&
                //           //                   checkoutController.checkoutGiftCardController.text.trim().length == 16 &&
                //           //                   checkoutController.checkoutGiftPinController.text.trim().length == 4 &&
                //           //                   checkoutController.checkoutGiftPinController.text.trim().isNotEmpty) {
                //           //                 if (!apiController.isCheckingGiftCardBalance.value) {
                //           //                   await giftCardController.checkGiftCardBalance(shouldNavigate: false, checkingOnCheckout: true);
                //           //                 }
                //           //
                //           //                 if (giftCardController.myGiftCardDetails.value.data?.id.isNotEmpty ?? false) {
                //           //                   checkoutController.selectedPaymentType.value = "redeemGift";
                //           //                   if (checkoutController.membershipCardController.text.trim().isNotEmpty ||
                //           //                       checkoutController.spDiscountCodeController.text.trim().isNotEmpty) {
                //           //                     showMsg(msg: "Discount cannot be applied when using a Giftcard. So it is being removed.", time: const Duration(seconds: 4));
                //           //                     checkoutController.clearMembershipDiscountData();
                //           //                     checkoutController.clearSpDiscountData();
                //           //                     checkoutController.getDiscountedPayableTotal();
                //           //                   }
                //           //                   double giftCardBalance = double.tryParse(giftCardController.myGiftCardDetails.value.data?.totalAmount ?? "0.0") ?? 0.0;
                //           //                   double cartTotal = (orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) +
                //           //                           orderController.calculatedSalesTax.value)
                //           //                       .toPrecision(2);
                //           //                   if (giftCardBalance >= cartTotal) {
                //           //                     //+ this means we can directly pay using the giftcard. let's place the order here.
                //           //
                //           //                     if ((authController.userData.value.userId.isNotEmpty ||
                //           //                             (checkoutController.nameController.text.trim().isNotEmpty &&
                //           //                                 checkoutController.emailController.text.trim().isNotEmpty &&
                //           //                                 GetUtils.isEmail(checkoutController.emailController.text.trim()) &&
                //           //                                 checkoutController.phoneController.text.trim().isNotEmpty &&
                //           //                                 checkoutController.phoneController.text.trim().length == 10 &&
                //           //                                 checkoutController.phoneController.text.trim().isNumericOnly)) &&
                //           //                         (checkoutController.orderType.value == "pickup" ||
                //           //                             (checkoutController.orderType.value == "delivery" &&
                //           //                                 checkoutController.cityController.text.trim().isNotEmpty &&
                //           //                                 checkoutController.addressController.text.trim().isNotEmpty &&
                //           //                                 checkoutController.selectedState.value.isNotEmpty &&
                //           //                                 checkoutController.zipController.text.trim().isNotEmpty &&
                //           //                                 checkoutController.zipController.text.trim().length == 5))) {
                //           //                       if (!apiController.isPlacingOrder.value) {
                //           //                         log("authenticated");
                //           //                         apiController.placeOrder();
                //           //                       }
                //           //                     } else {
                //           //                       String errorText = "";
                //           //                       if (authController.userData.value.userId.isEmpty &&
                //           //                           (checkoutController.nameController.text.trim().isEmpty ||
                //           //                               checkoutController.emailController.text.trim().isEmpty ||
                //           //                               !GetUtils.isEmail(checkoutController.emailController.text.trim()) ||
                //           //                               checkoutController.phoneController.text.trim().isEmpty ||
                //           //                               checkoutController.phoneController.text.trim().length != 10 ||
                //           //                               !checkoutController.phoneController.text.trim().isNumericOnly)) {
                //           //                         errorText += "Following issues were found with user info: \n";
                //           //                         if (checkoutController.nameController.text.trim().isEmpty) {
                //           //                           errorText += " - Name not found \n";
                //           //                         }
                //           //                         if (checkoutController.emailController.text.trim().isEmpty) {
                //           //                           errorText += " - Email not found \n";
                //           //                         }
                //           //                         if (!GetUtils.isEmail(checkoutController.emailController.text.trim()) &&
                //           //                             checkoutController.emailController.text.trim().isNotEmpty) {
                //           //                           errorText += " - Invalid Email \n";
                //           //                         }
                //           //                         if (checkoutController.phoneController.text.trim().isEmpty) {
                //           //                           errorText += " - Phone No. not found \n";
                //           //                         }
                //           //                         if ((checkoutController.phoneController.text.trim().length != 10 ||
                //           //                                 !checkoutController.phoneController.text.trim().isNumericOnly) &&
                //           //                             checkoutController.phoneController.text.trim().isNotEmpty) {
                //           //                           errorText += " - Invalid Phone No. \n";
                //           //                         }
                //           //                         showMsg(msg: errorText);
                //           //                       }
                //           //                       if (checkoutController.orderType.value == "delivery" &&
                //           //                           (checkoutController.cityController.text.trim().isEmpty ||
                //           //                               checkoutController.addressController.text.trim().isEmpty ||
                //           //                               checkoutController.selectedState.value.isEmpty ||
                //           //                               checkoutController.zipController.text.trim().isEmpty ||
                //           //                               checkoutController.zipController.text.trim().length != 5)) {
                //           //                         errorText += "Following issues were found with Delivery info: \n";
                //           //                         if (checkoutController.cityController.text.trim().isEmpty) {
                //           //                           errorText += " - City not entered \n";
                //           //                         }
                //           //                         if (checkoutController.addressController.text.trim().isEmpty) {
                //           //                           errorText += " - Address not entered \n";
                //           //                         }
                //           //                         if (checkoutController.selectedState.value.isEmpty) {
                //           //                           errorText += " - State not selected \n";
                //           //                         }
                //           //                         if (checkoutController.zipController.text.trim().isEmpty) {
                //           //                           errorText += " - Zipcode not entered \n";
                //           //                         }
                //           //                         if (checkoutController.zipController.text.trim().length != 5 && checkoutController.zipController.text.trim().isNotEmpty) {
                //           //                           errorText += " - Invalid Zipcode \n";
                //           //                         }
                //           //                         showMsg(msg: errorText);
                //           //                       }
                //           //                     }
                //           //                   } else {
                //           //                     showMsg(
                //           //                         msg: "Your GiftCard balance is insufficient. Please try another one or pay via a Debit/Credit Card.",
                //           //                         time: const Duration(seconds: 4));
                //           //
                //           //                     /* +++ COMMENTING THIS PART TO GET A BUILD WITHOUT THESE SECTIONS +++ */
                //           //                     // showMyAnimatedDialog(
                //           //                     //   context: context,
                //           //                     //   child: MyConfirmDialog(
                //           //                     //     height: 280,
                //           //                     //     msg: "Your GiftCard balance is insufficient. Do you want to pay the remaining amount via Card?",
                //           //                     //     yesOnPressed: () async {
                //           //                     //       // Navigator.of(context).pop();
                //           //                     //       checkoutController.selectedPaymentType.value = "hybrid";
                //           //                     //
                //           //                     //       // Focus.of(context).nextFocus();
                //           //                     //       // Focus.of(context).nextFocus();
                //           //                     //       // log("cardName. requestFocus : ${cardName.canRequestFocus}");
                //           //                     //
                //           //                     //       await Future.delayed(const Duration(milliseconds: 500), () {
                //           //                     //         // Focus.of(context).nextFocus();
                //           //                     //         /* */
                //           //                     //         FocusScope.of(context).unfocus();
                //           //                     //         FocusScope.of(context).nextFocus();
                //           //                     //         /* */
                //           //                     //         // cardName.requestFocus();
                //           //                     //         // log("after cardName. requestFocus : ${cardName.canRequestFocus}");
                //           //                     //       });
                //           //                     //       sc.animateTo(sc.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                //           //                     //     },
                //           //                     //     noOnPressed: () {
                //           //                     //       checkoutController.selectedPaymentType.value = "";
                //           //                     //     },
                //           //                     //   ),
                //           //                     // );
                //           //                   }
                //           //                 }
                //           //               } else {
                //           //                 if (checkoutController.checkoutGiftCardController.text.trim().isEmpty) {
                //           //                   showMsg(msg: "Please enter GiftCard No.");
                //           //                 } else if (checkoutController.checkoutGiftCardController.text.trim().length != 16) {
                //           //                   showMsg(msg: "GiftCard No. should be 16 digits");
                //           //                 } else if (checkoutController.checkoutGiftPinController.text.trim().isEmpty) {
                //           //                   showMsg(msg: "Please enter GiftCard Pin Code");
                //           //                 } else if (checkoutController.checkoutGiftPinController.text.trim().length != 4) {
                //           //                   showMsg(msg: "GiftCard Pin should be 4 digits");
                //           //                 } else {
                //           //                   showMsg(msg: "Invalid Giftcard Data. Please enter a 16 digit Giftcard No. and a 4 digit Pin.");
                //           //                 }
                //           //               }
                //           //             }
                //           //           },
                //           //         );
                //           //       }),
                //           //     ],
                //           //   ),
                //           //   const SizedBox(height: 10),
                //           // ],
                //
                //           //+ Membership card
                //           if (checkoutController.selectedDiscountOption.value == DT.msdiscount.name && authController.userData.value.id.isNotEmpty) ...[
                //             //+ Membership Card No.
                //             const MyText(
                //               text: "Membership Card No.",
                //               fontSize: 15,
                //               fontWeight: FontWeight.bold,
                //               paddingLeft: 15,
                //               paddingTop: 10,
                //               paddingBottom: 5,
                //             ),
                //             MyTextField(
                //               hint: "Apply Membership Card (16)",
                //               // maxLength: 16,
                //               controller: checkoutController.membershipCardController,
                //               keyboardType: TextInputType.number,
                //               inputFormatters: [
                //                 LengthLimitingTextInputFormatter(16),
                //               ],
                //               validator: (String? value) {
                //                 return null;
                //               },
                //             ),
                //             const MyText(
                //               text: "ⓘ Membership discount only works with simple card payments. "
                //                   "It will be removed if you use the Giftcard, Points, or Hybrid method of payment.",
                //               color: AppColors.kRedColor,
                //               fontWeight: FontWeight.normal,
                //               maxLines: 3,
                //               fontSize: 14,
                //               paddingTop: 5,
                //               paddingLeft: 15,
                //               paddingRight: 5,
                //             ),
                //             //+ apply button
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.end,
                //               children: [
                //                 Obx(() {
                //                   return MyButton(
                //                     width: 100,
                //                     height: 50,
                //                     text: "Apply",
                //                     textColor: apiController.isLoadingMembershipCardDetails.value ? AppColors.kWhiteColor : AppColors.kLightGreyColor,
                //                     fontSize: 14,
                //                     color: apiController.isLoadingMembershipCardDetails.value ? AppColors.kGreenColor : AppColors.kSkyLightDullColor,
                //                     onPressed: () {
                //                       //! apply membership card
                //                       // TextInput.finishAutofillContext();
                //                       String val = checkoutController.membershipCardController.text.trim();
                //                       if (val.isNotEmpty && val.isNum && val.length == 16) {
                //                         if (checkoutController.selectedPaymentType.value != "hybrid" &&
                //                             checkoutController.selectedPaymentType.value != "redeemGift" &&
                //                             checkoutController.selectedPaymentType.value != "redeemPoint") {
                //                           if (checkoutController.spDiscountCodeController.text.trim().isNotEmpty) {
                //                             showMsg(
                //                               msg: "Sales Person Discount cannot be applied when using a Membership card. So it is being removed.",
                //                               time: const Duration(seconds: 4),
                //                             );
                //                             // checkoutController.clearMembershipDiscountData();
                //                             checkoutController.clearSpDiscountData();
                //                             checkoutController.getDiscountedPayableTotal();
                //                           }
                //
                //                           if (!apiController.isLoadingMembershipCardDetails.value &&
                //                               checkoutController.membershipCardController.text.trim() != checkoutController.membershipCardNoApplied) {
                //                             membershipController.getMembershipCardDetails();
                //                           } else if (checkoutController.membershipCardController.text.trim() == checkoutController.membershipCardNoApplied) {
                //                             showMsg(
                //                               msg:
                //                                   "You just applied this card, if ${orderController.discount.value == 0.0 ? "this did not work, please try with a different one" : "you want to try with another one, please do that"}.",
                //                               time: const Duration(seconds: 4),
                //                             );
                //                           }
                //                         } else if (checkoutController.selectedPaymentType.value == "redeemGift") {
                //                           showMsg(msg: "Membership discount cannot be applied when using a Giftcard.", time: const Duration(seconds: 4));
                //                         } else if (checkoutController.selectedPaymentType.value == "redeemPoint") {
                //                           showMsg(msg: "Membership discount cannot be applied when Redeeming Points.", time: const Duration(seconds: 4));
                //                         }
                //                       } else {
                //                         showMsg(msg: "Please enter a valid 16 digit membership card no.");
                //                       }
                //                     },
                //                   );
                //                 }),
                //               ],
                //             ),
                //             const SizedBox(height: 10),
                //           ],
                //
                //           //+ Sales person discount
                //           if (checkoutController.selectedDiscountOption.value == DT.spdiscount.name) ...[
                //             //+ Discount Code
                //             const MyText(
                //               text: "Discount Code",
                //               fontSize: 15,
                //               fontWeight: FontWeight.bold,
                //               paddingLeft: 15,
                //               paddingTop: 10,
                //               paddingBottom: 5,
                //             ),
                //             MyTextField(
                //               hint: "Apply Discount Code (6)",
                //               // maxLength: 16,
                //               controller: checkoutController.spDiscountCodeController,
                //               // keyboardType: TextInputType.number,
                //               inputFormatters: [
                //                 LengthLimitingTextInputFormatter(6),
                //               ],
                //               validator: (String? value) {
                //                 return null;
                //               },
                //             ),
                //             const MyText(
                //               text: "ⓘ Discount code only works with simple card payments. "
                //                   "It will be removed if you use the Giftcard, Points, or Hybrid method of payment.",
                //               color: AppColors.kRedColor,
                //               fontWeight: FontWeight.normal,
                //               maxLines: 3,
                //               fontSize: 14,
                //               paddingTop: 5,
                //               paddingLeft: 15,
                //               paddingRight: 5,
                //             ),
                //             //+ apply button
                //             Row(
                //               mainAxisAlignment: MainAxisAlignment.end,
                //               children: [
                //                 Obx(() {
                //                   return MyButton(
                //                     width: 100,
                //                     height: 50,
                //                     text: "Apply",
                //                     textColor: apiController.isLoadingSPDiscountCodeDetails.value ? AppColors.kWhiteColor : AppColors.kLightGreyColor,
                //                     fontSize: 14,
                //                     color: apiController.isLoadingSPDiscountCodeDetails.value ? AppColors.kGreenColor : AppColors.kSkyLightDullColor,
                //                     onPressed: () {
                //                       //! apply sales person discount code
                //                       // TextInput.finishAutofillContext();
                //                       String val = checkoutController.spDiscountCodeController.text.trim();
                //                       if (val.isNotEmpty && val.length == 6) {
                //                         if (checkoutController.selectedPaymentType.value != "hybrid" &&
                //                             checkoutController.selectedPaymentType.value != "redeemGift" &&
                //                             checkoutController.selectedPaymentType.value != "redeemPoint") {
                //                           if (checkoutController.membershipCardController.text.trim().isNotEmpty) {
                //                             showMsg(
                //                               msg: "Membership card discount cannot be applied when using a Sales Person Discount Code. So it is being removed.",
                //                               time: const Duration(seconds: 4),
                //                             );
                //                             checkoutController.clearMembershipDiscountData();
                //                             // checkoutController.clearSpDiscountData();
                //                             checkoutController.getDiscountedPayableTotal();
                //                           }
                //
                //                           if (!apiController.isLoadingSPDiscountCodeDetails.value &&
                //                               checkoutController.spDiscountCodeController.text.trim() != checkoutController.spDiscountCodeApplied) {
                //                             apiController.getSalesPersonDiscountCodeDetails();
                //                           } else if (checkoutController.spDiscountCodeController.text.trim() == checkoutController.spDiscountCodeApplied) {
                //                             showMsg(
                //                               msg:
                //                                   "You just applied this code, if ${orderController.discount.value == 0.0 ? "this did not work, please try with a different one" : "you want to try with another one, please do that"}.",
                //                               time: const Duration(seconds: 4),
                //                             );
                //                           }
                //                         } else if (checkoutController.selectedPaymentType.value == "redeemGift") {
                //                           showMsg(msg: "Discount code cannot be applied when using a Giftcard.", time: const Duration(seconds: 4));
                //                         } else if (checkoutController.selectedPaymentType.value == "redeemPoint") {
                //                           showMsg(msg: "Discount code cannot be applied when Redeeming Points.", time: const Duration(seconds: 4));
                //                         }
                //                       } else {
                //                         showMsg(msg: "Please enter a valid discount code.");
                //                       }
                //                     },
                //                   );
                //                 }),
                //               ],
                //             ),
                //             const SizedBox(height: 10),
                //           ],
                //         ],
                //       );
                //     }),
                //   ],
                // ),

                /*  + Card info + */
                Obx(() {
                  return (checkoutController.selectedPaymentType.value == "stripe" || checkoutController.selectedPaymentType.value == "hybrid") &&
                          checkoutController.selectedPaymentType.value != "redeemPoint"
                      ? CheckoutPageContainer(
                          isForm: true,
                          formKey: checkoutController.stripeFormKey,
                          // height: 550,
                          headerNumber: "",
                          headerText: "Please provide card info",
                          children: [
                            //+ Name on card
                            const MyText(text: "Name On Card", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                            MyTextField(
                              hint: "Please Enter Name",
                              // disableErrorText: true,
                              focusNode: focus,
                              controller: checkoutController.stripeNameController,
                              keyboardType: TextInputType.name,
                              autoFillHints: const [
                                AutofillHints.creditCardName,
                                AutofillHints.creditCardGivenName,
                                AutofillHints.creditCardFamilyName,
                                AutofillHints.creditCardMiddleName,
                              ],
                              validator: (String? value) {
                                if (value?.isEmpty == true) {
                                  return "Name is required";
                                }
                                return null;
                              },
                            ),

                            //+ Credit Card No.
                            const MyText(text: "Card Number", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                            MyTextField(
                              hint: "xxxxxxxxxxxxxxxx",
                              // disableErrorText: true,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(16),
                                //   CardFormatter(sample: "1234 5678 1234 5678", separator: " "),
                              ],
                              // maxLength: 16,
                              controller: checkoutController.stripeCardController,
                              autoFillHints: const [AutofillHints.creditCardNumber],
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value?.isEmpty == true) {
                                  return "Card Number is required";
                                } else if ((value?.trim().length ?? 0) != 15 && (value?.trim().length ?? 0) != 16) {
                                  return "Invalid Card Number";
                                } else if (!(value?.replaceAll(" ", "").isNumericOnly ?? false)) {
                                  return "Invalid Card Number";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                String cardType = getCardType(value);
                                log("Card Type : $cardType");
                              },
                            ),

                            //+ CVC
                            const MyText(text: "CVC", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                            MyTextField(
                              hint: "ex. 311",
                              // maxLength: 3,
                              // disableErrorText: true,
                              controller: checkoutController.stripeCVVController,
                              inputFormatters: [LengthLimitingTextInputFormatter(4)],
                              autoFillHints: const [AutofillHints.creditCardSecurityCode],
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value?.isEmpty == true) {
                                  return "CVC is required";
                                } else if ((value?.trim().length ?? 0) != 3 && (value?.trim().length ?? 0) != 4) {
                                  return "Enter a 3/4 digit CVC/CVV";
                                } else if (!(value?.trim().isNumericOnly ?? false)) {
                                  return "Invalid CVC/CVV Number";
                                }
                                return null;
                              },
                            ),

                            //+ Expiry month
                            const MyText(text: "Expiry Month", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                            MyTextField(
                              hint: "MM",
                              // maxLength: 2,
                              // disableErrorText: true,
                              controller: checkoutController.stripeExpiryMonthController,
                              inputFormatters: [LengthLimitingTextInputFormatter(2)],
                              autoFillHints: const [AutofillHints.creditCardExpirationMonth],
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                if (value?.isEmpty == true) {
                                  return "Month is required";
                                } else if (!(value?.trim().isNumericOnly ?? false) || (int.tryParse(value?.trim() ?? "99") ?? 99) > 12) {
                                  return "Invalid Month Number";
                                }
                                return null;
                              },
                            ),

                            //+ Expiry year
                            const MyText(text: "Expiry Year", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                            MyTextField(
                              hint: "YYYY",
                              // maxLength: 4,
                              // disableErrorText: true,
                              controller: checkoutController.stripeExpiryYearController,
                              inputFormatters: [LengthLimitingTextInputFormatter(4)],
                              autoFillHints: const [AutofillHints.creditCardExpirationYear],
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.number,
                              // onFieldSubmitted: (val) => TextInput.finishAutofillContext(),
                              validator: (String? value) {
                                if (value?.isEmpty == true) {
                                  return "Year is required";
                                } else if ((value?.trim().length ?? 0) != 4) {
                                  return "Enter a 4 digit year";
                                } else if (!(value?.trim().isNumericOnly ?? false)) {
                                  return "Invalid Year";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        )
                      : const SizedBox();
                }),

                //+ Tip
                /*+ Commented As Requested by Allen +*/
                /*+ Un-Commented As Requested by Allen on Aug-13-2024 +*/

                //
                /* + COMMENTED OBX & the CHECK ON 28-DEC-2024 BECAUSE NOW TIP IS ALLOWED WITH POINTS WHERE $1 = 10 POINTS + */

                /* + UNCOMMENTED OBX & the CHECK ON 19-Jan-2025 BECAUSE NOW TIP IS NOT ALLOWED when redeeming points + */
                Obx(() {
                  return checkoutController.selectedPaymentType.value != "redeemPoint"
                      ? CheckoutPageContainer(
                          // isForm: true,
                          // height: 340,
                          headerNumber: "",
                          headerText: "Staff Tip",
                          children: [
                            Obx(() {
                              return SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.green,
                                  inactiveTrackColor: AppColors.kSkyLightDullColor,
                                  thumbShape: PolygonSliderThumb(
                                    // height: 25,
                                    // width: 70.0,
                                    width: 40.0,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    thumbRadius: 10.0,
                                    thumbText: "\$${checkoutController.tipTotal.value.toStringAsFixed(2)}",
                                    // thumbText: "${checkoutController.tipPercentage.value.round()}% \n= \$${checkoutController.tipTotal.value.toStringAsFixed(2)}",
                                  ),
                                ),
                                child: Slider(
                                  min: 0.0,
                                  max: 100.0,
                                  value: checkoutController.tipPercentage.value,
                                  thumbColor: AppColors.kLightSiteBasedLogoLikeColor,
                                  divisions: 100,
                                  label: "${checkoutController.tipPercentage.value.round()}%",
                                  // interval: 20,
                                  // showTicks: true,
                                  // thumbShape: ,
                                  // showLabels: true,
                                  // enableTooltip: true,
                                  // minorTicksPerInterval: 1,
                                  onChanged: (double value) {
                                    checkoutController.tipPercentage.value = value;
                                    checkoutController.getDiscountedPayableTotal();
                                  },
                                  onChangeStart: (double value) {
                                    hideKeyboard(context);
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 10),
                          ],
                        )
                      : const SizedBox();
                }),

                /* + Driver Tip + */
                /* + Commented on 12:52 AM Nov-27-2024 as requested by Allen+ */
                //
                /* + COMMENTED OBX & the CHECK ON 28-DEC-2024 BECAUSE NOW TIP IS ALLOWED WITH POINTS WHERE $1 = 10 POINTS + */

                /* + UNCOMMENTED OBX & the CHECK ON 19-Jan-2025 BECAUSE NOW TIP IS NOT ALLOWED when redeeming points + */
                Obx(() {
                  return checkoutController.selectedPaymentType.value != "redeemPoint" && checkoutController.orderType.value == "delivery"
                      ? CheckoutPageContainer(
                          // isForm: true,
                          // height: 340,
                          headerNumber: "",
                          headerText: "Driver Tip",
                          children: [
                            Obx(() {
                              return SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.green,
                                  inactiveTrackColor: AppColors.kSkyLightDullColor,
                                  thumbShape: PolygonSliderThumb(
                                    width: 40.0,
                                    // width: 70.0,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    thumbRadius: 10.0,
                                    thumbText: "\$${checkoutController.driverTipTotal.value.toStringAsFixed(2)}",
                                    // "${checkoutController.driverTipPercentage.value.round()}% = \$${checkoutController.driverTipTotal.value.toStringAsFixed(2)}",
                                  ),
                                ),
                                child: Slider(
                                  min: 0.0,
                                  max: 100.0,
                                  value: checkoutController.driverTipPercentage.value,
                                  thumbColor: AppColors.kLightSiteBasedLogoLikeColor,
                                  divisions: 100,
                                  label: "${checkoutController.driverTipPercentage.value.round()}%",
                                  // interval: 20,
                                  // showTicks: true,
                                  // thumbShape: ,
                                  // showLabels: true,
                                  // enableTooltip: true,
                                  // minorTicksPerInterval: 1,
                                  onChanged: (double value) {
                                    checkoutController.driverTipPercentage.value = value;
                                    checkoutController.getDiscountedPayableTotal();
                                  },
                                  onChangeStart: (double value) {
                                    hideKeyboard(context);
                                  },
                                ),
                              );
                            }),
                            const SizedBox(height: 10),
                          ],
                        )
                      : const SizedBox();
                }),

                const CheckoutPageContainer(
                  // height: 180,
                  headerNumber: "",
                  headerText: "Total",
                  children: [Padding(padding: EdgeInsets.all(10.0), child: CartTotalSection())],
                ),
                Obx(() {
                  return !authController.isLoggedIn.value ? const SizedBox(height: AppSizes.formsSizeBoxHeight) : const SizedBox();
                }),

                Obx(() {
                  return !authController.isLoggedIn.value
                      ? Padding(
                          padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 10, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RichText(
                                  maxLines: 10,
                                  textAlign: TextAlign.left,
                                  text: TextSpan(
                                    text:
                                        "By clicking \"Pay\" you agree that "
                                        "any information you provide to Sanmiwago "
                                        "will be used in accordance with Sanmiwago's ",
                                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                                    children: [
                                      TextSpan(
                                        text: "Privacy Policy",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigate to a privacy policy
                                            navigate(type: PageType.to, page: PrivacyPolicyPage());
                                          },
                                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.normal, decoration: TextDecoration.underline, fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: " and ",
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: "Terms & Conditions",
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            // Navigate to a privacy policy
                                            navigate(type: PageType.to, page: TermsOfUsePage());
                                          },
                                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontWeight: FontWeight.normal, fontSize: 16),
                                      ),
                                      TextSpan(
                                        text: ". ",
                                        // "We may contact you regarding your submission.",
                                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox();
                }),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),

                // const CheckoutPageContainer(
                //   // height: 180,
                //   headerNumber: "",
                //   headerText: "Terms",
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.all(10.0),
                //       child: CartTotalSection(),
                //     ),
                //   ],
                // ),

                // const SizedBox(height: AppSizes.formsSizeBoxHeight),
                Obx(() {
                  if (checkoutController.payWithGiftCard.value && checkoutController.isRedeemPointCheckout.value == false) {
                    return Container();
                  }
                  return Container(
                    height: 52,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() {
                      return MyButton(
                        text: checkoutController.selectedPaymentType.value == "redeemPoint" ? "Pay - \$${0.0}" : "Pay - \$${checkoutController.checkoutFinalTotal.value}",
                        height: 52,
                        width: Get.width - 40,
                        padding: 0,
                        marginBottom: 10,
                        color: (!checkoutController.showRedeemSection.value && checkoutController.selectedPaymentType.value == "redeemPoint")
                            ? AppColors.kGreyColor
                            : AppColors.kGreenColor,
                        onPressed: () async {
                          // checkoutController.userInfoFormKey.currentState?.save();
                          // checkoutController.stripeFormKey.currentState?.save();
                          //! removed conditions
                          // checkoutController.stripeNameController.text.trim().isNotEmpty &&
                          // checkoutController.stripeCardController.text.trim().isNotEmpty &&
                          // checkoutController.stripeCVVController.text.trim().isNotEmpty &&
                          // checkoutController.stripeExpiryMonthController.text.trim().isNotEmpty &&
                          // checkoutController.stripeExpiryYearController.text.trim().isNotEmpty
                          /* */
                          // (authController.userData.value.userId.isEmpty &&
                          // checkoutController.nameController.text.trim().isNotEmpty &&
                          // checkoutController.emailController.text.trim().isNotEmpty &&
                          // checkoutController.phoneController.text.trim().isNotEmpty &&
                          // checkoutController.stripeNameController.text.trim().isNotEmpty &&
                          // checkoutController.stripeCardController.text.trim().isNotEmpty &&
                          // checkoutController.stripeCVVController.text.trim().isNotEmpty &&
                          // checkoutController.stripeExpiryMonthController.text.trim().isNotEmpty &&
                          // checkoutController.stripeExpiryYearController.text.trim().isNotEmpty)

                          log("checkoutController.userInfoFormKey.currentState?.validate(): ${checkoutController.userInfoFormKey.currentState?.validate()}");

                          log("isOrderDeliverable in pay: ${checkoutController.isOrderDeliverable.value}");
                          // return;
                          //+ userInfoFormKey.validate() is being removed because the listView was not keeping it alive.
                          //+ and because of that currentState of that form in these checks was coming out to be null.
                          var customerPhoneValidity = validateUsPhoneNumber(checkoutController.phoneController.text);
                          bool isCustomerPhoneValid = (customerPhoneValidity == null);
                          if (checkoutController.selectedPaymentType.isNotEmpty) {
                            if ((authController.userData.value.userId.isNotEmpty ||
                                        (checkoutController.nameController.text.trim().isNotEmpty &&
                                            checkoutController.emailController.text.trim().isNotEmpty &&
                                            GetUtils.isEmail(checkoutController.emailController.text.trim()) &&
                                            isCustomerPhoneValid)) &&
                                    (checkoutController.orderType.value == "pickup" ||
                                        (checkoutController.orderType.value == "delivery" &&
                                            checkoutController.fullAddressController.text.trim().isNotEmpty &&
                                            checkoutController.isOrderDeliverable.value
                                        // checkoutController.cityController.text.trim().isNotEmpty &&
                                        // checkoutController.addressController.text.trim().isNotEmpty &&
                                        // checkoutController.houseController.text.trim().isNotEmpty &&
                                        // checkoutController.buildingNameController.text.trim().isNotEmpty &&
                                        // checkoutController.neighborhoodController.text.trim().isNotEmpty &&
                                        // checkoutController.stateController.text.trim().isNotEmpty &&
                                        // checkoutController.selectedState.value.isNotEmpty &&
                                        // checkoutController.zipController.text.trim().isNotEmpty &&
                                        // checkoutController.zipController.text.trim().length == 5
                                        )) &&
                                    ((checkoutController.selectedPaymentType.value == "stripe" || checkoutController.selectedPaymentType.value == "hybrid") &&
                                        (checkoutController.stripeFormKey.currentState?.validate() ?? false)) ||
                                /* + Redeem points related checks + */
                                (checkoutController.selectedPaymentType.value == "redeemPoint" &&
                                    (checkoutController.orderType.value == "pickup" ||
                                        (checkoutController.orderType.value == "delivery" &&
                                            checkoutController.fullAddressController.text.trim().isNotEmpty &&
                                            checkoutController.isOrderDeliverable.value
                                        // checkoutController.cityController.text.trim().isNotEmpty &&
                                        // checkoutController.addressController.text.trim().isNotEmpty &&
                                        // checkoutController.houseController.text.trim().isNotEmpty &&
                                        // checkoutController.buildingNameController.text.trim().isNotEmpty &&
                                        // checkoutController.neighborhoodController.text.trim().isNotEmpty &&
                                        // checkoutController.stateController.text.trim().isNotEmpty &&
                                        // checkoutController.selectedState.value.isNotEmpty &&
                                        // checkoutController.zipController.text.trim().isNotEmpty &&
                                        // checkoutController.zipController.text.trim().length == 5
                                        ))) ||
                                /* + Redeem giftcard related checks + */
                                (checkoutController.selectedPaymentType.value == "redeemGift" &&
                                    (checkoutController.orderType.value == "pickup" ||
                                        (checkoutController.orderType.value == "delivery" &&
                                            checkoutController.fullAddressController.text.trim().isNotEmpty &&
                                            checkoutController.isOrderDeliverable.value
                                        // checkoutController.cityController.text.trim().isNotEmpty &&
                                        // checkoutController.addressController.text.trim().isNotEmpty &&
                                        // checkoutController.houseController.text.trim().isNotEmpty &&
                                        // checkoutController.neighborhoodController.text.trim().isNotEmpty &&
                                        // checkoutController.stateController.text.trim().isNotEmpty &&
                                        // checkoutController.zipController.text.trim().isNotEmpty &&
                                        // checkoutController.zipController.text.trim().length == 5
                                        )) &&
                                    (checkoutController.checkoutGiftCardController.text.trim().isNotEmpty &&
                                        checkoutController.checkoutGiftCardController.text.trim().length == 16 &&
                                        checkoutController.checkoutGiftPinController.text.trim().isNotEmpty))) {
                              log("payment form validated");

                              if (checkoutController.selectedPaymentType.value == "redeemPoint" && !checkoutController.shouldShowRedeemSection()) {
                                showMsg(msg: "You do not have enough points to redeem.");
                                return;
                              }

                              if (!apiController.isPlacingOrder.value) {
                                try {
                                  FocusScope.of(context).unfocus();
                                } catch (e) {
                                  log("ERROR in focus removal: $e");
                                }
                                checkoutController.lastFour =
                                    (checkoutController.stripeCardController.text.isNotEmpty && checkoutController.stripeCardController.text.length >= 15)
                                    ? checkoutController.stripeCardController.text.substring(checkoutController.stripeCardController.text.length - 4)
                                    : "0000";
                                log("checkoutController.lastFour: ${checkoutController.lastFour}");
                                if (checkoutController.selectedPaymentType.value != "redeemGift") {
                                  await apiController.placeOrder();
                                } else {
                                  log("in applyGiftcard else");
                                  applyGiftCard();
                                }
                              }
                              /* */
                              // await Future.delayed(const Duration(seconds: 2));
                            } else {
                              log("else");
                              if ((authController.userData.value.userId.isEmpty) &&
                                  !((checkoutController.nameController.text.trim().isNotEmpty &&
                                      checkoutController.emailController.text.trim().isNotEmpty &&
                                      GetUtils.isEmail(checkoutController.emailController.text.trim()) &&
                                      isCustomerPhoneValid)) &&
                                  !(checkoutController.stripeFormKey.currentState?.validate() ?? false)) {
                                showMsg(msg: "Please enter user and card information");
                              } else if ((checkoutController.selectedPaymentType.value == "stripe" || checkoutController.selectedPaymentType.value == "hybrid") &&
                                  !(checkoutController.stripeFormKey.currentState?.validate() ?? false)) {
                                showMsg(msg: "Please enter valid card info");
                              } else {
                                log("else else");
                                String errorText = "";
                                if ((authController.userData.value.userId.isEmpty) &&
                                    (checkoutController.nameController.text.trim().isEmpty ||
                                        checkoutController.emailController.text.trim().isEmpty ||
                                        !GetUtils.isEmail(checkoutController.emailController.text.trim()) ||
                                        !isCustomerPhoneValid)) {
                                  // log("name: ${checkoutController.nameController.text.trim().isEmpty}"
                                  //     "email: ${checkoutController.emailController.text.trim().isEmpty}"
                                  //     "isEmail: ${!GetUtils.isEmail(checkoutController.emailController.text.trim())}"
                                  //     "phone: ${checkoutController.phoneController.text.trim().length != 10}");
                                  errorText += "Following issues were found with user info: \n";
                                  if (checkoutController.nameController.text.trim().isEmpty) {
                                    errorText += " - Name not found \n";
                                  }
                                  if (checkoutController.emailController.text.trim().isEmpty) {
                                    errorText += " - Email not found \n";
                                  }
                                  if (!GetUtils.isEmail(checkoutController.emailController.text.trim()) && checkoutController.emailController.text.trim().isNotEmpty) {
                                    errorText += " - Invalid Email \n";
                                  }
                                  if (!isCustomerPhoneValid) {
                                    errorText += " - ${customerPhoneValidity} \n";
                                  }

                                  // if (checkoutController.phoneController.text.trim().isEmpty) {
                                  //   errorText += " - Phone No. not found \n";
                                  // }
                                  // if ((checkoutController.phoneController.text.trim().length != 10 || !checkoutController.phoneController.text.trim().isNumericOnly) &&
                                  //     checkoutController.phoneController.text.trim().isNotEmpty) {
                                  //   errorText += " - Invalid Phone No. \n";
                                  // }
                                  showMsg(msg: errorText);
                                }

                                if ((checkoutController.orderType.value == "delivery") &&
                                    (
                                    // checkoutController.cityController.text.trim().isEmpty ||
                                    checkoutController.fullAddressController.text.trim().isEmpty || !checkoutController.isOrderDeliverable.value
                                    // checkoutController.addressController.text.trim().isEmpty ||
                                    // checkoutController.houseController.text.trim().isNotEmpty &&
                                    // checkoutController.buildingNameController.text.trim().isNotEmpty &&
                                    // checkoutController.neighborhoodController.text.trim().isNotEmpty &&
                                    // checkoutController.stateController.text.trim().isNotEmpty &&
                                    // checkoutController.selectedState.value.isEmpty ||
                                    // checkoutController.zipController.text.trim().isEmpty ||
                                    // checkoutController.zipController.text.trim().length != 5
                                    )) {
                                  // log("name: ${checkoutController.nameController.text.trim().isEmpty}"
                                  //     "email: ${checkoutController.emailController.text.trim().isEmpty}"
                                  //     "isEmail: ${!GetUtils.isEmail(checkoutController.emailController.text.trim())}"
                                  //     "phone: ${checkoutController.phoneController.text.trim().length != 10}");
                                  errorText += "Following issues were found with Delivery info: \n";
                                  // if (checkoutController.cityController.text.trim().isEmpty) {
                                  //   errorText += " - City not entered \n";
                                  // }
                                  // if (checkoutController.stateController.text.trim().isEmpty) {
                                  //   errorText += " - State not entered \n";
                                  // }
                                  // if (checkoutController.houseController.text.trim().isEmpty) {
                                  //   errorText += " - House No. not entered \n";
                                  // }
                                  // if (checkoutController.buildingNameController.text.trim().isEmpty) {
                                  //   errorText += " - Building Name not entered \n";
                                  // }
                                  // if (checkoutController.neighborhoodController.text.trim().isEmpty) {
                                  //   errorText += " - Neighborhood not entered \n";
                                  // }
                                  if (checkoutController.fullAddressController.text.trim().isEmpty) {
                                    errorText += " - No location selected \n";
                                  }
                                  if (!checkoutController.isOrderDeliverable.value && checkoutController.deliveryFeeInfo.value.isOutOfBound) {
                                    errorText += " - ${checkoutController.deliveryFeeInfo.value.isOutOfBoundMessage} \n";
                                  }
                                  if (!checkoutController.isOrderDeliverable.value && !checkoutController.deliveryFeeInfo.value.isOutOfBound) {
                                    errorText += " - Seems like we are unable to deliver to your address for now. Please try another one.  \n";
                                  }
                                  // if (checkoutController.addressController.text.trim().isEmpty) {
                                  //   errorText += " - Street not entered \n";
                                  // }
                                  // if (checkoutController.zipController.text.trim().isEmpty) {
                                  //   errorText += " - Zipcode not entered \n";
                                  // }
                                  // if (checkoutController.zipController.text.trim().length != 5 && checkoutController.zipController.text.trim().isNotEmpty) {
                                  //   errorText += " - Invalid Zipcode \n";
                                  // }
                                  showMsg(msg: errorText);
                                }

                                if ((checkoutController.selectedPaymentType.value == "redeemGift" &&
                                    (checkoutController.checkoutGiftCardController.text.trim().isNotEmpty ||
                                        checkoutController.checkoutGiftCardController.text.trim().length != 16 ||
                                        checkoutController.checkoutGiftPinController.text.trim().isNotEmpty))) {
                                  // log("name: ${checkoutController.nameController.text.trim().isEmpty}"
                                  //     "email: ${checkoutController.emailController.text.trim().isEmpty}"
                                  //     "isEmail: ${!GetUtils.isEmail(checkoutController.emailController.text.trim())}"
                                  //     "phone: ${checkoutController.phoneController.text.trim().length != 10}");
                                  errorText += "Following issues were found with Giftcard info: \n";
                                  if (checkoutController.checkoutGiftCardController.text.trim().isEmpty) {
                                    errorText += " - Giftcard No. not entered \n";
                                  } else if (checkoutController.checkoutGiftCardController.text.trim().length != 16) {
                                    errorText += " - Invalid Giftcard No. length \n";
                                  }
                                  if (checkoutController.checkoutGiftPinController.text.trim().isEmpty) {
                                    errorText += " - Giftcard Pin not entered \n";
                                  }
                                  showMsg(msg: errorText);
                                }
                                // showMsg(msg: "Please enter valid card information");
                              }
                            }
                          } else {
                            if (checkoutController.checkoutGiftCardController.text.isNotEmpty && checkoutController.checkoutGiftPinController.text.isNotEmpty) {
                              showMsg(msg: "Please select Pay with Giftcard checkbox");
                            } else if ((checkoutController.checkoutGiftCardController.text.isNotEmpty && checkoutController.checkoutGiftPinController.text.isEmpty) ||
                                (checkoutController.checkoutGiftCardController.text.isEmpty && checkoutController.checkoutGiftPinController.text.isNotEmpty)) {
                              showMsg(msg: "Please enter Giftcard No. and Pin and select the \"Pay with Giftcard\" checkbox and then click \"Pay\"");
                            } else {
                              showMsg(msg: "Please select a payment type");
                            }
                          }
                        },
                      );
                    }),
                  );
                }),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  applyGiftCard() async {
    //! apply gift card
    // TextInput.finishAutofillContext();
    if (!apiController.isCheckingGiftCardBalance.value && !apiController.isPlacingOrder.value) {
      if (checkoutController.checkoutGiftCardController.text.trim().isNotEmpty &&
          checkoutController.checkoutGiftCardController.text.trim().length == 16 &&
          checkoutController.checkoutGiftPinController.text.trim().length == 4 &&
          checkoutController.checkoutGiftPinController.text.trim().isNotEmpty &&
          checkoutController.selectedPaymentType.value != "redeemPoint" &&
          checkoutController.selectedPaymentType.value != "stripe") {
        if (!apiController.isCheckingGiftCardBalance.value) {
          showCircularLoading(isDismissible: false);
          await giftCardController.checkGiftCardBalance(shouldNavigate: false, checkingOnCheckout: true, showingOutsideLoading: true);
        }

        if (giftCardController.myGiftCardDetails.value.data?.id.isNotEmpty ?? false) {
          checkoutController.selectedPaymentType.value = "redeemGift";
          if (checkoutController.membershipCardController.text.trim().isNotEmpty || checkoutController.spDiscountCodeController.text.trim().isNotEmpty) {
            showMsg(msg: "Discount cannot be applied when using a Giftcard. So it is being removed.", time: const Duration(seconds: 4));
            checkoutController.clearMembershipDiscountData();
            checkoutController.clearSpDiscountData();
            checkoutController.clearCouponDiscountData();
            checkoutController.getDiscountedPayableTotal();
          }

          /*+ Commented As Requested by Allen +*/
          // below line to calculate total is added so that we are sure that the tip has been calculated correctly at this point
          // checkoutController.getDiscountedPayableTotal();
          double giftCardBalance = double.tryParse(giftCardController.myGiftCardDetails.value.data?.totalAmount ?? "0.0") ?? 0.0;
          double cartTotal =
              (orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) +
                      orderController.calculatedSalesTax.value +
                      checkoutController.tipTotal.value +
                      checkoutController.driverTipTotal.value +
                      checkoutController.deliveryFeeTotal.value)
                  .toPrecision(2);
          if (giftCardBalance >= cartTotal) {
            //+ this means we can directly pay using the giftcard. let's place the order here.

            var customerPhoneValidity = validateUsPhoneNumber(checkoutController.phoneController.text);
            bool isCustomerPhoneValid = (customerPhoneValidity == null);

            if ((authController.userData.value.userId.isNotEmpty ||
                    (checkoutController.nameController.text.trim().isNotEmpty &&
                        checkoutController.emailController.text.trim().isNotEmpty &&
                        GetUtils.isEmail(checkoutController.emailController.text.trim()) &&
                        isCustomerPhoneValid)) &&
                (checkoutController.orderType.value == "pickup" ||
                    (checkoutController.orderType.value == "delivery" &&
                        checkoutController.fullAddressController.text.trim().isNotEmpty &&
                        checkoutController.isOrderDeliverable.value
                    // checkoutController.houseController.text.trim().isNotEmpty &&
                    // checkoutController.buildingNameController.text.trim().isNotEmpty &&
                    // checkoutController.neighborhoodController.text.trim().isNotEmpty &&
                    // checkoutController.stateController.text.trim().isNotEmpty &&
                    // checkoutController.cityController.text.trim().isNotEmpty &&
                    // checkoutController.addressController.text.trim().isNotEmpty &&
                    // checkoutController.selectedState.value.isNotEmpty &&
                    // checkoutController.zipController.text.trim().isNotEmpty &&
                    // checkoutController.zipController.text.trim().length == 5
                    ))) {
              if (!apiController.isPlacingOrder.value) {
                log("authenticated");
                apiController.placeOrder(startLoading: false);
              }
            } else {
              dismissLoading();
              String errorText = "";
              if (authController.userData.value.userId.isEmpty &&
                  (checkoutController.nameController.text.trim().isEmpty ||
                      checkoutController.emailController.text.trim().isEmpty ||
                      !GetUtils.isEmail(checkoutController.emailController.text.trim()) ||
                      !isCustomerPhoneValid)) {
                errorText += "Following issues were found with user info: \n";
                if (checkoutController.nameController.text.trim().isEmpty) {
                  errorText += " - Name not found \n";
                }
                if (checkoutController.emailController.text.trim().isEmpty) {
                  errorText += " - Email not found \n";
                }
                if (!GetUtils.isEmail(checkoutController.emailController.text.trim()) && checkoutController.emailController.text.trim().isNotEmpty) {
                  errorText += " - Invalid Email \n";
                }
                if (!isCustomerPhoneValid) {
                  errorText += " - ${customerPhoneValidity} \n";
                }
                // if (checkoutController.phoneController.text.trim().isEmpty) {
                //   errorText += " - Phone No. not found \n";
                // }
                // if ((checkoutController.phoneController.text.trim().length != 10 || !checkoutController.phoneController.text.trim().isNumericOnly) &&
                //     checkoutController.phoneController.text.trim().isNotEmpty) {
                //   errorText += " - Invalid Phone No. \n";
                // }
                showMsg(msg: errorText);
              }
              if (checkoutController.orderType.value == "delivery" &&
                  (checkoutController.fullAddressController.text.trim().isEmpty || !checkoutController.isOrderDeliverable.value
                  // (checkoutController.cityController.text.trim().isEmpty ||
                  //     checkoutController.addressController.text.trim().isEmpty ||
                  //     checkoutController.houseController.text.trim().isNotEmpty &&
                  // checkoutController.buildingNameController.text.trim().isNotEmpty &&
                  // checkoutController.neighborhoodController.text.trim().isNotEmpty &&
                  // checkoutController.stateController.text.trim().isNotEmpty &&
                  // checkoutController.selectedState.value.isEmpty ||
                  // checkoutController.zipController.text.trim().isEmpty ||
                  // checkoutController.zipController.text.trim().length != 5)
                  )) {
                errorText += "Following issues were found with Delivery info: \n";
                // if (checkoutController.cityController.text.trim().isEmpty) {
                //   errorText += " - City not entered \n";
                // }
                // if (checkoutController.stateController.text.trim().isEmpty) {
                //   errorText += " - State not entered \n";
                // }
                // if (checkoutController.houseController.text.trim().isEmpty) {
                //   errorText += " - House No. not entered \n";
                // }
                // if (checkoutController.buildingNameController.text.trim().isEmpty) {
                //   errorText += " - Building Name not entered \n";
                // }
                // if (checkoutController.neighborhoodController.text.trim().isEmpty) {
                //   errorText += " - Neighborhood not entered \n";
                // }
                if (checkoutController.fullAddressController.text.trim().isEmpty) {
                  errorText += " - No location selected \n";
                }
                if (!checkoutController.isOrderDeliverable.value && checkoutController.deliveryFeeInfo.value.isOutOfBound) {
                  errorText += " - ${checkoutController.deliveryFeeInfo.value.isOutOfBoundMessage} \n";
                }
                if (!checkoutController.isOrderDeliverable.value && !checkoutController.deliveryFeeInfo.value.isOutOfBound) {
                  errorText += " - Seems like we are unable to deliver to your address for now. Please try another one.  \n";
                }
                // if (checkoutController.addressController.text.trim().isEmpty) {
                //   errorText += " - Street not entered \n";
                // }
                // if (checkoutController.zipController.text.trim().isEmpty) {
                //   errorText += " - Zipcode not entered \n";
                // }
                // if (checkoutController.zipController.text.trim().length != 5 && checkoutController.zipController.text.trim().isNotEmpty) {
                //   errorText += " - Invalid Zipcode \n";
                // }
                showMsg(msg: errorText);
              }
            }
          } else {
            dismissLoading();
            showMsg(msg: "Your GiftCard balance is insufficient. Please try another one or pay via a Debit/Credit Card.", time: const Duration(seconds: 4));

            /* +++ COMMENTING THIS PART TO GET A BUILD WITHOUT THESE SECTIONS +++ */
            // showMyAnimatedDialog(
            //   context: context,
            //   child: MyConfirmDialog(
            //     height: 280,
            //     msg: "Your GiftCard balance is insufficient. Do you want to pay the remaining amount via Card?",
            //     yesOnPressed: () async {
            //       // Navigator.of(context).pop();
            //       checkoutController.selectedPaymentType.value = "hybrid";
            //
            //       // Focus.of(context).nextFocus();
            //       // Focus.of(context).nextFocus();
            //       // log("cardName. requestFocus : ${cardName.canRequestFocus}");
            //
            //       await Future.delayed(const Duration(milliseconds: 500), () {
            //         // Focus.of(context).nextFocus();
            //         /* */
            //         FocusScope.of(context).unfocus();
            //         FocusScope.of(context).nextFocus();
            //         /* */
            //         // cardName.requestFocus();
            //         // log("after cardName. requestFocus : ${cardName.canRequestFocus}");
            //       });
            //       sc.animateTo(sc.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
            //     },
            //     noOnPressed: () {
            //       checkoutController.selectedPaymentType.value = "";
            //     },
            //   ),
            // );
          }
        }
        // else {
        //   dismissLoading();
        // }
      } else {
        if (checkoutController.checkoutGiftCardController.text.trim().isEmpty) {
          showMsg(msg: "Please enter GiftCard No.");
        } else if (checkoutController.checkoutGiftCardController.text.trim().length != 16) {
          showMsg(msg: "GiftCard No. should be 16 digits");
        } else if (checkoutController.checkoutGiftPinController.text.trim().isEmpty) {
          showMsg(msg: "Please enter GiftCard Pin Code");
        } else if (checkoutController.checkoutGiftPinController.text.trim().length != 4) {
          showMsg(msg: "GiftCard Pin should be 4 digits");
        } else if (checkoutController.selectedPaymentType.value == "redeemPoint") {
          showMsg(
            msg:
                "You cannot use both GiftCard and Redeem points. "
                "Please uncheck the Redeem Points method or just simply place the order via Pay button.",
            time: const Duration(seconds: 4),
          );
        } else if (checkoutController.selectedPaymentType.value == "stripe") {
          showMsg(
            msg:
                "You cannot use both GiftCard and Debit/Credit Card. "
                "Please uncheck the Pay Online method or just simply fill out card details "
                "and place the order via Pay button.",
            time: const Duration(seconds: 4),
          );
        } else {
          showMsg(msg: "Invalid Giftcard Data. Please enter a 16 digit Giftcard No. and a 4 digit Pin.");
        }
      }
    }
  }
}
