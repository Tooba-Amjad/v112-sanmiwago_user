import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/widgets/fields_container.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';

class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  // final FocusNode emailFocusNode;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 10),
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      content: Form(
        key: authController.forgotPasswordFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          height: 230,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Expanded(
                    flex: 3,
                    child: MyText(
                      text: "Forgot Password?",
                      color: AppColors.kBlackColor,
                      fontWeight: FontWeight.w500,
                      align: TextAlign.center,
                      fontSize: 18,
                      paddingLeft: 40,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      hideKeyboard(context);
                      if(!authController.loading.value) {
                        Get.back(); //+ to close the dialog
                        authController.forgotPasswordEmailController.clear();
                      } else {
                        //+ do something
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.kInputTextColor,
                        weight: 1000,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
              MyTextField(
                // focusNode: emailFocusNode,
                hint: "Email",
                controller: authController.forgotPasswordEmailController,
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
                onChanged: (value) {
                  if ((!GetUtils.isEmail(value.trim()) || authController.passwordController.text.isEmpty)) {
                    authController.isDisable.value = true;
                  } else {
                    authController.isDisable.value = false;
                  }
                },
              ),
              const SizedBox(height: AppSizes.formsSizeBoxHeight),
              //+ Submit button
              Obx(() {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: MaterialButton(
                    color: authController.loading.value == true ? AppColors.kGreenColor : AppColors.kRedColor,
                    height: 52,
                    minWidth: Get.width - 30,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onPressed: () async {
                      hideKeyboard(context);
                      authController.loading.value = true;
                      await authController.forgotPassword(context);
                      Future.delayed(const Duration(seconds: 1), () {
                        authController.loading.value = false;
                      });
                      // : authController.logIn();
                    },
                    child: const MyText(
                      text: "Submit",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
