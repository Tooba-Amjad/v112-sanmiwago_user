import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/formatters/date_formatter.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/pages/signup/activate_account.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/privacy_policy.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/terms_of_use.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';
import 'package:simple_timer/simple_timer.dart';
import '../../../constants/app_constants.dart';
import '../../../generated/assets.dart';
import '../../../utils/formatters/us_phone_number_formatter.dart';
import '../../../utils/validators/us_phone_number_validator.dart';

class SignupOTPSectionWidget extends StatelessWidget {
  const SignupOTPSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[/* + Valid Phone number text + */
        Obx(() {
          return authController.isNumValid.value
              ? const MyText(
            text: "✅ Valid Number",
            color: AppColors.kGreenColor,
            fontWeight: FontWeight.normal,
            maxLines: 2,
            fontSize: 14,
            paddingTop: 5,
            paddingLeft: 15,
            paddingRight: 5,
          )
              : SizedBox.shrink();
        }),

        /* + Valid Phone number text + */
        Obx(() {
          return authController.isOtpVerified.value
              ? Row(
            children: [
              SizedBox(width: 13),
              Image.asset(
                Assets.iconsVerify,
                height: 20,
                width: 20,
              ),
              const MyText(
                text: "OTP Verified",
                color: AppColors.kGreenColor,
                fontWeight: FontWeight.normal,
                maxLines: 2,
                fontSize: 14,
                paddingTop: 5,
                paddingLeft: 5,
                paddingRight: 5,
              ),
            ],
          )
              : SizedBox.shrink();
        }),

        Obx(() {
          return SizedBox(height: authController.isOtpSent.value && !authController.isOtpVerified.value ? AppSizes.formsSizeBoxHeight : 0);
        }),

        Obx(() {
          return authController.isOtpSent.value && !authController.isOtpVerified.value
              ? MyTextField(
            // hint: "Phone No",
            hint: 'OTP',
            controller: authController.signupOTPController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,

            autoFillHints: const [
              AutofillHints.telephoneNumber,
              AutofillHints.telephoneNumberDevice,
            ],
            inputFormatters: [
              // LengthLimitingTextInputFormatter(10),
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (String? val) {
              String value = val ?? "";
              if (value.isEmpty == true) {
                return "OTP is required";
              }
              return null;
            },
          )
              : SizedBox();
        }),
        Obx(() {
          return authController.isOtpSent.value && !authController.isOtpVerified.value
              ? Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: const MyText(
                      text: "ⓘ Did not receive OTP?",
                      color: AppColors.kLogoBasedColor,
                      fontWeight: FontWeight.w600,
                      maxLines: 2,
                      fontSize: 14,
                      paddingTop: 5,
                      paddingLeft: 15,
                      paddingRight: 5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const MyText(
                    text: "You can resend in:",
                    color: AppColors.kLogoBasedColor,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    fontSize: 14,
                    paddingTop: 0,
                    paddingLeft: 15,
                    paddingRight: 5,
                  ),
                  Obx(() {
                    final timeDiff =
                        authController.otpSentAt.add(Duration(seconds: AppConstants.resendSignupOTPSecondsLimit)).difference(DateTime.now()).inSeconds;

                    return !authController.isOtpBeingSent.value &&
                        !authController.isOtpBeingResent.value &&
                        authController.isOtpSent.value &&
                        !authController.isOtpVerified.value
                        ? SizedBox(
                      height: 35,
                      width: 35,
                      child: SimpleTimer(
                        key: const Key("authOtpResendAfterTimer"),
                        // controller: timerController,
                        strokeWidth: 0,
                        progressTextStyle: const TextStyle(color: AppColors.kLogoBasedColor, fontSize: 16, fontWeight: FontWeight.w600),
                        displayProgressIndicator: false,
                        status: TimerStatus.start,
                        duration: Duration(seconds: timeDiff < 0 ? 0 : timeDiff),
                        onEnd: () async {
                          authController.canResendOtp(true);
                        },
                      ),
                    )
                        : authController.isOtpSent.value && !authController.isOtpVerified.value
                        ? SizedBox(
                      height: 35,
                      width: 35,
                      child: SimpleTimer(
                        key: const Key("recoveryTimerTemp"),
                        // controller: timerController,
                        strokeWidth: 0,
                        progressTextStyle: const TextStyle(color: AppColors.kLogoBasedColor, fontSize: 20, fontWeight: FontWeight.w600),
                        displayProgressIndicator: false,
                        status: TimerStatus.start,
                        duration: const Duration(seconds: 0),
                        // onEnd: () async {},
                      ),
                    )
                        : SizedBox();
                  }),
                  const MyText(
                    text: "seconds",
                    color: AppColors.kLogoBasedColor,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    fontSize: 14,
                    paddingTop: 0,
                    paddingLeft: 5,
                    paddingRight: 5,
                  ),
                ],
              ),
            ],
          )
              : SizedBox();
        }),
        const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),

        /* + Resend OTP, Send OTP & Verify OTP buttons + */
        Align(
          alignment: Alignment.centerRight,
          // mainAxisAlignment: MainAxisAlignment.end,
          // mainAxisSize: MainAxisSize.min,
          // children: [],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              /* + Resend OTP + */
              Obx(() {
                return authController.isOtpSent.value && authController.isNumValid.value && !authController.isOtpVerified.value
                    ? Container(
                  padding: const EdgeInsets.only(right: 15),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    color: authController.isOtpBeingResent.value == true
                        ? AppColors.kGreenColor
                        : authController.canResendOtp.value
                        ? AppColors.kRedColor
                        : AppColors.kSkyLightColor, // .withOpacity(0.3),
                    height: 35,
                    minWidth: 100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () {
                      hideKeyboard(context);
                      var timeDiff =
                          authController.otpSentAt.add(Duration(seconds: AppConstants.resendSignupOTPSecondsLimit)).difference(DateTime.now()).inSeconds;

                      if (!authController.isNumValid.value) {
                        showMsg(msg: "Number should be a valid US number");
                        return;
                      }

                      if (timeDiff <= 0) {
                        authController.sendOTP(isResending: true);
                      } else {
                        showMsg(msg: "You cannot resend OTP before the timer expires. Please wait!");
                      }
                    },
                    child: const MyText(
                      text: "Resend OTP",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                )
                    : SizedBox(height: 10);
              }),
              SizedBox(width: 10),

              /* + Send / Verify OTP + */
              Obx(() {
                log("authController.isOtpSent.value: ${authController.isOtpSent.value}");
                log("authController.isNumValid.value: ${authController.isNumValid.value}");
                return !authController.isOtpSent.value && authController.isNumValid.value
                    ? Container(
                  padding: const EdgeInsets.only(right: 15),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    color: authController.isOtpBeingSent.value == true ? AppColors.kGreenColor : AppColors.kRedColor,
                    height: 35,
                    minWidth: 100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () {
                      hideKeyboard(context);
                      if (authController.isNumValid.value) {
                        authController.sendOTP();
                      }
                    },
                    child: const MyText(
                      text: "Send OTP",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                )
                    : authController.isOtpSent.value && !authController.isOtpVerified.value
                    ? Container(
                  padding: const EdgeInsets.only(right: 15),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    color: authController.isOtpBeingVerified.value == true ? AppColors.kGreenColor : AppColors.kRedColor,
                    height: 35,
                    minWidth: 100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () {
                      hideKeyboard(context);
                      if (authController.signupOTPController.text.trim().isNotEmpty) {
                        authController.verifyOTP();
                      } else {
                        showMsg(msg: "OTP is required");
                      }
                    },
                    child: const MyText(
                      text: "Verify OTP",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                )
                    : SizedBox(height: 10);
              }),
            ],
          ),
        ),
      ],
    );
  }
}

