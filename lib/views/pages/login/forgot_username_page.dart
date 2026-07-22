import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

import '../../../utils/formatters/us_phone_number_formatter.dart';
import '../../../utils/validators/us_phone_number_validator.dart';

class ForgotUsernamePage extends StatelessWidget {
  const ForgotUsernamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: WillPopScope(
        onWillPop: () async {
          authController.forgotUsernamePhoneNumCont.clear();
          authController.forgotUsernameEmailCont.clear();
          return true;
        },
        child: Scaffold(
          // backgroundColor: AppColors.kGreyColor,
          backgroundColor: AppColors.kSkyLightDullColor,
          appBar: simpleAppBar(
            title: "Forgot Username",
            haveBackIcon: true,
            onBackPressed: () {
              hideKeyboard(context);
              Get.back();
              authController.forgotUsernamePhoneNumCont.clear();
              authController.forgotUsernameEmailCont.clear();
            },
          ),
          body: Form(
            key: authController.forgotUsernameStep1FormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: MyFormPage(
              pageTopPadding: Get.height * .25,
              children: [
                MyTextField(
                  // focusNode: phoneNumFocusNode,
                  hint: "Phone No",
                  controller: authController.forgotUsernamePhoneNumCont,
                  keyboardType: TextInputType.number,
                  autoFillHints: const [AutofillHints.telephoneNumber, AutofillHints.telephoneNumberDevice],
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
                    //   return "Phone No is required";
                    // } else if (!value.isNumericOnly) {
                    //   return 'Please enter a valid digit only phone number';
                    // } else if (value.trim().length != 10) {
                    //   return 'Please enter your 10 digit phone number';
                    // }
                    // return null;
                  },
                ),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),

                //+ email
                MyTextField(
                  hint: "Email",
                  controller: authController.forgotUsernameEmailCont,
                  keyboardType: TextInputType.emailAddress,
                  autoFillHints: const [AutofillHints.email],
                  validator: (String? value) {
                    if (value?.isEmpty == true) {
                      return "Email is required";
                    } else if (!GetUtils.isEmail(value?.trim() ?? "")) {
                      return "Please enter a valid email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.formsSizeBoxHeight),

                //+ Next button
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: MaterialButton(
                      color: authController.loading.value == true ? AppColors.kGreenColor : AppColors.kRedColor,
                      height: 52,
                      minWidth: Get.width - 30,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        hideKeyboard(context);
                        authController.loading.value = true;
                        authController.forgotUserNameStep1(context);
                        Future.delayed(const Duration(seconds: 1), () {
                          authController.loading.value = false;
                        });
                      },
                      child: const MyText(text: "Next", color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
