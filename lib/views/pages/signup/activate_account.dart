import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

import '../../../utils/enums.dart';
import '../../../utils/helpers.dart';
import '../../widgets/my_button.dart';

class ActivateAccountPage extends StatelessWidget {
  final bool allowBack;

  const ActivateAccountPage({super.key, this.allowBack = true});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        authController.activateEmailController.clear();
        if (!allowBack) {
          navigate(type: PageType.offAll, page: const LoginPage());
          return false;
        }
        return true;
      },
      child: Scaffold(
        // backgroundColor: AppColors.kGreyColor,
        backgroundColor: AppColors.kSkyLightDullColor,
        appBar: simpleAppBar(
          title: "Activate account",
          haveBackIcon: allowBack,
          onBackPressed: () {
            Get.back();
            authController.activateEmailController.clear();
          },
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: MyButton(
                  text: "Go To Login",
                  icon: Icons.arrow_back_ios_rounded,
                  padding: 0,
                  marginBottom: 10,
                  color: AppColors.kRedColor,
                  onPressed: () {
                    authController.isActivationLinkSent.value = false;
                    authController.activationLinkEmail.value = "";
                    authController.activateEmailController.clear();

                    navigate(type: PageType.offAll, page: const LoginPage());
                  },
                ),
              ),
            ),
          ],
        ),
        body: Form(
          key: authController.activateFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Obx(() {
            return MyFormPage(
              pageTopPadding: authController.isActivationLinkSent.value ? Get.height * .10 : Get.height * .20,
              children: [
                authController.isActivationLinkSent.value
                    ? Container(
                        width: Get.width,
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(AppSizes.buttonBorderRadius),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    authController.isActivationLinkSent.value = false;
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(top: 10, right: 10),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                              child: RichText(
                                maxLines: 10,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Success! ",
                                  style: TextStyle(
                                    color: Colors.green[800],
                                    fontWeight: FontWeight.w700,
                                    fontSize: 28,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "An activation link has been sent to ",
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.normal,
                                        fontSize: 28,
                                      ),
                                    ),
                                    TextSpan(
                                      text: authController.activationLinkEmail.value,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.green[800],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 28,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ". Please check your inbox or spam.",
                                      style: TextStyle(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.normal,
                                        fontSize: 28,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // MyText(
                            //   color: Colors.green[700],
                            //   fontSize: 22,
                            //   fontWeight: FontWeight.w600,
                            //   maxLines: 3,
                            //   text: "An activation link has been sent to ${authController.activationLinkEmail} waqadarshad25566667777777777@gmail.com.",
                            //   align: TextAlign.center,
                            //   // paddingTop: 10,
                            //   paddingBottom: 10,
                            //   paddingLeft: 10,
                            //   paddingRight: 10,
                            // ),
                          ],
                        ),
                      )
                    : const SizedBox(),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),
                //+ email
                MyTextField(
                  hint: "Email Or Member Id",
                  // hint: "Email Or Referral Code",
                  controller: authController.activateEmailController,
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
                const MyText(
                  text: "ⓘ  If activation email is not received, click the below button to resend the link.",
                  color: Colors.red,
                  fontSize: 16,
                  paddingLeft: 15,
                  paddingRight: 15,
                  // paddingBottom: 5,
                ),
                //+ Send Link button
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: MaterialButton(
                      color: apiController.isResendingActivationEmail.value == true ? AppColors.kGreenColor : AppColors.kRedColor,
                      height: 52,
                      minWidth: Get.width - 30,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      onPressed: () {
                        apiController.resendActivationEmail();
                      },
                      child: const MyText(
                        text: "Resend Link",
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  );
                }),
              ],
            );
          }),
        ),
      ),
    );
  }
}
