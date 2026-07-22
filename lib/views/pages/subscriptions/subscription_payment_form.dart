import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/checkout/components/checkout_page_container.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class SubscriptionPaymentForm extends StatelessWidget {
  const SubscriptionPaymentForm({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (canPop) {
        Future.delayed(Duration(milliseconds: 500), () {
          subscriptionsController.clearAll();
        });
      },
      child: Scaffold(
        appBar: simpleAppBar(
          title: "Subscription Payment",
          haveBackIcon: true,
          onBackPressed: () {
            Get.back();
            Future.delayed(Duration(milliseconds: 500), () {
              subscriptionsController.clearAll();
            });
          },
        ),
        body: MyFormPage(
          pageTopPadding: Get.height * 0.03,
          pageBottomPadding: Get.height * 0.07,
          showBottomPadding: true,
          children: [
            CheckoutPageContainer(
              isForm: true,
              formKey: subscriptionsController.stripeFormKey,
              // height: 550,
              headerNumber: "",
              headerText: "Please provide card info",
              children: [
                //+ Name on card

                const MyText(
                  text: "Name On Card",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  paddingLeft: 15,
                  paddingTop: 10,
                  paddingBottom: 5,
                ),
                MyTextField(
                  hint: "Please Enter Name",
                  // disableErrorText: true,
                  controller: subscriptionsController.stripeNameController,
                  keyboardType: TextInputType.name,
                  autoFillHints: const [
                    AutofillHints.creditCardName,
                    AutofillHints.creditCardGivenName,
                    AutofillHints.creditCardFamilyName,
                    AutofillHints.creditCardMiddleName,
                  ],
                  validator: (String? val) {
                    String value = val ?? "";
                    if (value.isEmpty == true) {
                      return "Name is required";
                    }
                    return null;
                  },
                ),

                //+ Credit Card No.
                const MyText(
                  text: "Card Number",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  paddingLeft: 15,
                  paddingTop: 10,
                  paddingBottom: 5,
                ),
                MyTextField(
                  hint: "xxxxxxxxxxxxxxxx",
                  // disableErrorText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(16),
                    //   CardFormatter(sample: "1234 5678 1234 5678", separator: " "),
                  ],
                  // maxLength: 16,
                  controller: subscriptionsController.stripeCardController,
                  autoFillHints: const [AutofillHints.creditCardNumber],
                  keyboardType: TextInputType.number,
                  validator: (String? val) {
                    String value = val ?? "";
                    if (value.isEmpty == true) {
                      return "Card Number is required";
                    } else if (value.trim().length != 15 && value.trim().length != 16) {
                      return "Invalid Card Number";
                    } else if (!value.replaceAll(" ", "").isNumericOnly) {
                      return "Invalid Card Number";
                    }
                    return null;
                  },
                ),

                //+ CVC
                const MyText(
                  text: "CVC",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  paddingLeft: 15,
                  paddingTop: 10,
                  paddingBottom: 5,
                ),
                MyTextField(
                  hint: "ex. 311",
                  // maxLength: 3,
                  // disableErrorText: true,
                  controller: subscriptionsController.stripeCVVController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  autoFillHints: const [AutofillHints.creditCardSecurityCode],
                  keyboardType: TextInputType.number,
                  validator: (String? val) {
                    String value = val ?? "";
                    if (value.isEmpty == true) {
                      return "CVC is required";
                    } else if (value.trim().length != 3 && value.trim().length != 4) {
                      return "Enter a 3/4 digit CVC/CVV";
                    } else if (!value.trim().isNumericOnly) {
                      return "Invalid CVC/CVV Number";
                    }
                    return null;
                  },
                ),

                //+ Expiry month
                const MyText(
                  text: "Expiry Month",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  paddingLeft: 15,
                  paddingTop: 10,
                  paddingBottom: 5,
                ),
                MyTextField(
                  hint: "MM",
                  // maxLength: 2,
                  // disableErrorText: true,
                  controller: subscriptionsController.stripeExpiryMonthController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(2),
                  ],
                  autoFillHints: const [AutofillHints.creditCardExpirationMonth],
                  keyboardType: TextInputType.number,
                  validator: (String? val) {
                    String value = val ?? "";
                    if (value.isEmpty == true) {
                      return "Month is required";
                    } else if (!value.trim().isNumericOnly || (int.tryParse(value.trim()) ?? 99) > 12) {
                      return "Invalid Month Number";
                    } else if (subscriptionsController.stripeExpiryYearController.text.trim().isNotEmpty &&
                        subscriptionsController.stripeExpiryYearController.text.trim().length == 4 &&
                        !isValidExpiry(int.tryParse(value) ?? 0, int.tryParse(subscriptionsController.stripeExpiryYearController.text.trim()) ?? 0)) {
                      return "Invalid Expiry Month and Year - Cannot be in past";
                    }
                    return null;
                  },
                ),

                //+ Expiry year
                const MyText(
                  text: "Expiry Year",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  paddingLeft: 15,
                  paddingTop: 10,
                  paddingBottom: 5,
                ),
                MyTextField(
                  hint: "YYYY",
                  // maxLength: 4,
                  // disableErrorText: true,
                  controller: subscriptionsController.stripeExpiryYearController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4),
                  ],
                  autoFillHints: const [AutofillHints.creditCardExpirationYear],
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  // onFieldSubmitted: (val) => TextInput.finishAutofillContext(),
                  validator: (String? val) {
                    String value = val ?? "";
                    if (value.isEmpty == true) {
                      return "Year is required";
                    } else if (value.trim().length != 4) {
                      return "Enter a 4 digit year";
                    } else if (!value.trim().isNumericOnly) {
                      return "Invalid Year";
                    } else if (!isValidExpiry(int.tryParse(subscriptionsController.stripeExpiryMonthController.text.trim()) ?? 0, int.tryParse(value) ?? 0)) {
                      return "Invalid Expiry Month and Year - Cannot be in past";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
            CheckoutPageContainer(
              // height: 180,
              headerNumber: "",
              headerText: "Total",
              children: [
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const MyText(
                        text: 'Total:',
                        color: AppColors.kGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      MyText(
                        text: '\$${subscriptionsController.selectedOfferAmount}',
                        color: AppColors.kGreyColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
              child: Center(
                child: Obx(() {
                  return MyButton(
                    height: AppSizes.buttonHeight,
                    text: "Pay \$${subscriptionsController.selectedOfferAmount}",
                    fontSize: 20,
                    color: apiController.isCreatingSubscription.value ? AppColors.kRedColor : AppColors.kGreenColor,
                    onPressed: () {
                      if (subscriptionsController.stripeFormKey.currentState?.validate() ?? false) {
                        if (!apiController.isCreatingSubscription.value) {
                          subscriptionsController.createSubscription();
                        } else {
                          // log("form not validated");
                          showMsg(msg: "Please enter valid card info");
                        }
                      }
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
