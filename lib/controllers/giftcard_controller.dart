import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/gift_card_models/gift_card_details_model.dart';
import 'package:sanmiwago_user/models/gift_card_models/gift_card_model.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';

class GiftCardController extends GetxController {
  static GiftCardController instance = Get.find<GiftCardController>();

  RxString selectedMenu = "".obs;
  RxDouble beforeAfterValue = 0.5.obs;
  RxBool isCardSelected = false.obs;
  String selectedCardImage = "";
  String selectedPaymentType = "stripe";
  String cardToken = "";

  RxBool sendToMyself = false.obs;

  RxList<GiftCard> giftCardsList = RxList<GiftCard>.from([]);

  Rx<GiftCardDetails> myGiftCardDetails = GiftCardDetails().obs;

  List<String> menus = ["Buy Gift Card", "Reload Card", "Check Balance", "Recover Giftcard", "Recovered Data"];
  List<String> amounts = ["\$100", "\$200", "\$300", "\$400", "\$500", "\$600", "\$700", "\$800", "\$900"];

  String reloadSelectedAmount = "";
  String buySelectedAmount = "";
  String selectedCardId = "";

  //+ reload gift card controllers
  final GlobalKey<FormState> reloadGiftCardFormKey = GlobalKey<FormState>();
  final TextEditingController reloadGiftCardController = TextEditingController();
  final TextEditingController reloadGiftPinController = TextEditingController();

  //+ buy gift card controllers
  final GlobalKey<FormState> buyGiftCardFormKey = GlobalKey<FormState>();
  final TextEditingController buyGiftCardSenderNameController = TextEditingController();
  final TextEditingController buyGiftCardSenderEmailController = TextEditingController();
  final TextEditingController buyGiftCardSenderPhoneController = TextEditingController();

  final TextEditingController buyGiftCardRecipientNameController = TextEditingController();
  final TextEditingController buyGiftCardRecipientEmailController = TextEditingController();
  final TextEditingController buyGiftCardRecipientPhoneController = TextEditingController();

  //+ check balance gift card controllers
  final GlobalKey<FormState> checkBalanceFormKey = GlobalKey<FormState>();
  final TextEditingController checkBalanceGiftCardController = TextEditingController();
  final TextEditingController checkBalanceGiftPinController = TextEditingController();

  //+ recover gift card controllers
  final GlobalKey<FormState> recoverFormKey = GlobalKey<FormState>();
  final TextEditingController recoverGiftCardLast4Controller = TextEditingController();
  final TextEditingController recoverGiftCardEmailController = TextEditingController();
  final TextEditingController recoverGiftCardPhoneController = TextEditingController();
  final TextEditingController recoverGiftCardOTPController = TextEditingController();
  // final TextEditingController recoveredGiftCardNoController = TextEditingController();

  //+ stripe controllers
  RxBool isPaymentStripeSelected = false.obs;
  final GlobalKey<FormState> stripeFormKey = GlobalKey<FormState>();
  final TextEditingController stripeNameController = TextEditingController();
  final TextEditingController stripeCardController = TextEditingController();
  final TextEditingController stripeCVVController = TextEditingController();
  final TextEditingController stripeExpiryMonthController = TextEditingController();
  final TextEditingController stripeExpiryYearController = TextEditingController();

  bool isReloadingGiftCardSuccessful = false;
  bool isBuyingGiftCardSuccessful = false;
  RxBool isOTPSentForRecovery = false.obs;
  RxBool isOTPReSentForRecovery = false.obs;
  double otpExpireTimeInSec = 60;
  DateTime otpSentAt = DateTime.now();
  // RxBool isRecoveredSuccessfully = false.obs;
  String recoveringGiftCardId = "";
  String recoveredGiftCardNo = "";
  String recoveredPin = "";

  selectMenu(String menu) {
    clearAllControllers();
    sendToMyself.value = false;
    isCardSelected.value = false;
    isPaymentStripeSelected.value = false;
    reloadSelectedAmount = "0";
    buySelectedAmount = "0";
    selectedMenu.value = menu;
    /* + clearing recover giftcard values + */
    isOTPSentForRecovery.value = false;
    otpExpireTimeInSec = 60;
    otpSentAt = DateTime.now();
    // isRecoveredSuccessfully.value = false;
    // recoveringGiftCardId = "";
    // recoveredGiftCardNo = "";
    // recoveredPin = "";
  }

  getGiftCards() {
    apiController.getGiftCards();
  }

  buyGiftCard() async {
    await apiController.buyGiftCard();
    if ((buyGiftCardFormKey.currentState?.validate() ?? false) && !apiController.isBuyingGiftCard.value && isBuyingGiftCardSuccessful) {
      clearAllControllers();
      sendToMyself.value = false;
      isCardSelected.value = false;
      reloadSelectedAmount = "0";
      buySelectedAmount = "0";
      selectedMenu.value = menus.first;
      isBuyingGiftCardSuccessful = false;
    }
  }

