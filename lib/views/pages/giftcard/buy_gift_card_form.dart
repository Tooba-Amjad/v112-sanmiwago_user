import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_dropdown_text_field.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';

import '../../../utils/formatters/us_phone_number_formatter.dart';
import '../../../utils/validators/us_phone_number_validator.dart';

class BuyGiftCardForm extends StatelessWidget {
  const BuyGiftCardForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => hideKeyboard(context),
      child: Form(
        key: giftCardController.buyGiftCardFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: MyFormPage(
          pageTopPadding: Get.height * 0.05,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  height: 250,
                  width: Get.width,
                  imageUrl: giftCardController.selectedCardImage,
                  progressIndicatorBuilder: (context, url, progress) {
                    return MyCachedImageLoadingBuilder(
                      height: 200,
                      width: Get.width,
                      loadingProgress: progress.progress ?? 0,
                    );
                  },
                  errorWidget: (context, url, error) => MyImageErrorBuilder(
                    height: 200,
                    width: Get.width,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            //+ Gift Card Amount Dropdown
            const MyText(
              text: "E-Gift Card Amount",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              paddingLeft: 15,
              paddingTop: 15,
              paddingBottom: 5,
            ),
            //+ Amounts Dropdown
            MyDropDownTextField(
              isForEdit: true,
              listItem: giftCardController.amounts,
              hintText: "Select Amount",
              onChange: (value) {
                infoLog("selected gift card amount: $value");
                giftCardController.buySelectedAmount = value ?? "";
              },
              validator: (value) {
                if (giftCardController.buySelectedAmount.isEmpty) {
                  return "Please select a value";
                }
                return null;
              },
            ),

            Obx(() {
              return MyCheckBoxTile(
                value: giftCardController.sendToMyself.value,
                title: "I want to send this to myself",
                onChanged: (value) {
                  giftCardController.sendToMyself.value = value ?? false;
                },
              );
            }),

            //+ From.
            const MyText(
              text: "From",
              fontSize: 15,
              fontWeight: FontWeight.bold,
              paddingLeft: 15,
              paddingTop: 10,
              paddingBottom: 10,
            ),

            //+ sender name
            MyTextField(
              hint: "Sender Name",
              controller: giftCardController.buyGiftCardSenderNameController,
              keyboardType: TextInputType.name,
              autoFillHints: const [AutofillHints.name],
              validator: (String? value) {
                if ((value?.isEmpty ?? true) == true) {
                  return "Sender Name is required";
                }
                return null;
              },
            ),

            const SizedBox(height: 10),

            //+ sender email
            MyTextField(
              hint: "Sender Email",
              // maxLength: 16,
              controller: giftCardController.buyGiftCardSenderEmailController,
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

            const SizedBox(height: 10),

            //+ sender phone
            MyTextField(
              hint: "Sender Phone",
              controller: giftCardController.buyGiftCardSenderPhoneController,
              keyboardType: TextInputType.number,
              autoFillHints: const [
                AutofillHints.telephoneNumber,
                AutofillHints.telephoneNumberDevice,
              ],
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
            const SizedBox(height: 10),

            //+ To
            Obx(() {
              return !giftCardController.sendToMyself.value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MyText(
                          text: "To",
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          paddingLeft: 15,
                          paddingTop: 10,
                          paddingBottom: 10,
                        ),

                        //+ To name
                        MyTextField(
                          hint: "Recipient Name",
                          controller: giftCardController.buyGiftCardRecipientNameController,
                          keyboardType: TextInputType.name,
                          autoFillHints: const [AutofillHints.name],
                          validator: (String? value) {
                            if ((value?.isEmpty ?? true) == true) {
                              return "Recipient Name is required";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        //+ To email
                        MyTextField(
                          hint: "Recipient Email",
                          // maxLength: 16,
                          controller: giftCardController.buyGiftCardRecipientEmailController,
                          keyboardType: TextInputType.emailAddress,
                          autoFillHints: const [AutofillHints.email],
                          validator: (String? value) {
                            if (value?.isEmpty == true) {
                              return "Recipient Email is required";
                            } else if (!GetUtils.isEmail(value?.trim() ?? "")) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 10),

                        //+ to phone
                        MyTextField(
                          hint: "Recipient Phone",
                          controller: giftCardController.buyGiftCardRecipientPhoneController,
                          keyboardType: TextInputType.number,
                          autoFillHints: const [
                            AutofillHints.telephoneNumber,
                            AutofillHints.telephoneNumberDevice,
                          ],
                          inputFormatters: [LengthLimitingTextInputFormatter(14), FilteringTextInputFormatter.digitsOnly, UsNumberTextInputFormatter()],
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

                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox();
            }),

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

            //+ stripe section
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
                          // maxLength: 4,
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
                            } else if (!(value?.trim().isNumericOnly ?? false)) {
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

            //+ buy gift-card button
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                return MyButton(
                  height: AppSizes.buttonHeight,
                  width: Get.width * 0.90,
                  text: "Submit",
                  color: apiController.isBuyingGiftCard.value ? AppColors.kGreenColor : AppColors.kRedColor,
                  onPressed: () {
                    hideKeyboard(context);
                    if (apiController.isBuyingGiftCard.value) return; // Already buying, prevent double click

                    final formValid = giftCardController.buyGiftCardFormKey.currentState?.validate() ?? false;
                    final amountSelected = giftCardController.buySelectedAmount.isNotEmpty && giftCardController.buySelectedAmount != "0";
                    final paymentSelected = giftCardController.isPaymentStripeSelected.value;

                    if (!amountSelected) {
                      showMsg(msg: "Please select a gift card amount.");
                      return;
                    }

                    if (!paymentSelected) {
                      showMsg(msg: "Please select a payment method and enter payment details.");
                      return;
                    }

                    // Special Case: If not sending to myself, validate recipient fields
                    if (!giftCardController.sendToMyself.value) {
                      if (giftCardController.buyGiftCardRecipientNameController.text.trim().isEmpty) {
                        showMsg(msg: "Recipient name is required.");
                        return;
                      }
                      if (giftCardController.buyGiftCardRecipientEmailController.text.trim().isEmpty) {
                        showMsg(msg: "Recipient email is required.");
                        return;
                      }
                      if (!GetUtils.isEmail(giftCardController.buyGiftCardRecipientEmailController.text.trim())) {
                        showMsg(msg: "Please enter a valid recipient email address.");
                        return;
                      }
                      /* ! covered with the next if already ! */
                      // if (giftCardController.buyGiftCardRecipientPhoneController.text.trim().isEmpty) {
                      //   showMsg(msg: "Recipient phone number is required.");
                      //   return;
                      // }
                      // if (!giftCardController.buyGiftCardRecipientPhoneController.text.trim().isNumericOnly ||
                      //     giftCardController.buyGiftCardRecipientPhoneController.text.trim().length != 10) {
                      var recipientPhoneValidity = validateUsPhoneNumber(giftCardController.buyGiftCardRecipientPhoneController.text);
                      if (recipientPhoneValidity != null) {
                        showMsg(msg: recipientPhoneValidity ?? "Please enter a valid 10-digit recipient phone number.");
                        return;
                      }
                    }

                    // If Stripe selected, manually validate Stripe fields
                    if (paymentSelected) {
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
                      giftCardController.buyGiftCard();
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
