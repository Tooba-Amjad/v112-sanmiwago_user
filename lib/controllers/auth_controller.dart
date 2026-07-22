import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/api_constants.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/constants/my_logger.dart';
import 'package:sanmiwago_user/data/local_db.dart';
import 'package:sanmiwago_user/data/shared_pref.dart';
import 'package:sanmiwago_user/models/user_model/user_model.dart';
import 'package:sanmiwago_user/services/base_client.dart';
import 'package:sanmiwago_user/services/base_controller_mixin.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/formatters/us_phone_number_formatter.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:sanmiwago_user/views/pages/cart/cart_page.dart';
import 'package:sanmiwago_user/views/pages/login/forgot_username_found_email_page.dart';
import 'package:sanmiwago_user/views/pages/restaurants_list/restaurants_list_page.dart';

import '../constants/firebase_constants.dart';
import '../utils/device_info.dart';

class AuthController extends GetxController with BaseController {
  static AuthController instance = Get.find<AuthController>();

  Rx<User> userData = User().obs;
  RxBool isLoggedIn = false.obs;
  RxBool isContinuedAsGuest = false.obs;
  RxBool isActivationLinkSent = false.obs;

  RxString activationLinkEmail = "".obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgotUsernameStep1FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgotUsernameStep2FormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> activateFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> changePasswordFormKey = GlobalKey<FormState>();

  TabController? tabController;

  //+ login controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool showPassword = false.obs;

  //+ forgot password controller
  TextEditingController forgotPasswordEmailController = TextEditingController();

  //+ forgot username controllers
  TextEditingController forgotUsernamePhoneNumCont = TextEditingController();
  TextEditingController forgotUsernameEmailCont = TextEditingController();
  TextEditingController forgotUsernameFoundEmailCont = TextEditingController();
  TextEditingController forgotUsernameFoundReferralCodeCont = TextEditingController();

  //+ change password controllers
  TextEditingController changePassCurrentPassController = TextEditingController();
  TextEditingController changePassNewPassController = TextEditingController();
  TextEditingController changePassConfirmNewPassController = TextEditingController();
  RxBool showChangePassword = false.obs;

  //+ signup controllers
  TextEditingController signupFirstNameController = TextEditingController();
  TextEditingController signupLastNameController = TextEditingController();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupSecondaryEmailController = TextEditingController();
  TextEditingController signupConfirmEmailController = TextEditingController();
  TextEditingController signupPhoneNumController = TextEditingController();
  TextEditingController signupOTPController = TextEditingController();
  TextEditingController signupDobController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();
  TextEditingController signupReferralController = TextEditingController();
  TextEditingController signupQ1Controller = TextEditingController();
  TextEditingController signupQ1AnswerController = TextEditingController();
  TextEditingController signupQ2Controller = TextEditingController();
  TextEditingController signupQ2AnswerController = TextEditingController();

  // RxBool signupShowPassword = false.obs;

  List<String> securityQuestions1 = [
    "Select security question one",
    "City you born",
    "City your parent born",
    "Name of high school",
    "Name of company you first job",
    "Your pet name",
  ];
  List<String> securityQuestions2 = [
    "Select security question two",
    "City you born",
    "City your parent born",
    "Name of high school",
    "Name of company you first job",
    "Your pet name",
  ];

  //+ activate account controllers
  TextEditingController activateEmailController = TextEditingController();

  RxBool isDisable = false.obs;
  RxBool isForgotDisabled = true.obs;
  // RxBool isPhoneNumValid = false.obs;

  RxBool isNumValid = false.obs;
  RxBool canResendOtp = true.obs;
  RxBool isOtpBeingSent = false.obs;
  RxBool isOtpBeingResent = false.obs;
  RxBool isOtpSent = false.obs;
  RxBool isOtpBeingVerified = false.obs;
  RxBool isOtpVerified = false.obs;
  RxString verifiedNumber = "".obs;

  RxBool loading = false.obs;

  DateTime otpSentAt = DateTime.now();