  reloadGiftCard() async {
    await apiController.reloadGiftCard();
    if (isReloadingGiftCardSuccessful) {
      clearAllControllers();
      sendToMyself.value = false;
      isCardSelected.value = false;
      reloadSelectedAmount = "0";
      buySelectedAmount = "0";
      selectedMenu.value = menus.first;
      isReloadingGiftCardSuccessful = false;
    }
  }

  checkGiftCardBalance({bool shouldNavigate = true, bool checkingOnCheckout = false, bool showingOutsideLoading = false}) async {
    myGiftCardDetails.value = GiftCardDetails();
    await apiController.checkGiftCardBalance(shouldNavigate: shouldNavigate, checkingOnCheckout: checkingOnCheckout, showingOutsideLoading: showingOutsideLoading);
    // clearAllControllers();
    // sendToMyself.value = false;
    // isCardSelected.value = false;
    // reloadSelectedAmount = "0";
    // buySelectedAmount = "0";
    // selectedMenu.value = menus.first;
  }

  copyGiftCardCode(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    showMsg(msg: "GiftCard code Copied ", isSuccess: true);
  }

  clearAllControllers() {
    reloadGiftCardController.clear();
    reloadGiftPinController.clear();

    recoverGiftCardLast4Controller.clear();
    recoverGiftCardEmailController.clear();
    recoverGiftCardPhoneController.clear();
    recoverGiftCardOTPController.clear();

    buyGiftCardSenderNameController.clear();
    buyGiftCardSenderEmailController.clear();
    buyGiftCardSenderPhoneController.clear();

    buyGiftCardRecipientNameController.clear();
    buyGiftCardRecipientEmailController.clear();
    buyGiftCardRecipientPhoneController.clear();

    checkBalanceGiftCardController.clear();
    checkBalanceGiftPinController.clear();

    stripeNameController.clear();
    stripeCardController.clear();
    stripeCVVController.clear();
    stripeExpiryMonthController.clear();
    stripeExpiryYearController.clear();
  }

  //+ unused

  double fullOffset = 0.0;
  double currentOffset = 0.0;
  int currentIndex = 0;
  List<double> offsetList = [];

  double getRightMoveOffset() {
    if (currentOffset <= (fullOffset - 50)) {
      currentOffset += 50;
    } else {
      currentOffset = fullOffset;
    }
    return currentOffset;
  }

  double getLeftMoveOffset() {
    if (currentOffset > 50) {
      currentOffset -= 50;
    } else {
      currentOffset = 0;
    }
    return currentOffset;
  }

  double getNextCardOffset() {
    log("fullOffset: $fullOffset");
    log("currentOffset: $currentOffset");
    if (currentIndex < 2) {
      currentIndex++;
      currentOffset = currentIndex * (const Offset(350, 200).distance);
      // currentOffset += (fullOffset / 2.35);
    }

    // if (currentOffset < 300) {
    //   currentOffset += (fullOffset / 2.35);
    // } else {
    //   currentOffset = fullOffset;
    // }
    log("fullOffset after : $fullOffset");
    log("currentOffset after: $currentOffset");
    return currentOffset;
  }

  double getPreviousCardOffset() {
    log("fullOffset: $fullOffset");
    log("currentOffset: $currentOffset");

    if (currentIndex > 0) {
      currentIndex--;
      currentOffset = currentIndex * (const Offset(350, 200).distance);
      // currentOffset += (fullOffset / 2.35);
    }

    // if (currentOffset <= fullOffset) {
    //   currentOffset -= (fullOffset / 2.35);
    // } else {
    //   currentOffset = fullOffset;
    //   currentOffset -= (fullOffset / 2.35);
    // }
    /* */
    // if (currentOffset < 300) {
    //   currentOffset += (fullOffset / 2.35);
    // } else {
    //   currentOffset = fullOffset;
    // }
    log("fullOffset after : $fullOffset");
    log("currentOffset after: $currentOffset");
    return currentOffset;
  }

  /// Information is sent through this to get the otp
  /// and then this info is verified and if valid,
  /// an otp is sent on provided phone number
  recoverGiftCardSendInfoToGetOTP({bool shouldNavigate = true, bool checkingOnCheckout = false}) async {
    await apiController.recoverGiftCardSendInfoToGetOTP(shouldNavigate: shouldNavigate);
  }

  /// Verifying the otp
  recoverVerifyOTPForGiftCard({bool shouldNavigate = true}) async {
    await apiController.recoverVerifyOTPForGiftCard(shouldNavigate: shouldNavigate);
  }

  /// Resending the otp
  recoverResendOTPForGiftCard({bool shouldNavigate = true}) async {
    await apiController.recoverResendOTPForGiftCard(shouldNavigate: shouldNavigate);
  }

// resetGiftCardRecoveryValues() {
//   clearAllControllers();
//   isOTPSentForRecovery.value = false;
//   otpExpireTimeInSec = 60;
//   otpSentAt = DateTime.now();
// }
}
