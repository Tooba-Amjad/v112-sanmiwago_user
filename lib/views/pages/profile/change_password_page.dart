import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        authController.changePassCurrentPassController.clear();
        authController.changePassNewPassController.clear();
        authController.changePassConfirmNewPassController.clear();
        return true;
      },
      child: Scaffold(
        // backgroundColor: AppColors.kGreyColor,
        backgroundColor: AppColors.kSkyLightDullColor,
        appBar: simpleAppBar(
          title: "Change Password",
          haveBackIcon: true,
          onBackPressed: () {
            Get.back();
            authController.changePassCurrentPassController.clear();
            authController.changePassNewPassController.clear();
            authController.changePassConfirmNewPassController.clear();
          },
        ),
        body: Form(
          key: authController.changePasswordFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: MyFormPage(
            pageTopPadding: Get.height * .18,
            children: [
              const SizedBox(height: AppSizes.formsSizeBoxHeight),

              Obx(() {
                return MyTextField(
                  controller: authController.changePassCurrentPassController,
                  hint: "Current Password",
                  isObSecure: !authController.showChangePassword.value,
                  keyboardType: TextInputType.visiblePassword,
                  autoFillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  validator: (String? value) {
                    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

                    if (value?.trim().isEmpty == true) {
                      return 'Current Password is Required';
                    } else if (!regex.hasMatch(value ?? "")) {
                      return 'Enter valid password containing 8 elements with at least 1 lowercase letter, 1 uppercase letter, 1 digit and 1 special character ';
                    }
                    // else if ((value?.trim().length ?? 0) < 6) {
                    //   return 'Password must have at least 6 elements';
                    // }

                    return null;
                  },
                );
              }),
              const SizedBox(height: AppSizes.formsSizeBoxHeight),
              Obx(() {
                return MyTextField(
                  controller: authController.changePassNewPassController,
                  hint: "New Password",
                  isObSecure: !authController.showChangePassword.value,
                  keyboardType: TextInputType.visiblePassword,
                  autoFillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  validator: (String? val) {
                    String? value = val ?? "";

                    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

                    if (value.trim().isEmpty ?? true) {
                      return 'Password is Required';
                    } else if (!regex.hasMatch(value ?? "")) {
                      return 'Enter valid password containing 8 elements with at least 1 lowercase letter, 1 uppercase letter, 1 digit and 1 special character ';
                    } else if (value.trim().length < 6 || value.trim().length > 20) {
                      return 'New Password must be 6 to 20 characters long';
                    } else if (value.trim() == authController.changePassCurrentPassController.text.trim()) {
                      return 'New & Old Password cannot be same';
                    }

                    return null;
                  },
                  // validator: (String? val) {
                  //   String value = val ?? "";
                  //   if (value.trim().isEmpty == true) {
                  //     return 'New Password is Required';
                  //   } else if (value.trim().length < 6 || value.trim().length > 20) {
                  //     return 'New Password must be 6 to 20 characters long';
                  //   } else if (value.trim() == authController.changePassCurrentPassController.text.trim()) {
                  //     return 'New & Old Password cannot be same';
                  //   }
                  //   return null;
                  // },
                );
              }),
              const SizedBox(height: AppSizes.formsSizeBoxHeight),
              Obx(() {
                return MyTextField(
                  controller: authController.changePassConfirmNewPassController,
                  hint: "Confirm New Password",
                  isObSecure: !authController.showChangePassword.value,
                  keyboardType: TextInputType.visiblePassword,
                  autoFillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  validator: (String? val) {
                    String value = val ?? "";
                    RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

                    if (value.trim().isEmpty == true) {
                      return 'Confirm Password is Required';
                    } else if (!regex.hasMatch(value ?? "")) {
                      return 'Enter valid password containing 8 elements with at least 1 lowercase letter, 1 uppercase letter, 1 digit and 1 special character ';
                    } else if (value.trim().length < 6 || value.trim().length > 20) {
                      return 'New Password must be 6 to 20 characters long';
                    } else if (value.trim() != authController.changePassNewPassController.text.trim()) {
                      return 'Password mismatch. Should be same as New Password.';
                    } else if (value.trim() == authController.changePassCurrentPassController.text.trim()) {
                      return 'New & Old Password cannot be same';
                    }
                    return null;
                  },
                );
              }),

              //+ show password check box
              Obx(() {
                return MyCheckBoxTile(
                  title: "show password",
                  value: authController.showChangePassword.value,
                  onChanged: (bool? value) {
                    // this.value = value;
                    log("check box value: $value");
                    authController.showChangePassword.value = (value ?? false);
                  },
                );
              }),

              const SizedBox(height: AppSizes.formsSizeBoxHeight),

              //+ submit button
              Obx(() {
                return MyButton(
                  text: "Submit",
                  height: AppSizes.buttonHeight,
                  width: Get.width - 30,
                  padding: 10,
                  marginBottom: 10,
                  color: apiController.isUpdatingPassword.value ? AppColors.kGreenColor : AppColors.kRedColor,
                  textColor: AppColors.kWhiteColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  onPressed: () {
                    authController.updatePassword();
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