  bool get isThisNumberVerified {
    final currentFieldNum = normalizeUsPhoneNumber(signupPhoneNumController.text.trim()) ?? "";
    return verifiedNumber.value == currentFieldNum;
  }

  signup() async {
    if (!apiController.isSigningUp.value) {
      if (!isOtpVerified.value) {
        showMsg(msg: "Phone number is not verified. Please verify the phone number with OTP to proceed.", time: Duration(seconds: 3));
        return;
      }
      apiController.signup();
    }
  }

  Future<void> login({bool isFromCart = false, bool isFromSplash = false}) async {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      loading.value = true;

      showCircularLoading();
      // String deviceId = await getDeviceId();

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.loginEndpoint, {
            'email': emailController.text.trim(),
            'password': passwordController.text,
            // 'app_id': "$deviceId-${emailController.text.trim()}",
          })
          .catchError((error) => handleError(error));

      log("response of Login Request   $response");

      if (response != null) {
        // String status = response['responce']['status'];
        String status = response.containsKey("responce")
            ? response["responce"].containsKey("status")
                  ? response["responce"]["status"]
                  : ""
            : "error";
        if (status == "success") {
          TextInput.finishAutofillContext();
          await LocalSharedPrefDatabase.setUserEmail(emailController.text.trim());
          userData.value = User.fromJson(response['responce']['loginUserInfo']);
          userData.value = userData.value.copyWith(
            photo: response["responce"]["user-image-base"],
            referralLinkBaseurl: response["responce"]["referal-link-baseurl"],
            shareLinkBaseurl: response["responce"]["share-link-baseurl"],
          );

          log("authController.userData.toJson(): ${userData.value.toJson()}");

          LocalDatabase.saveUser(userData.value);
          profileController.profileDataInitialization();

          isContinuedAsGuest = false.obs;
          isLoggedIn.value = true;
          log("Login Successful");
          authController.saveUserFCM();

          dismissLoading();

          // apiController.logout(); //+ clearing all lists on login
          // Get.offAll(() => const HomeMenuPage());
          if (isFromCart) {
            navigate(type: PageType.off, page: const CartPage());
          } else if (isFromSplash) {
            navigate(type: PageType.off, page: const RestaurantsListPage(isFromSplash: true));
          } else {
            navigate(type: PageType.offAll, page: const BottomNavBarPage());
            // navigate(type: PageType.offAll, page: const HomeMenuPage());
          }
          Future.delayed(const Duration(seconds: 1), () {
            loading.value = false;
            passwordController.clear();
            emailController.clear();
            showPassword.value = false;
          });
        } else {
          loading.value = false;
          dismissLoading();
          showMsg(msg: response['responce']["message"]);
          // showMsg(msg: "Incorrect login credentials");
          log("Something wrong");
        }
      } else {
        dismissLoading();
        showMsg(
          msg:
              "There seems to be some issue on our side. "
              "We will resolve it as soon as we can.",
        );
      }
    } else {
      log("form not validated");
      loading.value = false;
    }
  }

  /// Sends an email to reset the password
  Future<void> forgotPassword(BuildContext context) async {
    if (forgotPasswordFormKey.currentState?.validate() ?? false) {
      forgotPasswordFormKey.currentState?.save();
      showCircularLoading();
      log("Inside forgotPassword function");

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.forgotPasswordEndpoint, {'email': forgotPasswordEmailController.text.trim()})
          .catchError((error) => handleError(error));

      forgotPasswordEmailController.clear();

      log("Response \n $response");

      String status = response['responce']['status'];
      if (status == "success") {
        log("reset email sent successfully !");
        dismissLoading();
        Navigator.of(context).pop(); //+ to close the  dialog
        showMsg(msg: "Reset email sent successfully.", isSuccess: true);
        forgotPasswordEmailController.clear();
        loading.value = false;
      } else {
        dismissLoading();
        loading.value = false;
        showMsg(msg: response['responce']['message']);
        forgotPasswordEmailController.clear();
        log("Something wrong");
      }
    } else {
      loading.value = false;
      log("form not validated");
      showMsg(msg: "Please enter a valid email address.");
    }
  }

  /// Takes phone no. and date of birth to establish whether you are registered or not
  /// if you are then both your security questions are returned and used in the next step
  /// forgotUserNameStep2()
  Future<void> forgotUserNameStep1(BuildContext context) async {
    if (forgotUsernameStep1FormKey.currentState?.validate() ?? false) {
      forgotUsernameStep1FormKey.currentState?.save();

      log("Inside forgotUsernamePart1 function");

      showCircularLoading();

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.forgotUsernameStep1Endpoint, {
            'phone_no': normalizeUsPhoneNumber(forgotUsernamePhoneNumCont.text.trim()) ?? "",
            'email': forgotUsernameEmailCont.text.trim(),
          })
          .catchError((error) => handleError(error));

      // forgotPasswordEmailController.clear();

      log("Response \n $response");

      // String status = response['responce']['status'];
      String status = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (status == "success") {
        log(" phone and email are verified !");

        User tempUserData = User.fromJson(response["responce"]["forgot_user_data"][0]);

        forgotUsernameFoundEmailCont.text = tempUserData.email;
        forgotUsernameFoundReferralCodeCont.text = tempUserData.referralCode;

        dismissLoading();

        /* //+ move to next page where we show user email and referral code */
        // navigate(type: PageType.to, page: const ForgotUsernameFoundEmailPage());
        Get.off(() => const ForgotUsernameFoundEmailPage(), transition: Transition.rightToLeftWithFade, duration: const Duration(milliseconds: 500));

        /* */
        // showMsg(
        //   msg: "Your phone and dob is verified. Please answer the security questions to get your data.",
        //   isSuccess: true,
        // );
        /* */
        Future.delayed(const Duration(seconds: 1), () {
          forgotUsernamePhoneNumCont.clear();
          forgotUsernameEmailCont.clear();
        });
        loading.value = false;
      } else {
        dismissLoading();
        loading.value = false;
        showMsg(msg: response['responce']['message']);
        // forgotUsernameDobController.clear();
        log("Something wrong");
      }
    } else {
      loading.value = false;
      dismissLoading();
      log("form not validated");
      showMsg(msg: "Please fill out both the fields with valid data.");
    }
  }

  Future<void> sendOTP({bool isResending = false}) async {
    if (isOtpBeingSent.value || isOtpBeingResent.value) return;
    try {
      isOtpBeingSent(true);
      if (isResending) isOtpBeingResent(true);
      showCircularLoading();
      log("Inside sendOTP function");

      var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.sendOTPEndpoint, {
        'phone': normalizeUsPhoneNumber(signupPhoneNumController.text),
      }); //.catchError(handleError);

      log("Response in sendOTP \n $response");

      String status = response['status'] ?? "error";

      if (status == "success") {
        log("OTP sent successfully !");
        dismissLoading();

        showMsg(msg: "OTP sent successfully.", isSuccess: true);

        isOtpBeingSent(false);
        if (isResending) isOtpBeingResent(false);
        isOtpSent(true);
        canResendOtp(false);
        otpSentAt = DateTime.now();
      } else {
        isOtpBeingSent(false);
        if (isResending) isOtpBeingResent(false);
        dismissLoading();
        // loading.value = false;
        showMsg(msg: response['message'] ?? "Could not send OTP. Please try again.");
        log("Something wrong here's the response: $response");
      }
    } catch (e) {
      isOtpBeingSent(false);
      if (isResending) isOtpBeingResent(false);
      log("error in sendOTP: $e");
      dismissLoading();
      showMsg(msg: "Could not send OTP. Please try again.");
    }
  }

  Future<void> verifyOTP() async {
    if (isOtpBeingVerified.value) return;
    try {
      isOtpBeingVerified(true);
      showCircularLoading();
      log("Inside verifyOTP function");

      var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.verifyOTPEndpoint, {
        'phone': normalizeUsPhoneNumber(signupPhoneNumController.text),
        'otpentered': signupOTPController.text.trim(),
      }); //.catchError(handleError);

      log("Response in verifyOTP \n $response");

      String status = response['status'] ?? "error";

      if (status == "success") {
        log("OTP verified successfully !");
        dismissLoading();

        showMsg(msg: "OTP verified successfully.", isSuccess: true);

        isOtpBeingVerified(false);
        isOtpVerified(true);
        verifiedNumber(normalizeUsPhoneNumber(signupPhoneNumController.text));
        signupOTPController.clear();
      } else {
        isOtpBeingVerified(false);
        signupOTPController.clear();
        dismissLoading();
        // loading.value = false;
        showMsg(msg: response['message'] ?? "Could not verify OTP. Please try again.");
        log("Something wrong here's the response: $response");
      }
    } catch (e) {
      isOtpBeingVerified(false);
      log("error in verifyOTP: $e");
      dismissLoading();
      showMsg(msg: "Could not verify OTP. Please try again.");
    }
  }

  Future<void> saveUserFCM({String? cartId, String? token}) async {
    if (!isLoggedIn.value) return;
    try {
      log("Inside saveUserFCM function");

      Map<String, dynamic> queryParameters = {
        'email': userData.value.email,
        'device_id': await getDeviceId(),
        'fcm_token': token ?? await getFcmToken() ?? "",
        'restaurant_id': restaurantController.selectedRestaurant.value.id,
      };

      if (cartId != null) {
        queryParameters['cart_id'] = cartId;
      }

      var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.saveUserFCMEndpoint, queryParameters); //.catchError(handleError);

      log("Response in saveUserFCM \n $response");

      String status = response['responce']['status'] ?? "error";

      if (status == "success") {
        log("FCM saved successfully");
      } else {
        // showMsg(msg: response['responce']['message'] ?? "Could not Save FCM. Please try again.");
        log("Something wrong here's the response: $response");
      }
    } catch (e) {
      log("error in saveUserFCM: $e");
      // dismissLoading();
      // showMsg(msg: "Could not save FCM. Please try again.");
    }
  }

  Future<String?> getFcmToken() async {
    return await fcm.getToken();
  }

  // Takes the answers to security questions and responds with email and referral code
  // with either of which you can sign in using your password
  /**/
  // Future<void> forgotUserNameStep2(BuildContext context) async {
  //   if (forgotUsernameStep2FormKey.currentState?.validate() ?? false) {
  //     forgotUsernameStep2FormKey.currentState?.save();
  //
  //     log("Inside forgotUsernamePart2 function");
  //
  //     var response = await BaseClient().post(
  //       ApiConstants.baseUrl,
  //       ApiConstants.forgotUsernameStep2Endpoint,
  //       {
  //         'phone_no': forgotUsernamePhoneNumCont.text.trim(),
  //         'date_of_birth': getFormattedDate(forgotUsernameEmailCont.text.trim()), //03-04-2000
  //         'security_question_one_answer': forgotUsernameAnswer1Controller.text.trim(),
  //         'security_question_two_answer': forgotUsernameAnswer2Controller.text.trim(),
  //       },
  //     ).catchError(handleError);
  //
  //     forgotPasswordEmailController.clear();
  //
  //     log("Response \n $response");
  //
  //     String status = response['responce']['status'];
  //     if (status == "success") {
  //       log(" security question answers verified !");
  //
  //       User tempUserData = User.fromJson(response["responce"]["forgot_user_data"]);
  //
  //       forgotUsernameFoundEmailCont.text = tempUserData.email;
  //       forgotUsernameFoundReferralCodeCont.text = tempUserData.referralCode;
  //
  //       /* //+ move to next page where we show user email and referral code */
  //       Get.to(
  //         () => const ForgotUsernameFoundEmailPage(),
  //         transition: Transition.rightToLeftWithFade,
  //         duration: const Duration(milliseconds: 500),
  //       );
  //       /* */
  //       // showMsg(
  //       //   msg: "Your phone and dob is verified. Please answer the security questions to get your data.",
  //       //   isSuccess: true,
  //       // );
  //       Future.delayed(const Duration(seconds: 1), () {
  //         forgotUsernamePhoneNumCont.clear();
  //         forgotUsernameEmailCont.clear();
  //         forgotUsernameAnswer1Controller.clear();
  //         forgotUsernameAnswer2Controller.clear();
  //       });
  //
  //       loading.value = false;
  //     } else {
  //       loading.value = false;
  //       showMsg(msg: response['responce']['message']);
  //       // forgotUsernameDobController.clear();
  //       log("Something wrong");
  //     }
  //   } else {
  //     loading.value = false;
  //     log("form not validated");
  //     showMsg(msg: "Please fill out both fields.");
  //   }
  // }

  /// Change or update the user password
  updatePassword() {
    apiController.updatePassword();
  }

  /// gets the user from local db and if it's not there sets userData empty and isLoggedIn false
  authInitialization() async {
    userData.value = await LocalDatabase.getUser();
    if (userData.value.userId.isEmpty) {
      isLoggedIn.value = false;
    } else {
      isLoggedIn.value = true;
      profileController.profileDataInitialization();
    }
  }

  copyForgotEmail() async {
    await Clipboard.setData(ClipboardData(text: forgotUsernameFoundEmailCont.text.trim()));
    showMsg(msg: "Email Copied ", isSuccess: true);
  }

  copyForgotReferralCode() async {
    await Clipboard.setData(ClipboardData(text: forgotUsernameFoundReferralCodeCont.text.trim()));
    showMsg(msg: "Member Id Copied ", isSuccess: true);
    // showMsg(msg: "Referral Code Copied ", isSuccess: true);
  }

  clearSignupControllers() {
    signupFirstNameController.clear();
    signupLastNameController.clear();
    signupPhoneNumController.clear();
    signupOTPController.clear();
    signupEmailController.clear();
    signupSecondaryEmailController.clear();
    signupPasswordController.clear();
    signupConfirmPasswordController.clear();
    signupDobController.clear();
    signupQ1Controller.clear();
    signupQ1AnswerController.clear();
    signupQ2Controller.clear();
    signupQ2AnswerController.clear();
    signupReferralController.clear();
    showPassword.value = false;
    isOtpBeingSent(false);
    isOtpBeingResent(false);
    isOtpSent(true);
    canResendOtp(false);
    isOtpBeingVerified(false);
    isOtpVerified(true);
    isNumValid(false);
    verifiedNumber("");
  }

  logout({bool showMessage = true}) async {
    try {
      await LocalSharedPrefDatabase.logout();
      await LocalDatabase.deleteUser();
      emailController.clear();
      passwordController.clear();
      showPassword.value = false;
      loading.value = false;
      isOtpBeingSent(false);
      isOtpBeingResent(false);
      isOtpSent(false);
      canResendOtp(false);
      isOtpBeingVerified(false);
      isOtpVerified(false);
      isNumValid(false);
      verifiedNumber("");

      myOrdersController.logout();
      orderController.clearCart();
      orderController.clearOrderData();
      checkoutController.clearAll();

      /*+ Commented As Requested by Allen +*/
      /*+ Un-Commented As Requested by Allen on Aug-13-2024 +*/
      checkoutController.clearTips();

      checkoutController.clearMembershipDiscountData();
      checkoutController.clearSpDiscountData();
      checkoutController.clearCouponDiscountData();
      membershipController.clearAll();
      myPointsController.logout();
      userData.value = User();
      isLoggedIn.value = false;
      if (showMessage) showMsg(msg: "Successfully logged out.", isSuccess: true);
      //+New added
      // navigate(
      //   type: PageType.offAll,
      //   page: const BottomNavBarPage(homeReload: false),
      //   // page: const HomeMenuPage(reload: false),
      // );
    } catch (e) {
      errorLog("error in logging out");
      showMsg(msg: "Logout unsuccessful!");
    }
  }
}
