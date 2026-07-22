import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class ForgotUsernameFoundEmailPage extends StatelessWidget {
  const ForgotUsernameFoundEmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        authController.forgotUsernameEmailCont.clear();
        return true;
      },
      child: Scaffold(
        // backgroundColor: AppColors.kGreyColor,
        backgroundColor: AppColors.kSkyLightDullColor,
        appBar: simpleAppBar(
          title: "Your Data",
          haveBackIcon: true,
          onBackPressed: () {
            Get.back();
            authController.forgotUsernameEmailCont.clear();
          },
        ),
        body: MyFormPage(
          pageTopPadding: Get.height * .25,
          children: [
            const MyText(
              text: "Email:",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              paddingBottom: 10,
              paddingLeft: 15,
            ),
            MyTextField(
              hint: "Email",
              isReadOnly: true,
              controller: authController.forgotUsernameFoundEmailCont,
              haveSuffix: true,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.copy_rounded,
                  color: AppColors.kGreyColor,
                ),
                onPressed: () async {
                  authController.loading.value = true;
                  await authController.copyForgotEmail();
                  authController.loading.value = false;
                },
              ),
            ),

            const SizedBox(height: AppSizes.formsSizeBoxHeight),
            const MyText(
              text: "Member Id",
              // text: "Referral Code",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              paddingBottom: 10,
              paddingLeft: 15,
            ),
            MyTextField(
              hint: "Member Id",
              // hint: "Referral Code",
              isReadOnly: true,
              controller: authController.forgotUsernameFoundReferralCodeCont,
              haveSuffix: true,
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.copy_rounded,
                  color: AppColors.kGreyColor,
                ),
                onPressed: () async {
                  await authController.copyForgotReferralCode();
                },
              ),
            ),
            const SizedBox(
              height: AppSizes.formsSizeBoxHeight,
            ),

            //+ Go to login button
            MyButton(
              text: "Go to Login",
              width: Get.width - 30,
              padding: 10,
              marginBottom: 10,
              color: AppColors.kButtonRedColor,
              onPressed: () {
                Get.offAll(
                      () => LoginPage(),
                  transition: Transition.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 500),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
