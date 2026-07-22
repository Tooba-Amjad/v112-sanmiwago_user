import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:sanmiwago_user/views/pages/cart/cart_page.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/pages/login/forgot_password_dialog.dart';
import 'package:sanmiwago_user/views/pages/login/forgot_username_page.dart';
import 'package:sanmiwago_user/views/pages/restaurants_list/restaurants_list_page.dart';
import 'package:sanmiwago_user/views/pages/signup/signup_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class LoginPage extends StatelessWidget {
  final bool isFromSplash;
  final bool isFromCart;
  final bool showGuestButton;
  final bool allowBackIcon;

  const LoginPage({
    super.key,
    this.isFromSplash = false,
    this.isFromCart = false,
    this.showGuestButton = true,
    this.allowBackIcon = false,
  });

  // final emailFocusNode = FocusNode();
  // final passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: WillPopScope(
        onWillPop: () async {
          authController.emailController.clear();
          authController.passwordController.clear();
          if (allowBackIcon) {
            return true;
          }
          return false;
        },
        child: Scaffold(
          // backgroundColor: AppColors.kGreyColor,
          backgroundColor: AppColors.kSkyLightDullColor,
          appBar: simpleAppBar(
            title: "Login",
            haveBackIcon: allowBackIcon,
            onBackPressed: () {
              Get.back();
              authController.emailController.clear();
              authController.passwordController.clear();
            },
          ),
          body: Form(
            key: authController.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: MyFormPage(
              pageTopPadding: Get.height * 0.10,
              children: [
                const SizedBox(height: AppSizes.formsSizeBoxHeight),
                MyTextField(
                  // focusNode: emailFocusNode,
                  hint: "Email Or Phone",
                  // hint: "Email Or Referral Code",
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  autoFillHints: const [AutofillHints.email, AutofillHints.username],
                  validator: (String? value) {
                    if (value?.isEmpty == true) {
                      return "Email or Member Id is required";
                    }
                    // else if (!GetUtils.isEmail(value?.trim() ?? "")) {
                    //   return "Please enter a valid email address";
                    // }
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

                Obx(() {
                  return MyTextField(
                    // focusNode: passwordFocusNode,
                    controller: authController.passwordController,
                    hint: "Password",
                    isObSecure: !authController.showPassword.value,
                    keyboardType: TextInputType.visiblePassword,
                    autoFillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    // onFieldSubmitted: (val) => TextInput.finishAutofillContext(),
                    validator: (String? value) {
                      if (value?.trim().isEmpty == true) {
                        return 'Password is Required';
                      } else if ((value?.trim().length ?? 0) < 6) {
                        return 'Password must have at least 6 elements';
                      }

                      return null;
                    },
                  );
                }),

                //+ show password check box
                Obx(() {
                  return MyCheckBoxTile(
                    title: "show password",
                    value: authController.showPassword.value,
                    onChanged: (bool? value) {
                      // this.value = value;
                      log("check box value: $value");
                      authController.showPassword.value = (value ?? false);
                    },
                  );
                }),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),

                GestureDetector(
                  onTap: () {
                    navigate(type: PageType.to, page: const ForgotUsernamePage());
                  },
                  child: const MyText(
                    text: "Forgot Username",
                    fontSize: 16,
                    color: AppColors.kGreyColor,
                    fontWeight: FontWeight.w400,
                    paddingLeft: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),

                //+ Login button
                Obx(() {
                  return MyButton(
                    text: "Login",
                    width: Get.width - 30,
                    padding: 10,
                    marginBottom: 10,
                    color: authController.loading.value ? AppColors.kButtonGreenColor : AppColors.kButtonRedColor,
                    onPressed: () {
                      hideKeyboard(context);
                      authController.loading.value = true;
                      authController.login(isFromCart: isFromCart, isFromSplash: isFromSplash);
                      // Future.delayed(const Duration(seconds: 1), () {
                      //   authController.loading.value = false;
                      // });
                    },
                  );
                }),

                //+ signup and Forgot row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        authController.showPassword.value = false;
                        authController.emailController.clear();
                        authController.passwordController.clear();
                        navigate(type: PageType.offAll, page: SignupPage(allowBack: true, isFromSplash: isFromSplash));
                      },
                      child: const MyText(
                        text: "Sign up",
                        fontSize: 16,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.w400,
                        paddingLeft: 18,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showMyAnimatedDialog(
                          context: context,
                          child: const ForgotPasswordDialog(),
                        );
                        /* */
                        // showDialog(
                        //   context: context,
                        //   builder: (_) => const ForgotPasswordDialog(),
                        // );
                        /* */
                        // Get.dialog(
                        //   const ForgotPasswordDialog(),
                        // );
                      },
                      child: const MyText(
                        text: "Forgot password?",
                        fontSize: 16,
                        color: AppColors.kGreyColor,
                        fontWeight: FontWeight.w400,
                        paddingRight: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSizes.formsSizeBoxHeight),

                showGuestButton
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MyText(
                            text: "Or",
                            align: TextAlign.center,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ],
                      )
                    : const SizedBox(),

                showGuestButton
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width * .70,
                            child: MyButton(
                              text: "Continue as a Guest",
                              height: AppSizes.buttonHeight,
                              padding: 10,
                              marginBottom: 30,
                              color: AppColors.kSkyLightColor,
                              textColor: AppColors.kBlackColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              onPressed: () {
                                authController.isContinuedAsGuest = true.obs;
                                authController.showPassword.value = false;
                                authController.emailController.clear();
                                authController.passwordController.clear();
                                if (isFromCart) {
                                  navigate(type: PageType.off, page: const CartPage());
                                } else if (isFromSplash) {
                                  navigate(type: PageType.off, page: const RestaurantsListPage(isFromSplash: true));
                                } else {
                                  navigate(type: PageType.offAll, page: const BottomNavBarPage());
                                  // navigate(type: PageType.offAll, page: const HomeMenuPage());
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
