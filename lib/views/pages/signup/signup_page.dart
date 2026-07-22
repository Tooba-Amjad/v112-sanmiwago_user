import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_sizes.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/formatters/date_formatter.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/layout/my_form_page.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';
import 'package:sanmiwago_user/views/pages/signup/activate_account.dart';
import 'package:sanmiwago_user/views/pages/signup/signup_otp_section_widget.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/privacy_policy.dart';
import 'package:sanmiwago_user/views/pages/terms_and_privacy/terms_of_use.dart';
import 'package:sanmiwago_user/views/widgets/my_checkbox_tile.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';
import 'package:simple_timer/simple_timer.dart';

import '../../../constants/app_constants.dart';
import '../../../generated/assets.dart';
import '../../../utils/formatters/us_phone_number_formatter.dart';
import '../../../utils/validators/us_phone_number_validator.dart';

class SignupPage extends StatefulWidget {
  final bool allowBack;
  final bool isFromSplash;

  const SignupPage({super.key, this.allowBack = true, this.isFromSplash = false});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailFocusNode = FocusNode();

  final passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    setupPhoneListener();
  }

  // In your controller (or init logic)
  void setupPhoneListener() {
    authController.signupPhoneNumController.addListener(() {
      final normalized = normalizeUsPhoneNumber(authController.signupPhoneNumController.text.trim()) ?? "";

      log("authController.isThisNumberVerified: ${authController.isThisNumberVerified}");
      if (authController.verifiedNumber.isNotEmpty && !authController.isThisNumberVerified) {
        authController.isOtpBeingVerified(false);
        authController.isOtpVerified(false);
        authController.isOtpSent(false);
        authController.isOtpBeingSent(false);
        authController.isOtpBeingResent(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async {
          authController.signupFirstNameController.clear();
          authController.signupLastNameController.clear();
          authController.signupEmailController.clear();
          authController.signupConfirmEmailController.clear();
          authController.signupPhoneNumController.clear();
          authController.signupOTPController.clear();
          authController.signupDobController.clear();
          authController.signupPasswordController.clear();
          authController.signupConfirmPasswordController.clear();
          authController.signupReferralController.clear();
          authController.signupQ1Controller.clear();
          authController.signupQ1AnswerController.clear();
          authController.signupQ2Controller.clear();
          authController.signupQ2AnswerController.clear();
          authController.showPassword.value = false;
          authController.isOtpSent(false);
          authController.isOtpVerified(false);
          authController.isOtpBeingVerified(false);
          authController.isOtpBeingSent(false);
          authController.isOtpBeingResent(false);
          authController.canResendOtp(false);
          authController.isNumValid(false);
          authController.verifiedNumber("");

          if (!widget.allowBack) {
            navigate(type: PageType.offAll, page: const LoginPage());
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          // backgroundColor: AppColors.kGreyColor,
          backgroundColor: AppColors.kSkyLightDullColor,
          appBar: simpleAppBar(
            title: "Register",
            haveBackIcon: true,
            onBackPressed: () {
              Get.back();
              authController.signupFirstNameController.clear();
              authController.signupLastNameController.clear();
              authController.signupEmailController.clear();
              authController.signupConfirmEmailController.clear();
              authController.signupPhoneNumController.clear();
              authController.signupOTPController.clear();
              authController.signupDobController.clear();
              authController.signupPasswordController.clear();
              authController.signupConfirmPasswordController.clear();
              authController.signupReferralController.clear();
              authController.signupQ1Controller.clear();
              authController.signupQ1AnswerController.clear();
              authController.signupQ2Controller.clear();
              authController.signupQ2AnswerController.clear();
              authController.showPassword.value = false;
              authController.isOtpSent(false);
              authController.isOtpVerified(false);
              authController.isOtpBeingVerified(false);
              authController.isOtpBeingSent(false);
              authController.isOtpBeingResent(false);
              authController.canResendOtp(false);
              authController.isNumValid(false);
              authController.verifiedNumber("");

              navigate(
                type: PageType.offAll,
                page: LoginPage(isFromSplash: widget.isFromSplash),
              );
            },
          ),
          body: Form(
            key: authController.signupFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: MyFormPage(
              pageTopPadding: Get.height * .03,
              children: [
                //+ first name
                MyTextField(
                  hint: "First Name",
                  controller: authController.signupFirstNameController,
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
                  hint: "Last Name",
                  controller: authController.signupLastNameController,
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

                /* + email + */
                MyTextField(
                  focusNode: emailFocusNode,
                  hint: "Email",
                  controller: authController.signupEmailController,
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

                /* + confirm email + */
                // MyTextField(
                //   hint: "Confirm Email",
                //   controller: authController.signupConfirmEmailController,
                //   keyboardType: TextInputType.emailAddress,
                //   autoFillHints: const [AutofillHints.email],
                //   validator: (String? value) {
                //     if (value?.isEmpty == true) {
                //       return "Confirm Email is required";
                //     } else if (!GetUtils.isEmail(value?.trim() ?? "")) {
                //       return "Please enter a valid email address";
                //     } else if ((value?.trim() ?? "") != authController.signupEmailController.text.trim()) {
                //       return "Email mismatch";
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: AppSizes.formsSizeBoxHeight),

                /* + phone + */
                MyTextField(
                  // hint: "Phone No",
                  hint: '(123) 456-7890',
                  controller: authController.signupPhoneNumController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  autoFillHints: const [AutofillHints.telephoneNumber, AutofillHints.telephoneNumberDevice],
                  inputFormatters: [LengthLimitingTextInputFormatter(14), FilteringTextInputFormatter.digitsOnly, UsNumberTextInputFormatter()],
                  validator: (String? val) {
                    String value = val ?? "";
                    final usPhoneValidity = validateUsPhoneNumber(value);
                    authController.isNumValid.value = (usPhoneValidity == null);
                    return usPhoneValidity;

                    // if (value.isEmpty == true) {
                    //   return "Phone number is required";
                    // } else if (!value.isNumericOnly) {
                    //   return 'Please enter a valid digit only phone number';
                    // } else if (value.trim().length != 10) {
                    //   return 'Please enter your 10 digit phone number';
                    // } else {
                    // } else if (!GetUtils.isPhoneNumber(value?.trim() ?? "")) {
                    //   return "Please enter a valid email address";
                    // }
                    // return null;
                  },
                ),

                /* + OTP section + */
                SignupOTPSectionWidget(),

                /* + date field + */
                MyTextField(
                  // onTap: () async {
                  //   await showDatePicker(
                  //     context: context,
                  //     initialDate: DateTime.now(),
                  //     firstDate: DateTime(1850),
                  //     lastDate: DateTime.now(),
                  //   ).then((selectedDate) {
                  //     if (selectedDate != null) {
                  //       infoLog("onDateSubmitted called");
                  //       String day = "${selectedDate.day < 10 ? "0${selectedDate.day}" : selectedDate.day}";
                  //       String month = "${selectedDate.month < 10 ? "0${selectedDate.month}" : selectedDate.month}";
                  //       String year = "${selectedDate.year}";
                  //       authController.signupDobController.text = "$month/$day/$year";
                  //     }
                  //   });
                  // },
                  controller: authController.signupDobController,
                  hint: "Birthday (MM/DD)",
                  keyboardType: TextInputType.datetime,
                  autoFillHints: const [AutofillHints.birthdayDay],
                  inputFormatters: [DateTextFormatter(), LengthLimitingTextInputFormatter(5)],
                  textInputAction: TextInputAction.next,
                  validator: (String? value) {
                    String v = value ?? "";
                    if (v.isNotEmpty) {
                      if (!v.trim().replaceAll("/", "").isNumericOnly) {
                        return "Invalid Birthday";
                      } else if (v.trim().replaceAll("/", "").length != 4) {
                        return "Invalid - Required format is (MM/DD)";
                      } else if (!isValidDate(v.trim())) {
                        return "Invalid - Required format is (MM/DD)";
                      }
                    }
                    // else {
                    return null;
                    // }
                  },
                ),

                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: AppSizes.fieldsPadding),
                //   child: InputDatePickerFormField(
                //     firstDate: DateTime(1850),
                //     lastDate: DateTime.now(),
                //     fieldHintText: "Date of Birth (DD/MM/YYYY)",
                //     onDateSubmitted: (value) {
                //       infoLog("onDateSubmitted called");
                //       String day = "${value.day < 10 ? "0${value.day}" : value.day}";
                //       String month = "${value.month < 10 ? "0${value.month}" : value.month}";
                //       String year = "${value.year}";
                //       authController.signupDobController.text = "$day/$month/$year";
                //     },
                //     onDateSaved: (value) {
                //       infoLog("onDateSaved called");
                //       String day = "${value.day < 10 ? "0${value.day}" : value.day}";
                //       String month = "${value.month < 10 ? "0${value.month}" : value.month}";
                //       String year = "${value.year}";
                //       authController.signupDobController.text = "$day/$month/$year";
                //     },
                //   ),
                // ),
                // const SizedBox(height: AppSizes.formsSizeBoxHeight),

                /* secondary email field*/
                // MyTextField(
                //   hint: "Secondary Email",
                //   controller: authController.signupSecondaryEmailController,
                //   keyboardType: TextInputType.emailAddress,
                //   autoFillHints: const [AutofillHints.email],
                //   validator: (String? value) {
                //     if (value?.isEmpty == true) {
                //       return "Secondary Email is required";
                //     } else if (!GetUtils.isEmail(value?.trim() ?? "")) {
                //       return "Please enter a valid secondary email address";
                //     }
                //     return null;
                //   },
                // ),
                const SizedBox(height: AppSizes.formsSizeBoxHeight),

                //+ password field
                Obx(() {
                  return MyTextField(
                    focusNode: passwordFocusNode,
                    controller: authController.signupPasswordController,
                    hint: "Password",
                    isObSecure: !authController.showPassword.value,
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
                      value: authController.showPassword.value,
                      onChanged: (bool? value) {
                        // this.value = value;
                        log("check box value: $value");
                        authController.showPassword.value = (value ?? false);
                      },
                    );
                  }),
                ),

                const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),

                /* + confirm password field + */
                // Obx(() {
                //   return MyTextField(
                //     // focusNode: passwordFocusNode,
                //     controller: authController.signupConfirmPasswordController,
                //     hint: "Confirm Password",
                //     isObSecure: !authController.showPassword.value,
                //     keyboardType: TextInputType.visiblePassword,
                //     autoFillHints: const [AutofillHints.password],
                //     textInputAction: TextInputAction.next,
                //     // onFieldSubmitted: (val) => TextInput.finishAutofillContext(),
                //     validator: (String? value) {
                //       if (value?.trim().isEmpty == true) {
                //         return 'Confirm Password is Required';
                //       } else if ((value?.trim() ?? "") != authController.signupPasswordController.text.trim()) {
                //         return 'Password mismatch';
                //       }
                //
                //       return null;
                //     },
                //   );
                // }),
                // const SizedBox(height: AppSizes.formsSizeBoxHeight),

                //+ referral code COMMENTED BY ALLAN On 27 October 2024
                //+ referral code UN-COMMENTED As requested BY ALLAN On Feb-23-2025
                MyTextField(
                  // hint: "Member Id (of the member who referred you)",
                  hint: "Member Id (of your referrer)",
                  // hint: "Member Id",
                  // hint: "Referral Code",
                  controller: authController.signupReferralController,
                  keyboardType: TextInputType.streetAddress,
                  // autoFillHints: const [AutofillHints.name],
                  validator: (String? value) {
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

                // //+ Security Question text
                // const Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     MyText(
                //       text: "Security Questions",
                //       align: TextAlign.start,
                //       color: Colors.black,
                //       fontWeight: FontWeight.w500,
                //       fontSize: 20,
                //       paddingLeft: 15,
                //     ),
                //   ],
                // ),
                //
                // const SizedBox(height: AppSizes.formsSizeBoxHeight / 2),
                //
                // //+ security question 1 drop down
                // MyDropDownTextField(
                //   isForEdit: true,
                //   listItem: authController.securityQuestions1,
                //   hintText: "Select security question 1",
                //   onChange: (value) {
                //     infoLog("selected security question 1: $value");
                //     authController.signupQ1Controller.text = value ?? "";
                //   },
                //   validator: (value) {
                //     if (value == authController.securityQuestions1.first) {
                //       return "Please select a value";
                //     }
                //     return null;
                //   },
                // ),
                //
                // const SizedBox(height: AppSizes.formsSizeBoxHeight),
                //
                // //+ security answer 1
                // MyTextField(
                //   hint: "Security Question One Answer",
                //   controller: authController.signupQ1AnswerController,
                //   keyboardType: TextInputType.streetAddress,
                //   // autoFillHints: const [AutofillHints.name],
                //   validator: (String? value) {
                //     if ((value?.isEmpty ?? true) == true) {
                //       return "Security Question One Answer is required";
                //     }
                //     return null;
                //   },
                // ),
                //
                // const SizedBox(height: AppSizes.formsSizeBoxHeight),
                //
                // //+ security question 2 drop down
                // MyDropDownTextField(
                //   isForEdit: true,
                //   listItem: authController.securityQuestions2,
                //   hintText: "Select security Question Two",
                //   onChange: (value) {
                //     infoLog("selected security question 2: $value");
                //     authController.signupQ2Controller.text = value ?? "";
                //   },
                //   validator: (value) {
                //     if (value == authController.securityQuestions1.first) {
                //       return "Please select a value";
                //     }
                //     return null;
                //   },
                // ),
                //
                // const SizedBox(height: AppSizes.formsSizeBoxHeight),
                //
                // //+ security answer 2
                // MyTextField(
                //   hint: "Security Question Two Answer",
                //   controller: authController.signupQ2AnswerController,
                //   keyboardType: TextInputType.streetAddress,
                //   // autoFillHints: const [AutofillHints.name],
                //   validator: (String? value) {
                //     if ((value?.isEmpty ?? true) == true) {
                //       return "Security Question One Answer is required";
                //     }
                //     return null;
                //   },
                // ),
                // const SizedBox(height: AppSizes.formsSizeBoxHeight),
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
                                "By clicking \"Register\" you agree that "
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
                                text: ". ",
                                // "We may contact you regarding your submission.",
                                style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /* */
                //+ Register button
                Obx(() {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 5),
                    child: MaterialButton(
                      color: authController.loading.value == true ? AppColors.kGreenColor : AppColors.kRedColor,
                      height: 52,
                      minWidth: Get.width - 30,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      onPressed: () {
                        hideKeyboard(context);
                        authController.signup();
                      },
                      child: const MyText(text: "Register", color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  );
                }),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyText(
                      text: "Activate Your Account",
                      align: TextAlign.end,
                      color: AppColors.kGreyColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      paddingRight: 12,
                      onTap: () {
                        navigate(type: PageType.to, page: const ActivateAccountPage());
                      },
                    ),
                  ],
                ),
                // const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
