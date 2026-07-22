import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/api_constants.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/formatters/date_formatter.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/checkout/components/pay_online_cards_widget.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/widgets/image_related_builders.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

import '../../../utils/formatters/us_phone_number_formatter.dart';
import '../../../utils/validators/us_phone_number_validator.dart';

class BuyMembershipFormPage extends StatelessWidget {
  const BuyMembershipFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        membershipController.clearBuyMembershipControllers();
        return true;
      },
      child: Scaffold(
        // backgroundColor: AppColors.kGreyColor,
        backgroundColor: AppColors.kSkyLightDullColor,
        appBar: simpleAppBar(
          title: "Membership Form",
          haveBackIcon: true,
          onBackPressed: () {
            membershipController.clearBuyMembershipControllers();
            Get.back();
          },
        ),
        body: Form(
          key: membershipController.buyMembershipFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SizedBox(
            height: Get.height,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                MyFormPage(
                  pageTopPadding: Get.height * 0.05,
                  showBottomPadding: false,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          height: 250,
                          width: Get.width * 0.85,
                          imageUrl: "${ApiConstants.baseUrl}/assets/front/images/membership-card.webp",
                          progressIndicatorBuilder: (context, url, progress) {
                            return MyCachedImageLoadingBuilder(height: 200, width: Get.width, loadingProgress: progress.progress ?? 0);
                          },
                          errorWidget: (context, url, error) => MyImageErrorBuilder(height: 200, width: Get.width),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
                authController.userData.value.id.isEmpty
                    ? MyFormPage(
                        pageTopPadding: Get.height * 0.05,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: MyText(
                              text: "User Info",
                              align: TextAlign.center,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              paddingTop: 0,
                              paddingBottom: 10,
                            ),
                          ),

                          const MyText(
                            text: "First Name",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            paddingLeft: 15,
                            // paddingTop: 10,
                            paddingBottom: 5,
                          ),
                          //+ full name
                          MyTextField(
                            hint: "First Name",
                            controller: membershipController.buyMembershipFirstNameController,
                            keyboardType: TextInputType.name,
                            autoFillHints: const [AutofillHints.name],
                            validator: (String? value) {
                              String val = value ?? "";

                              RegExp regex = RegExp(r"\s{2,}");
                              bool hasMultipleSpaces = regex.hasMatch(val);

                              if (val.trim().isEmpty) {
                                return "First Name is required";
                              } else if (val.trim().length != val.length || hasMultipleSpaces) {
                                return "Please remove extra space(s) from first name";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: AppSizes.formsSizeBoxHeight),
                          const MyText(
                            text: "Last Name",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            paddingLeft: 15,
                            // paddingTop: 10,
                            paddingBottom: 5,
                          ),
                          //+ last name
                          MyTextField(
                            hint: "Last Name",
                            controller: membershipController.buyMembershipLastNameController,
                            keyboardType: TextInputType.name,
                            autoFillHints: const [AutofillHints.name],
                            validator: (String? value) {
                              String val = value ?? "";

                              RegExp regex = RegExp(r"\s{2,}");
                              bool hasMultipleSpaces = regex.hasMatch(val);

                              if (val.trim().isEmpty) {
                                return "Last Name is required";
                              } else if (val.trim().length != val.length || hasMultipleSpaces) {
                                return "Please remove extra space(s) from last name";
                              }
                              return null;
                            },
                          ),

                          const MyText(
                            text: "Email Address",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            paddingLeft: 15,
                            // paddingTop: 10,
                            paddingBottom: 5,
                          ),
                          //+ email
                          MyTextField(
                            hint: "Email",
                            controller: membershipController.buyMembershipEmailController,
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
                            text: "Phone No",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            paddingLeft: 15,
                            // paddingTop: 10,
                            paddingBottom: 5,
                          ),
                          //+ phone
                          MyTextField(
                            hint: "Phone No",
                            controller: membershipController.buyMembershipPhoneNumController,
                            keyboardType: TextInputType.number,
                            autoFillHints: const [AutofillHints.telephoneNumber, AutofillHints.telephoneNumberDevice],
                            inputFormatters: [LengthLimitingTextInputFormatter(14), FilteringTextInputFormatter.digitsOnly, UsNumberTextInputFormatter()],

                            // inputFormatters: [
                            //   LengthLimitingTextInputFormatter(10),
                            //   FilteringTextInputFormatter.digitsOnly,
                            // ],
                            validator: (String? val) {
                              String value = val ?? "";
                              final usPhoneValidity = validateUsPhoneNumber(value);
                              authController.isNumValid.value = (usPhoneValidity == null);
                              return usPhoneValidity;

                              // String value = val ?? "";
                              // if (value.isEmpty == true) {
                              //   return "Phone No is required";
                              // } else if (!value.isNumericOnly) {
                              //   return 'Please enter a valid digit only phone number';
                              // }  else if (value.trim().length != 10) {
                              //   return 'Please enter your 10 digit phone number';
                              // }
                              // // else if (!GetUtils.isPhoneNumber(value?.trim() ?? "")) {
                              // //   return "Please enter a valid email address";
                              // // }
                              // return null;
                            },
                          ),
                          const SizedBox(height: AppSizes.formsSizeBoxHeight),

                          const MyText(
                            text: "Birthday (MM/DD)",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            paddingLeft: 15,
                            // paddingTop: 10,
                            paddingBottom: 5,
                          ),
                          MyTextField(
                            controller: membershipController.buyMembershipDobController,
                            hint: "Birthday (MM/DD)",
                            keyboardType: TextInputType.datetime,
                            autoFillHints: const [AutofillHints.birthdayDay],
                            inputFormatters: [DateTextFormatter(), LengthLimitingTextInputFormatter(5)],
                            textInputAction: TextInputAction.next,
                            validator: (String? value) {
                              String v = value ?? "";
                              if (v.isEmpty) {
                                return "Birthday is required";
                              } else if (!v.trim().replaceAll("/", "").isNumericOnly) {
                                return "Invalid Birthday";
                              } else if (v.trim().replaceAll("/", "").length != 4) {
                                return "Invalid - Required format is (MM/DD)";
                              } else if (!isValidDate(v.trim())) {
                                return "Invalid - Required format is (MM/DD)";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppSizes.formsSizeBoxHeight),

                          const MyText(
                            text: "Password",
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            paddingLeft: 15,
                            // paddingTop: 10,
                            paddingBottom: 5,
                          ),
                          //+ password field
                          Obx(() {
                            return MyTextField(
                              controller: membershipController.buyMembershipPasswordController,
                              hint: "Password",
                              isObSecure: !membershipController.showPassword.value,
                              keyboardType: TextInputType.visiblePassword,
                              autoFillHints: const [AutofillHints.password],
                              textInputAction: TextInputAction.next,
                              validator: (String? value) {
                                RegExp regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

                                if (value?.trim().isEmpty ?? true) {
                                  return 'Password is Required';
                                } else if (!regex.hasMatch(value ?? "")) {
                                  return 'Enter valid password containing 8 elements with at least 1 lowercase letter, 1 uppercase letter, 1 digit and 1 special character ';
                                }
                                // else if ((value?.trim().length ?? 0) < 8) {
                                //   return 'Password must have at least 8 elements including ';
                                // }
                                return null;
                              },
                            );
                          }),

                          //+ show password check box
                          SizedBox(
                            height: 35,
                            child: Obx(() {
                              return MyCheckBoxTile(
                                title: "show password",
                                value: membershipController.showPassword.value,
                                onChanged: (bool? value) {
                                  // this.value = value;
                                  log("check box value: $value");
                                  membershipController.showPassword.value = (value ?? false);
                                },
                              );
                            }),
                          ),

                          const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),

                          const MyText(text: "Member Id (of your referrer)", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 5, paddingBottom: 5),
                          //+ referral code field
                          MyTextField(
                            hint: "Member Id (of your referrer)",
                            controller: membershipController.buyMembershipReferralController,
                            keyboardType: TextInputType.streetAddress,
                            // autoFillHints: const [AutofillHints.name],
                            validator: (String? value) {
                              // if ((value?.isEmpty ?? true) == true) {
                              //   return "Referral Code is required";
                              // }
                              return null;
                            },
                          ),

                          const MyText(
                            text: "ⓘ Leave blank if you were not referred by someone!",
                            color: AppColors.kRedColor,
                            fontWeight: FontWeight.normal,
                            maxLines: 2,
                            fontSize: 14,
                            paddingTop: 5,
                            paddingLeft: 15,
                            paddingRight: 5,
                          ),

                          const SizedBox(height: AppSizes.formsSizeBoxHeight),
                        ],
                      )
                    : SizedBox(height: Get.height * 0.05),
                MyFormPage(
                  pageTopPadding: Get.height * 0.10,
                  showTopPadding: false,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Obx(() {
                        return PayOnlineCardsWidget(
                          checkBoxValue: membershipController.isPaymentStripeSelected.value,
                          onChanged: (bool? value) {
                            if (value == true) {
                              membershipController.selectedPaymentType = "stripe";
                            } else {
                              membershipController.selectedPaymentType = "";
                            }
                            membershipController.isPaymentStripeSelected.value = (value ?? false);
                          },
                        );
                      }),
                      // MyText(
                      //   text: "Pay Online",
                      //   align: TextAlign.center,
                      //   color: Colors.black,
                      //   fontWeight: FontWeight.bold,
                      //   fontSize: 20,
                      //   paddingTop: 0,
                      //   paddingBottom: 20,
                      // ),
                    ),

                    Obx(() {
                      return membershipController.isPaymentStripeSelected.value
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //+ Name on card
                                const MyText(text: "Name On Card", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                                MyTextField(
                                  hint: "Please Enter Name",
                                  disableErrorText: true,
                                  controller: membershipController.stripeNameController,
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
                                const MyText(text: "Card Number", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                                MyTextField(
                                  hint: "xxxxxxxxxxxxxxxx",
                                  disableErrorText: true,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(16),
                                    //   CardFormatter(sample: "1234 5678 1234 5678", separator: " "),
                                  ],
                                  // maxLength: 16,
                                  controller: membershipController.stripeCardController,
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
                                const MyText(text: "CVC", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                                MyTextField(
                                  hint: "ex. 311",
                                  // maxLength: 3,
                                  disableErrorText: true,
                                  controller: membershipController.stripeCVVController,
                                  inputFormatters: [LengthLimitingTextInputFormatter(4)],
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
                                const MyText(text: "Expiry Month", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                                MyTextField(
                                  hint: "MM",
                                  // maxLength: 2,
                                  disableErrorText: true,
                                  controller: membershipController.stripeExpiryMonthController,
                                  inputFormatters: [LengthLimitingTextInputFormatter(2)],
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
                                const MyText(text: "Expiry Year", fontSize: 15, fontWeight: FontWeight.bold, paddingLeft: 15, paddingTop: 10, paddingBottom: 5),
                                MyTextField(
                                  hint: "YYYY",
                                  // maxLength: 4,
                                  disableErrorText: true,
                                  controller: membershipController.stripeExpiryYearController,
                                  inputFormatters: [LengthLimitingTextInputFormatter(4)],
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

                    //+ buy membership button
                    Obx(() {
                      return MyButton(
                        height: AppSizes.buttonHeight,
                        width: Get.width * 0.90,
                        text: "Buy \$${membershipController.selectedMembershipCategory.price} Card",
                        color: apiController.isBuyingMembershipAsStranger.value || apiController.isBuyingMembershipAsMember.value
                            ? AppColors.kGreenColor
                            : AppColors.kRedColor,
                        onPressed: () {
                          if (membershipController.isPaymentStripeSelected.value &&
                              !apiController.isBuyingMembershipAsMember.value &&
                              !apiController.isBuyingMembershipAsStranger.value) {
                            membershipController.buyMembership();
                          } else if (!membershipController.isPaymentStripeSelected.value) {
                            showMsg(msg: "Please select a payment method and enter payment details.");
                          }
                        },
                      );
                    }),

                    // const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
