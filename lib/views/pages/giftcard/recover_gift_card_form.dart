import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:simple_timer/simple_timer.dart';

import '../../../utils/formatters/us_phone_number_formatter.dart';
import '../../../utils/snack_bar.dart';
import '../../../utils/validators/us_phone_number_validator.dart';

class RecoverGiftCardForm extends StatelessWidget {
  const RecoverGiftCardForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: giftCardController.recoverFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: MyFormPage(
        pageTopPadding: Get.height * 0.12,
        children: [
          const Align(
            alignment: Alignment.center,
            child: MyText(
              text: "Recover your GiftCard number",
              align: TextAlign.center,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              paddingTop: 20,
              paddingBottom: 20,
              paddingLeft: 15,
              paddingRight: 15,
            ),
          ),
          //+ Gift Card No.
          const MyText(
            text: "GiftCard Last 4",
            fontSize: 15,
            fontWeight: FontWeight.bold,
            paddingLeft: 15,
            paddingTop: 10,
            paddingBottom: 5,
          ),
          Obx(() {
            return MyTextField(
              hint: "Enter last 4 digits  of GiftCard",
              controller: giftCardController.recoverGiftCardLast4Controller,
              keyboardType: TextInputType.number,
              isReadOnly: giftCardController.isOTPSentForRecovery.value,
              inputFormatters: [LengthLimitingTextInputFormatter(4)],
              validator: (String? val) {
                String value = val ?? "";
                if (value.isEmpty == true) {
                  return "GiftCard last 4 digits are required";
                } else if (!value.trim().isNumericOnly || value.trim().length < 4) {
                  return "Invalid, require last 4 digits";
                }
                return null;
              },
            );
          }),

          //+ Gift Card email
          const MyText(
            text: "Email",
            fontSize: 15,
            fontWeight: FontWeight.bold,
            paddingLeft: 15,
            paddingTop: 10,
            paddingBottom: 5,
          ),
          Obx(() {
            return MyTextField(
              hint: "Enter email associated with GiftCard",
              controller: giftCardController.recoverGiftCardEmailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              isReadOnly: giftCardController.isOTPSentForRecovery.value,
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
            );
          }),

          //+ Gift Card Phone
          const MyText(
            text: "Phone No.",
            fontSize: 15,
            fontWeight: FontWeight.bold,
            paddingLeft: 15,
            paddingTop: 10,
            paddingBottom: 5,
          ),
          Obx(() {
            return MyTextField(
              hint: "Enter Phone No. (10)",
              controller: giftCardController.recoverGiftCardPhoneController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              isReadOnly: giftCardController.isOTPSentForRecovery.value,
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
            );
          }),

          Obx(() {
            var timeDiff = giftCardController.otpSentAt.add(Duration(seconds: giftCardController.otpExpireTimeInSec.toInt())).difference(DateTime.now()).inSeconds;
            return !giftCardController.isOTPSentForRecovery.value
                ? const SizedBox()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //+ Gift Card OTP
                      const MyText(
                        text: "OTP (6-Digits)",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        paddingLeft: 15,
                        paddingTop: 10,
                        paddingBottom: 5,
                      ),
                      MyTextField(
                        hint: "Enter OTP (6)",
                        controller: giftCardController.recoverGiftCardOTPController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        autoFillHints: const [
                          AutofillHints.oneTimeCode,
                        ],
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        validator: (String? val) {
                          String value = val ?? "";
                          if (value.isEmpty == true) {
                            return "OTP is required";
                          } else if (!value.isNumericOnly) {
                            return 'Please enter a valid digit only OTP';
                          } else if (value.trim().length != 6) {
                            return "Please enter your 6 digit OTP sent to the number you added.";
                          }
                          return null;
                        },
                      ),
                      Row(
                        children: [
                          const MyText(
                            text: "ⓘ OTP expires in",
                            color: AppColors.kRedColor,
                            fontWeight: FontWeight.normal,
                            maxLines: 2,
                            fontSize: 14,
                            paddingTop: 5,
                            paddingLeft: 15,
                            paddingRight: 5,
                          ),
                          Obx(() {
                            timeDiff =
                                giftCardController.otpSentAt.add(Duration(seconds: giftCardController.otpExpireTimeInSec.toInt())).difference(DateTime.now()).inSeconds;

                            return !apiController.isResendingOTPForGiftCard.value
                                ? SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: SimpleTimer(
                                      key: const Key("recoveryTimer"),
                                      // controller: timerController,
                                      strokeWidth: 0,
                                      progressTextStyle: const TextStyle(color: AppColors.kRedColor, fontSize: 20),
                                      displayProgressIndicator: false,
                                      status: TimerStatus.start,
                                      duration: Duration(seconds: timeDiff < 0 ? 0 : timeDiff),
                                      // onEnd: () async {},
                                    ),
                                  )
                                : SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: SimpleTimer(
                                      key: const Key("recoveryTimerTemp"),
                                      // controller: timerController,
                                      strokeWidth: 0,
                                      progressTextStyle: const TextStyle(color: AppColors.kRedColor, fontSize: 20),
                                      displayProgressIndicator: false,
                                      status: TimerStatus.start,
                                      duration: const Duration(seconds: 0),
                                      // onEnd: () async {},
                                    ),
                                  );
                          }),
                          const MyText(
                            text: "seconds",
                            color: AppColors.kRedColor,
                            fontWeight: FontWeight.normal,
                            maxLines: 2,
                            fontSize: 14,
                            paddingTop: 5,
                            paddingLeft: 5,
                            paddingRight: 5,
                          ),
                        ],
                      ),
                    ],
                  );
          }),

          const SizedBox(height: AppSizes.formsSizeBoxHeight),

          /* + Recover Gift Card button + */
          Align(
            alignment: Alignment.center,
            child: Obx(() {
              return MyButton(
                height: AppSizes.buttonHeight,
                width: Get.width * 0.90,
                text: giftCardController.isOTPSentForRecovery.value ? "Verify OTP" : "Recover GiftCard",
                color: apiController.isSendingRecoveryGiftCardDataForOTP.value || apiController.isVerifyingOTPForGiftCard.value
                    ? AppColors.kGreenColor
                    : AppColors.kRedColor,
                onPressed: () {
                  if (!giftCardController.isOTPSentForRecovery.value) {
                    /* + call initial recover method + */
                    giftCardController.recoverGiftCardSendInfoToGetOTP();
                  } else {
                    giftCardController.recoverVerifyOTPForGiftCard();
                  }
                },
              );
            }),
          ),

          /* + Resend OTP button + */
          Obx(() {
            return !giftCardController.isOTPSentForRecovery.value
                ? const SizedBox()
                : Align(
                    alignment: Alignment.center,
                    child: Obx(() {
                      return MyButton(
                        height: AppSizes.buttonHeight,
                        width: Get.width * 0.90,
                        text: "Resend OTP",
                        color: apiController.isResendingOTPForGiftCard.value ? AppColors.kGreenColor : AppColors.kRedColor,
                        onPressed: () {
                          var timeDiff = giftCardController.otpSentAt.add(Duration(seconds: giftCardController.otpExpireTimeInSec.toInt())).difference(DateTime.now()).inSeconds;

                          if (timeDiff <= 0) {
                            giftCardController.recoverResendOTPForGiftCard();
                          } else {
                            showMsg(msg: "OTP has been sent.");
                            log("not time yet");
                          }
                        },
                      );
                    }),
                  );
          }),
          const SizedBox(height: AppSizes.formsSizeBoxHeight),
        ],
      ),
    );
  }
}
