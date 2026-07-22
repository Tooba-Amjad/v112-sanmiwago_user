import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/membership_models/membership_category_model.dart';
import 'package:sanmiwago_user/models/membership_models/user_membership_details.dart';
import 'package:sanmiwago_user/utils/helpers.dart';

import '../../utils/snack_bar.dart';

class MembershipController extends GetxController {
  static MembershipController instance = Get.find<MembershipController>();

  final TextEditingController memberNameController = TextEditingController();
  final TextEditingController membershipCardController = TextEditingController();
  final TextEditingController membershipCategoryNPriceController = TextEditingController();
  final TextEditingController memberDiscountPercentageController = TextEditingController();
  final TextEditingController membershipDateController = TextEditingController();

  final GlobalKey<FormState> buyMembershipFormKey = GlobalKey<FormState>();

  RxBool showPassword = false.obs;

  //+ buy membership controllers
  TextEditingController buyMembershipFirstNameController = TextEditingController();
  TextEditingController buyMembershipLastNameController = TextEditingController();
  TextEditingController buyMembershipEmailController = TextEditingController();
  TextEditingController buyMembershipConfirmEmailController = TextEditingController();
  TextEditingController buyMembershipPhoneNumController = TextEditingController();
  TextEditingController buyMembershipPasswordController = TextEditingController();
  TextEditingController buyMembershipConfirmPasswordController = TextEditingController();
  TextEditingController buyMembershipReferralController = TextEditingController();
  TextEditingController buyMembershipDobController = TextEditingController();


  //+ stripe controllers
  RxBool isPaymentStripeSelected = false.obs;
  String selectedPaymentType = "stripe";
  String cardToken = "";
  final GlobalKey<FormState> stripeFormKey = GlobalKey<FormState>();
  final TextEditingController stripeNameController = TextEditingController();
  final TextEditingController stripeCardController = TextEditingController();
  final TextEditingController stripeCVVController = TextEditingController();
  final TextEditingController stripeExpiryMonthController = TextEditingController();
  final TextEditingController stripeExpiryYearController = TextEditingController();

  // RxBool hasMembership = true.obs;

  RxList<MembershipCategory> membershipCategories = RxList<MembershipCategory>.from([]);
  Rx<UserMembershipDetails> userMembershipDetails = UserMembershipDetails().obs;

  MembershipCategory selectedMembershipCategory = MembershipCategory();

  getMembershipCategories() {
    apiController.getMembershipCategories();
  }

  Future<void> getMembershipData({bool showSnackOnError = true}) async {
    await apiController.getUserMembershipDetails();
    if (userMembershipDetails.value.giftcardMembershipNo.isNotEmpty) {
      memberNameController.text = authController.userData.value.username;
      membershipCardController.text = userMembershipDetails.value.giftcardMembershipNo;
      membershipCategoryNPriceController.text =
          "${userMembershipDetails.value.membershipCategory} - \$${userMembershipDetails.value.membershipAmount}".capitalizeItsFirst();
      memberDiscountPercentageController.text = "${userMembershipDetails.value.percentage}%";
      membershipDateController.text = userMembershipDetails.value.dateTime;
    }
  }

  getMembershipCardDetails() {
    apiController.getMembershipCardDetails();
  }

  buyMembership() async {
    if (authController.userData.value.id.isEmpty) {
      await apiController.buyMembershipAsStranger();
    } else {
      await apiController.buyMembershipAsMember();
    }
  }

  copyMembershipCard() async {
    await Clipboard.setData(ClipboardData(text: membershipCardController.text.trim()));
    showMsg(msg: "Membership Card No. Copied ", isSuccess: true);
  }

  clearAll() {
    cardToken = "";
    selectedPaymentType = "stripe";
    showPassword.value = false;
    isPaymentStripeSelected.value = false;

    userMembershipDetails.value = UserMembershipDetails();
    memberNameController.clear();
    membershipCardController.clear();
    membershipDateController.clear();
    membershipCategoryNPriceController.clear();
    memberDiscountPercentageController.clear();

    buyMembershipFirstNameController.clear();
    buyMembershipLastNameController.clear();
    buyMembershipEmailController.clear();
    buyMembershipConfirmEmailController.clear();
    buyMembershipPhoneNumController.clear();
    buyMembershipPasswordController.clear();
    buyMembershipConfirmPasswordController.clear();
    buyMembershipReferralController.clear();
    buyMembershipDobController.clear();

    stripeNameController.clear();
    stripeCardController.clear();
    stripeCVVController.clear();
    stripeExpiryMonthController.clear();
    stripeExpiryYearController.clear();
  }

  clearBuyMembershipControllers() {
    cardToken = "";
    showPassword.value = false;
    isPaymentStripeSelected.value = false;

    buyMembershipFirstNameController.clear();
    buyMembershipLastNameController.clear();
    buyMembershipEmailController.clear();
    buyMembershipConfirmEmailController.clear();
    buyMembershipPhoneNumController.clear();
    buyMembershipPasswordController.clear();
    buyMembershipConfirmPasswordController.clear();
    buyMembershipReferralController.clear();
    buyMembershipDobController.clear();

    stripeNameController.clear();
    stripeCardController.clear();
    stripeCVVController.clear();
    stripeExpiryMonthController.clear();
    stripeExpiryYearController.clear();
  }
}
