import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';

class CheckGiftCardBalanceForm extends StatelessWidget {
  const CheckGiftCardBalanceForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: giftCardController.checkBalanceFormKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: MyFormPage(
        pageTopPadding: Get.height * 0.12,
        children: [
          const Align(
            alignment: Alignment.center,
            child: MyText(
              text: "Enter your gift card number to check your balance",
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
            text: "Gift Card No.",
            fontSize: 15,
            fontWeight: FontWeight.bold,
            paddingLeft: 15,
            paddingTop: 10,
            paddingBottom: 5,
          ),
          MyTextField(
            hint: "Enter Gift Card (16)",
            // maxLength: 16,
            controller: giftCardController.checkBalanceGiftCardController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              LengthLimitingTextInputFormatter(16),
            ],
            validator: (String? value) {
              if (value?.isEmpty == true) {
                return "GiftCard No. is required";
              } else if (!(value?.trim().isNumericOnly ?? false) || ((value?.trim() ?? "").length < 16)) {
                return "Invalid GiftCard No.";
              }
              return null;
            },
          ),

          //+ Gift Card Pin
          const MyText(
            text: "Pin",
            fontSize: 15,
            fontWeight: FontWeight.bold,
            paddingLeft: 15,
            paddingTop: 10,
            paddingBottom: 5,
          ),
          MyTextField(
            hint: "Enter Pin Code (4)",
            // maxLength: 4,
            isObSecure: true,
            controller: giftCardController.checkBalanceGiftPinController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              LengthLimitingTextInputFormatter(4),
            ],
            validator: (String? value) {
              if (value?.isEmpty == true) {
                return "GiftCard Pin is required";
              } else if (!(value?.trim().isNumericOnly ?? false) || ((value?.trim() ?? "").length < 4)) {
                return "Invalid GiftCard Pin";
              }
              return null;
            },
          ),

          const SizedBox(height: AppSizes.formsSizeBoxHeight),

          //+ Check Balance button
          Align(
            alignment: Alignment.center,
            child: Obx(() {
              return MyButton(
                height: AppSizes.buttonHeight,
                width: Get.width * 0.90,
                text: "Check Balance",
                color: apiController.isCheckingGiftCardBalance.value ? AppColors.kGreenColor : AppColors.kRedColor,
                onPressed: () {
                  hideKeyboard(context);
                  giftCardController.checkGiftCardBalance();
                },
              );
            }),
          ),
          const SizedBox(height: AppSizes.formsSizeBoxHeight),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Forgot your Giftcard Balance?",
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                    children: [
                      TextSpan(
                        text: "\nRecover Now",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            /* + navigate to recover page + */
                            giftCardController.selectMenu(giftCardController.menus[3]);
                          },
                        // align: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.formsSizeBoxHeight),
        ],
      ),
    );
  }
}
