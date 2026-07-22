import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/custom_scroll_behavior.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/privacy_policy.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/terms_of_use.dart';
import 'package:sanmiwago_user/views/widgets/my_button.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

import '../../../utils/formatters/us_phone_number_formatter.dart';
import '../../../utils/validators/us_phone_number_validator.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController firstNameCon = TextEditingController();
  final TextEditingController lastNameCon = TextEditingController();
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController accountEmailCon = TextEditingController();
  final TextEditingController phoneCon = TextEditingController();
  final TextEditingController messageCon = TextEditingController();

  final GlobalKey<FormState> contactFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    firstNameCon.dispose();
    lastNameCon.dispose();
    emailCon.dispose();
    accountEmailCon.dispose();
    phoneCon.dispose();
    messageCon.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (authController.isLoggedIn.value) {
      firstNameCon.text = authController.userData.value.firstName;
      lastNameCon.text = authController.userData.value.lastName;
      emailCon.text = authController.userData.value.email;
      accountEmailCon.text = authController.userData.value.email;
      phoneCon.text = formatUsPhoneNumber(authController.userData.value.phone) ?? authController.userData.value.phone;
      WidgetsBinding.instance.addPostFrameCallback((time) {
        showMsg(
          msg:
              "Some fields were filled with "
              "your profile data for your ease. "
              "You can edit them if you want.",
          isSuccess: true,
          time: const Duration(seconds: 3),
        );
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kSkyLightDullColor,
      appBar: simpleAppBar(
        title: "Get in touch!",
        haveBackIcon: true,
        onBackPressed: () {
          Get.back();
        },
      ),
      body: GestureDetector(
        onTap: () => hideKeyboard(context),
        child: Form(
          key: contactFormKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    children: [
                      // MyText(
                      //   text: "Having any questions/queries? You may contact us at sanmiwago298@gmail.com",
                      //   fontWeight: FontWeight.normal,
                      //   fontSize: 14,
                      //   paddingLeft: 20,
                      //   paddingRight: 20,
                      //   paddingTop: 20,
                      //   paddingBottom: 5,
                      //   align: TextAlign.center,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5, top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: RichText(
                                maxLines: 10,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Have questions? You can reach us at ",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16, fontFamily: GoogleFonts.poppins().fontFamily),
                                  children: [
                                    TextSpan(
                                      text: "sanmiwago298@gmail.com",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          try {
                                            launchUrlExternal("mailto:sanmiwago298@gmail.com?subject=General%20Query&body=Hi%20Sanmiwago,");
                                          } catch (e) {
                                            showMsg(msg: "Could not launch mailing app. You may try again or use this e-mail directly in your mailing app.");
                                            log("error in launching mailing app");
                                          }
                                        },
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.underline,
                                        fontSize: 16,
                                        fontFamily: GoogleFonts.poppins().fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // MyText(
                      //   text: "OR",
                      //   fontWeight: FontWeight.normal,
                      //   fontSize: 16,
                      //   paddingTop: 10,
                      //   paddingBottom: 10,
                      //   align: TextAlign.center,
                      // ),
                      MyText(
                        text: "Alternatively, if you have feedback about an order or our services, please fill out the form below, and we will get back to you shortly.",
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        paddingLeft: 20,
                        paddingRight: 20,
                        paddingTop: 20,
                        paddingBottom: 15,
                        align: TextAlign.center,
                      ),
                      // SizedBox(height: 10),
                      MyText(
                        text: "* indicates a required field",
                        color: Colors.red,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        paddingLeft: 10,
                        paddingTop: 20,
                        paddingBottom: 20,
                        align: TextAlign.left,
                      ),

                      //+ first name
                      MyTextField(
                        hint: "* First Name",
                        controller: firstNameCon,
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

                      //+ last name
                      MyTextField(
                        hint: "* Last Name",
                        controller: lastNameCon,
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
                          // else if(hasMultipleSpaces) {
                          //   return "Last name cannot have consecutive spaces";
                          // }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.formsSizeBoxHeight),

                      MyTextField(
                        hint: "* Personal Email",
                        // disableErrorText: true,
                        controller: emailCon,
                        keyboardType: TextInputType.emailAddress,
                        autoFillHints: const [AutofillHints.email],
                        validator: (String? val) {
                          String value = val ?? "";
                          if (value.isEmpty == true) {
                            return "Email is required";
                          } else if (!GetUtils.isEmail(value.trim())) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.formsSizeBoxHeight),

                      MyTextField(
                        hint: "Email registered in account",
                        // hint: "* App Email (if different from Personal Email)",
                        // disableErrorText: true,
                        controller: accountEmailCon,
                        keyboardType: TextInputType.emailAddress,
                        autoFillHints: const [AutofillHints.email],
                        validator: (String? val) {
                          String value = val ?? "";
                          if (value.isEmpty) {
                            return null;
                          } else if (value.isNotEmpty && !GetUtils.isEmail(value.trim())) {
                            return "Please enter a valid email address";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.formsSizeBoxHeight),

                      MyTextField(
                        hint: "* Phone Number",
                        // disableErrorText: true,
                        controller: phoneCon,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        autoFillHints: const [
                          AutofillHints.telephoneNumber,
                          AutofillHints.telephoneNumberDevice,
                          AutofillHints.telephoneNumberLocal,
                          AutofillHints.telephoneNumberNational,
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
                          //   return "Phone Number is required";
                          // } else if (!value.isNumericOnly) {
                          //   return 'Please enter a valid digit only phone number';
                          // } else if (value.trim().length != 10) {
                          //   return "Please enter your 10 digit phone number";
                          // }
                          // return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.formsSizeBoxHeight),

                      MyTextField(
                        // isExpands: true,
                        maxLines: 5,
                        hint: "* Message",
                        // disableErrorText: true,
                        controller: messageCon,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        validator: (String? val) {
                          String value = val ?? "";
                          if (value.isEmpty == true) {
                            return "Message is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: AppSizes.formsSizeBoxHeight),

                      // const MyText(
                      //   text: "ⓘ Please enter the order id if you are contacting with respect to one.",
                      //   color: AppColors.kRedColor,
                      //   fontWeight: FontWeight.normal,
                      //   maxLines: 2,
                      //   fontSize: 14,
                      //   paddingTop: 5,
                      //   paddingLeft: 15,
                      //   paddingRight: 5,
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: RichText(
                                maxLines: 10,
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  text:
                                      "By clicking \"Submit\" you agree that "
                                      "any information you provide to Sanmiwago "
                                      "will be used in accordance with Sanmiwago's ",
                                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                                  children: [
                                    TextSpan(
                                      text: "Privacy Policy",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Navigate to a privacy policy
                                          navigate(type: PageType.to, page: PrivacyPolicyPage());
                                        },
                                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.normal, decoration: TextDecoration.underline, fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: " and ",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: "Terms & Conditions",
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Navigate to a privacy policy
                                          navigate(type: PageType.to, page: TermsOfUsePage());
                                        },
                                      style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline, fontWeight: FontWeight.normal, fontSize: 16),
                                    ),
                                    TextSpan(
                                      text: ". We may contact you regarding your submission.",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 50,
                        width: 60,
                        child: MyButton(
                          height: 50,
                          width: 60,
                          text: "Submit",
                          padding: 0,
                          marginBottom: 10,
                          marginLeft: 10,
                          marginRight: 10,
                          color: AppColors.kButtonRedColor,
                          onPressed: () async {
                            if (contactFormKey.currentState?.validate() ?? false) {
                              await apiController.contactFormSubmission(
                                firstName: firstNameCon.text.trim(),
                                lastName: lastNameCon.text.trim(),
                                email: emailCon.text.trim(),
                                accountEmail: accountEmailCon.text.trim(),
                                phone: normalizeUsPhoneNumber(phoneCon.text.trim()) ?? "",
                                message: messageCon.text.trim(),
                              );

                              firstNameCon.text = "";
                              lastNameCon.text = "";
                              emailCon.text = "";
                              accountEmailCon.text = "";
                              phoneCon.text = "";
                              messageCon.text = "";

                              await Future.delayed(Duration(milliseconds: 100), () {
                                contactFormKey.currentState?.reset();
                              });
                            } else {
                              log("contact form not validated");
                              showMsg(msg: "Please enter valid data in all required fields.");
                            }
                          },
                        ),
                      ),

                      const SizedBox(height: AppSizes.formsSizeBoxHeight),

                      /* + Old restaurant info part + */
                      // MyText(
                      //   text: restaurantController.selectedRestaurant.value.branchName,
                      //   fontWeight: FontWeight.w600,
                      //   fontSize: 24,
                      //   align: TextAlign.left,
                      //   paddingTop: 5,
                      // ),
                      // SizedBox(height: 20),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Icon(
                      //       Icons.map_outlined,
                      //       size: 24,
                      //     ),
                      //     Expanded(
                      //       child: MyText(
                      //         text: restaurantController.selectedRestaurant.value.address ?? "90 Bowery, New York 10013",
                      //         // fontWeight: FontWeight.bold,
                      //         fontSize: 18,
                      //         paddingLeft: 5,
                      //       ),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(height: 10),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Icon(
                      //       Icons.call,
                      //       size: 24,
                      //     ),
                      //     MyText(
                      //       text: restaurantController.selectedRestaurant.value.phone,
                      //       // fontWeight: FontWeight.bold,
                      //       fontSize: 18,
                      //       paddingLeft: 5,
                      //     )
                      //   ],
                      // ),
                      // SizedBox(height: 10),
                      // Row(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Icon(
                      //       Icons.email_outlined,
                      //       size: 24,
                      //     ),
                      //     MyText(
                      //       text: siteDataController.siteData.portalEmail,
                      //       // fontWeight: FontWeight.bold,
                      //       fontSize: 18,
                      //       paddingLeft: 5,
                      //     )
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
