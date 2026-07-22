import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/constants/my_logger.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/checkout/components/pay_online_cards_widget.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_dropdown_text_field.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';

class ReloadGiftCardForm extends StatelessWidget {
  const ReloadGiftCardForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Form(
        key: giftCardController.reloadGiftCardFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: MyFormPage(
          pageTopPadding: Get.height * 0.05,
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: MyText(
                text: "Add money to your GiftCard",
                align: TextAlign.center,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                paddingTop: 20,
                paddingBottom: 0,
                paddingLeft: 15,
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
              controller: giftCardController.reloadGiftCardController,
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
              controller: giftCardController.reloadGiftPinController,
              keyboardType: TextInputType.number,
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

            //+ Gift Card Amount Dropdown
            const MyText(
              text: "E-Gift Card Amount",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              paddingLeft: 15,
              paddingTop: 10,
              paddingBottom: 5,
            ),
            //+ Amounts Dropdown
            MyDropDownTextField(
              isForEdit: true,
              listItem: giftCardController.amounts,
              hintText: "Select Amount",
              onChange: (value) {
                infoLog("selected gift card amount: $value");
                giftCardController.reloadSelectedAmount = value ?? "";
              },
              validator: (value) {
                if (giftCardController.reloadSelectedAmount.isEmpty) {
                  return "Please select a value";
                }
                return null;
              },
            ),

            //+ ---------------------- PAY USING PART ----------------------

            Align(
              alignment: Alignment.centerLeft,
              child: Obx(() {
                return PayOnlineCardsWidget(
                  checkBoxValue: giftCardController.isPaymentStripeSelected.value,
                  onChanged: (bool? value) {
                    if (value == true) {
                      giftCardController.selectedPaymentType = "stripe";
                    } else {
                      giftCardController.selectedPaymentType = "";
                    }
                    giftCardController.isPaymentStripeSelected.value = (value ?? false);
                  },
                );
              }),
              // MyText(
              //   text: "Pay Online",
              //   align: TextAlign.center,
              //   color: Colors.black,
              //   fontWeight: FontWeight.bold,
              //   fontSize: 20,
              //   paddingTop: 20,
              //   paddingBottom: 0,
              //   paddingLeft: 15,
              // ),
            ),

            Obx(() {
              return giftCardController.isPaymentStripeSelected.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                          disableErrorText: true,
                          controller: giftCardController.stripeNameController,
                          keyboardType: TextInputType.name,
                          autoFillHints: const [
                            AutofillHints.creditCardName,
                            AutofillHints.creditCardGivenName,
                            AutofillHints.creditCardFamilyName,
                            AutofillHints.creditCardMiddleName,
                          ],
                          validator: (String? value) {
                            if (value?.isEmpty == true) {
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
                          disableErrorText: true,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //   CardFormatter(sample: "1234 5678 1234 5678", separator: " "),
                          ],
                          // maxLength: 16,
                          controller: giftCardController.stripeCardController,
                          autoFillHints: const [AutofillHints.creditCardNumber],
                          keyboardType: TextInputType.number,
                          validator: (String? value) {
                            if (value?.isEmpty == true) {
                              return "Card Number is required";
                            } else if ((value?.trim().length ?? 0) != 15 && (value?.trim().length ?? 0) != 16) {
                              return "Invalid Card Number";
                            } else if (!(value?.trim().isNumericOnly ?? false)) {
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
                          disableErrorText: true,
                          controller: giftCardController.stripeCVVController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                          ],
                          autoFillHints: const [AutofillHints.creditCardSecurityCode],
                          keyboardType: TextInputType.number,
                          validator: (String? value) {
                            if (value?.isEmpty == true) {
                              return "CVC is required";
                            } else if ((value?.trim().length ?? 0) != 3 && (value?.trim().length ?? 0) != 4) {
                              return "Enter a 3/4 digit CVC/CVV";
                            } else if (!(value?.trim().isNumericOnly ?? false)) {
                              return "Invalid CVC Number";
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
                          disableErrorText: true,
                          controller: giftCardController.stripeExpiryMonthController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2),
                          ],
                          autoFillHints: const [AutofillHints.creditCardExpirationMonth],
                          keyboardType: TextInputType.number,
                          validator: (String? value) {
                            if (value?.isEmpty == true) {
                              return "Month is required";
                            } else if (!(value?.trim().isNumericOnly ?? false) || (int.tryParse(value?.trim() ?? "99") ?? 99) > 12) {
                              return "Invalid Month Number";
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
                          disableErrorText: true,
                          controller: giftCardController.stripeExpiryYearController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(4),
                          ],
                          autoFillHints: const [AutofillHints.creditCardExpirationYear],
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (val) => TextInput.finishAutofillContext(),
                          validator: (String? value) {
                            if (value?.isEmpty == true) {
                              return "Year is required";
                            } else if ((value?.trim().length ?? 0) != 4) {
                              return "Enter a 4 digit year";
                            } else if (!(value?.trim().isNumericOnly ?? false) || ((value?.trim() ?? "").length < 4)) {
                              return "Invalid Year";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: AppSizes.formsSizeBoxHeight),
                      ],
                    )
                  : const SizedBox();
            }),

            // const SizedBox(height: AppSizes.formsSizeBoxHeight),

            //+ reload gift-card button
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                return MyButton(
                  height: AppSizes.buttonHeight,
                  width: Get.width * 0.90,
                  text: "Submit",
                  color: apiController.isReloadingGiftCard.value ? AppColors.kGreenColor : AppColors.kRedColor,
                  onPressed: () {
                    hideKeyboard(context);
                    if (apiController.isReloadingGiftCard.value) return; // If already submitting, don't allow

                    final formValid = giftCardController.reloadGiftCardFormKey.currentState?.validate() ?? false;
                    final amountSelected = giftCardController.reloadSelectedAmount.isNotEmpty && giftCardController.reloadSelectedAmount != "0";

                    log("amountSelected: $amountSelected");
                    log("giftCardController.reloadSelectedAmount: ${giftCardController.reloadSelectedAmount}");
                    if (!amountSelected) {
                      showMsg(msg: "Please select an amount.");
                      return;
                    }

                    if (!giftCardController.isPaymentStripeSelected.value) {
                      showMsg(msg: "Please select a payment method and enter payment details.");
                      return;
                    }

                    // If Stripe is selected, validate Stripe-specific fields
                    if (giftCardController.isPaymentStripeSelected.value) {
                      if (giftCardController.stripeNameController.text.trim().isEmpty) {
                        showMsg(msg: "Name on card is required.");
                        return;
                      }
                      if (giftCardController.stripeCardController.text.trim().isEmpty) {
                        showMsg(msg: "Card number is required.");
                        return;
                      }
                      if (giftCardController.stripeCVVController.text.trim().isEmpty) {
                        showMsg(msg: "CVC is required.");
                        return;
                      }
                      if (giftCardController.stripeExpiryMonthController.text.trim().isEmpty) {
                        showMsg(msg: "Expiry month is required.");
                        return;
                      }
                      if (giftCardController.stripeExpiryYearController.text.trim().isEmpty) {
                        showMsg(msg: "Expiry year is required.");
                        return;
                      }
                    }

                    if (formValid) {
                      giftCardController.reloadGiftCard();
                    } else {
                      showMsg(msg: "Please complete all required fields properly.");
                    }
                  },
                );
              }),
            ),
            const SizedBox(height: AppSizes.formsSizeBoxHeight),
          ],
        ),
      ),
    );
  }
}
