import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/constants/my_logger.dart';
import 'package:sanmiwago_user/views/widgets/my_button_old.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';


class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        authController.forgotPasswordEmailController.clear();
        authController.isForgotDisabled.value = true;
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: simpleAppBar(
          title: "Forgot password",
          haveBackIcon: true,
          onBackPressed: () {
            Get.back();
            authController.forgotPasswordEmailController.clear();
            authController.isForgotDisabled.value = true;
          },
        ),
        body: Form(
          key: authController.forgotPasswordFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    SizedBox(height: Get.height * 0.28),
                    const MyText(
                      text: "Please enter your email address below to receive password reset instructions",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      paddingLeft: 18,
                    ),
                    const SizedBox(height: AppSizes.formsSizeBoxHeight),
                    MyTextField(
                      hint: "Email Address",
                      controller: authController.forgotPasswordEmailController,
                      validator: (String? value) {
                        if (value?.isEmpty == true) {
                          return "Email is required";
                        } else if (!GetUtils.isEmail(value?.trim() ?? "")) {
                          return "Please enter a valid email address";
                        } else {
                          authController.isForgotDisabled.value = false;
                          errorLog("isForgotDisabled value changed");
                        }
                        return null;
                      },
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: Get.height * 0.31),
                    Obx(() {
                      return MyButtonOld(
                        btnColor: authController.isForgotDisabled.value ? Colors.orange[200] : Colors.orange,
                        title: "Reset Password",
                        // onTap: authController.isForgotDisabled.value ? () {} : () => authController.forgotPassword(),
                      );
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
