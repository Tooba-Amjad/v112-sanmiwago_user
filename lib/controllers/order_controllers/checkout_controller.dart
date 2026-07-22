import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/checking_delivery_order_model.dart';
import 'package:sanmiwago_user/models/checkout_user_info_model.dart';
import 'package:sanmiwago_user/models/delivery_fee_model.dart';
import 'package:sanmiwago_user/models/gift_card_models/gift_card_details_model.dart';

import '../../models/state_model.dart';
import '../../utils/enums.dart';
import '../../utils/formatters/us_phone_number_formatter.dart';

class CheckoutController extends GetxController {
  static CheckoutController instance = Get.find<CheckoutController>();

  RxString selectedPaymentType = "".obs;
  RxDouble tipPercentage = 0.0.obs;
  RxDouble driverTipPercentage = 0.0.obs;
  RxDouble tipTotal = 0.0.obs;
  RxDouble tipPointsTotal = 0.0.obs;
  RxDouble driverTipTotal = 0.0.obs;
  RxDouble driverTipPointsTotal = 0.0.obs;
  RxDouble deliveryFeeTotal = 0.0.obs;
  RxDouble deliveryFeePointsTotal = 0.0.obs;

  RxBool isOrderDeliverable = false.obs;
  RxBool showRedeemSection = true.obs;

  String cardToken = "";
  String lastFour = "";

  RxBool isRedeemPointCheckout = false.obs;
  RxBool payWithGiftCard = false.obs;

  Rx<CheckoutUserInfo> checkoutUserInfo = CheckoutUserInfo().obs;
  Rx<DeliveryFeeInfoModel> deliveryFeeInfo = DeliveryFeeInfoModel().obs;
  Rx<DeliveryAllowedModel> deliveryAllowedModel = DeliveryAllowedModel().obs;
  RxString isDeliveryOrderAllowed = "".obs;

  //+ user info controllers
  final GlobalKey<FormState> userInfoFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  RxBool shouldSendMessage = false.obs;

  RxString orderType = "pickup".obs;
  final GlobalKey<FormState> deliveryInfoFormKey = GlobalKey<FormState>();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController buildingNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController suiteAptController = TextEditingController();

  // final TextEditingController streetNameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final TextEditingController deliverNoteController = TextEditingController();
  double addressLat = 0.0;
  double addressLng = 0.0;
  RxString selectedState = "".obs;

  RxList<LocationState> states = RxList<LocationState>.from([]);

  //+ gift card controllers
  final GlobalKey<FormState> checkoutGiftFormKey = GlobalKey<FormState>();
  final TextEditingController checkoutGiftCardController = TextEditingController();
  final TextEditingController checkoutGiftPinController = TextEditingController();

  //+ membership card controllers
  final GlobalKey<FormState> membershipFormKey = GlobalKey<FormState>();
  final TextEditingController membershipCardController = TextEditingController();
  final TextEditingController spDiscountCodeController = TextEditingController();
  final TextEditingController couponCodeController = TextEditingController();

  RxString selectedDiscountOption = DT.gift.name.obs;
  bool isMembershipCardAppliedAtCheckout = false;
  bool isSPDiscountAppliedAtCheckout = false;
  bool isCouponDiscountAppliedAtCheckout = false;
  double sPDiscountPercentageForOrder = 0.0;
  double membershipCardPercentageForOrder = 0.0;

  /* + coupon code related fields + */
  RxDouble couponPercentageForOrder = 0.0.obs;
  RxDouble couponDiscount = 0.0.obs;

  String membershipCardTypeForOrder = "";
  String membershipCardNoApplied = "";
  String spDiscountCodeApplied = "";
  String couponCodeApplied = "";

  RxString checkoutFinalTotal = "0.0".obs;

  //+ stripe controllers
  RxBool isPaymentStripeSelected = false.obs;
  final GlobalKey<FormState> stripeFormKey = GlobalKey<FormState>();
  final TextEditingController stripeNameController = TextEditingController();
  final TextEditingController stripeCardController = TextEditingController();
  final TextEditingController stripeCVVController = TextEditingController();
  final TextEditingController stripeExpiryMonthController = TextEditingController();
  final TextEditingController stripeExpiryYearController = TextEditingController();

  /// Initially only worked based on the points being enough or not.
  ///
  /// Now it also checks if the order type is not delivery.
  bool shouldShowRedeemSection() {
    log("driverTipPointsTotal: $driverTipPointsTotal");
    log("tipPointsTotal: $tipPointsTotal");
    log("deliveryFeePointsTotal: $deliveryFeePointsTotal");
    showRedeemSection.value =
        (orderController.cartItems.fold(0.0, (previousValue, cartItem) => previousValue + (cartItem.itemCount * (double.tryParse(cartItem.pointsToPurchase) ?? 0.0))) +
                checkoutController.tipPointsTotal.value +
                checkoutController.driverTipPointsTotal.value +
                checkoutController.deliveryFeePointsTotal.value)
            .toPrecision(0) <=
        (double.tryParse(authController.userData.value.userPoints) ?? 0.0);
    return showRedeemSection.value && orderType.value != "delivery";
  }

  String getPayableTotal() {
    double total = orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) + orderController.calculatedSalesTax.value;
    double giftCardBalance = double.tryParse(giftCardController.myGiftCardDetails.value.data?.totalAmount ?? "0.0") ?? 0.0;
    if (selectedPaymentType.value == "hybrid") {
      return (total - giftCardBalance).toPrecision(2).toStringAsFixed(2);
    } else {
      return total.toPrecision(2).toStringAsFixed(2);
    }
  }

  getTipTotal(double total) {
    tipTotal.value = (tipPercentage.value.round() * (total / 100)).toPrecision(2);
    tipPointsTotal.value = ((tipPercentage.value.round() * (total / 100)) * 10).toPrecision(2);
    driverTipTotal.value = (driverTipPercentage.value.round() * (total / 100)).toPrecision(2);
    driverTipPointsTotal.value = ((driverTipPercentage.value.round() * (total / 100)) * 10).toPrecision(2);
    return (tipTotal.value.toPrecision(2) + driverTipTotal.value.toPrecision(2));
  }

  // getDriverTipTotal(double total) {
  //   driverTipTotal.value = (driverTipPercentage.value.round() * (total / 100)).toPrecision(2);
  //   return driverTipTotal.value.toPrecision(2);
  // }

  void getDiscountedPayableTotal() {
    double finalTotal = 0.0;
    double discountHandler = 0;
    double totalWithoutTax = orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice);
    log("sPDiscountPercentageForOrder: $sPDiscountPercentageForOrder");
    log("couponPercentage: ${couponPercentageForOrder.value}");
    orderController.discount.value = isMembershipCardAppliedAtCheckout
        ? totalWithoutTax * (membershipCardPercentageForOrder / 100)
        : isCouponDiscountAppliedAtCheckout
        ? totalWithoutTax * (couponPercentageForOrder.value / 100)
        : totalWithoutTax * (sPDiscountPercentageForOrder / 100);
    // totalWithoutTax -= orderController.discount.value;

    orderController.calculatedSalesTax.value =
        (((orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) - orderController.discount.value) / 100) *
                siteDataController.salesTax.value)
            .toPrecision(2);
    log(
      "orderController.calculatedSalesTax.value -- calculated sales tax after card == $isMembershipCardAppliedAtCheckout is: ${orderController.calculatedSalesTax.value}",
    );
    double total = orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) + orderController.calculatedSalesTax.value;
    double giftCardBalance = double.tryParse(giftCardController.myGiftCardDetails.value.data?.totalAmount ?? "0.0") ?? 0.0;
    if (selectedPaymentType.value == "hybrid") {
      finalTotal = (total - giftCardBalance);
    } else {
      finalTotal = total;
    }
    log("isMembershipCardAppliedAtCheckout.value: $isMembershipCardAppliedAtCheckout");
    if (isMembershipCardAppliedAtCheckout) {
      // orderController.discount.value = totalWithoutTax * (membershipCardPercentageForOrder / 100); // moved to the top of this function
      finalTotal = total - orderController.discount.value;
    } else if (isSPDiscountAppliedAtCheckout) {
      finalTotal = total - orderController.discount.value;
    } else if (isCouponDiscountAppliedAtCheckout) {
      /* + only considering the total because we have already removed the discount from totalWithoutTax = subtotal + */
      finalTotal = total - orderController.discount.value;
    } else {
      orderController.discount.value = 0.0;
    }
    // finalTotal += getTipTotal(total - orderController.calculatedSalesTax.value - giftCardBalance - orderController.discount.value);
    finalTotal += getTipTotal(finalTotal);
    finalTotal += deliveryFeeTotal.value.toPrecision(2);
    log("\n\n getTipTotal: staff tip + driver tip is: ${(tipTotal.value + driverTipTotal.value)}");
    checkoutFinalTotal.value = finalTotal.toPrecision(2).toStringAsFixed(2);
    if (selectedPaymentType.value == "redeemPoint") {
      shouldShowRedeemSection();
    }
    // - giftCardBalance -orderController.discount.value); // this part might have to be removed because I think the tip is based on the order amount but we'll see what they say
    // return ;
  }

  getStates() {
    apiController.getStates();
  }

  Future<void> getIsDeliveryOrderAllowed() async {
    log("inside getIsDeliveryOrderAllowed checkOut Controller ");
    await apiController.getIsDeliveryOrderAllowed();
  }

  Future<void> getUserInfoAndAddressForCheckout({bool shouldFactorInUserId = false}) async {
    if (shouldFactorInUserId && authController.userData.value.id.isEmpty) return;
    /* + Might wanna make sure to not remove all data when moving back from checkout page to not call this function every time
     + because currently it is getting called every time as the checks heavily depend upon the checkoutUserInfo which gets cleared
     + so these checks always result in true, and probably added some time to the final time it takes.  + */
    // log("checkoutUserInfo.value.toJson(): ${checkoutUserInfo.value.toJson()}");
    // log("checkoutUserInfo.value.name.isEmpty: ${checkoutUserInfo.value.name.isEmpty}");
    // log("checkoutUserInfo.value.name != nameController.text: ${checkoutUserInfo.value.name != nameController.text}");
    // log("checkoutUserInfo.value.email != emailController.text: ${checkoutUserInfo.value.email != emailController.text}");
    // log("checkoutUserInfo.value.phoneNumber.isEmpty: ${checkoutUserInfo.value.phoneNumber.isEmpty}");
    // log("checkoutUserInfo.value.phoneNumber != phoneController.text: ${checkoutUserInfo.value.phoneNumber != phoneController.text}");
    // log("checkoutUserInfo.value.address.isEmpty: ${checkoutUserInfo.value.address.isEmpty}");
    // log("checkoutUserInfo.value.address != addressController.text: ${checkoutUserInfo.value.address != addressController.text}");
    if (checkoutUserInfo.value.name.isEmpty ||
        checkoutUserInfo.value.name != nameController.text ||
        checkoutUserInfo.value.email != emailController.text ||
        checkoutUserInfo.value.phoneNumber.isEmpty ||
        checkoutUserInfo.value.phoneNumber != phoneController.text ||
        checkoutUserInfo.value.address.isEmpty ||
        checkoutUserInfo.value.address != addressController.text) {
      log("inside that getUserInfoAndAddressForCheckout if which checks if the values are changed and calls the method again accordingly");
      bool isSuccess = await apiController.getUserInfoAndAddressForCheckout();
      if (!isSuccess) {
        return;
      }
    }
    nameController.text = checkoutUserInfo.value.name;
    phoneController.text = formatUsPhoneNumber(checkoutUserInfo.value.phoneNumber) ?? checkoutUserInfo.value.phoneNumber;
    addressController.text = checkoutUserInfo.value.address;
    /* + new main fields + */

    if (orderType.value == "delivery") {
      fullAddressController.text = checkoutUserInfo.value.completeAddress;
      suiteAptController.text = checkoutUserInfo.value.neighborhood;
      /* */
      neighborhoodController.text = checkoutUserInfo.value.neighborhood;
      houseController.text = checkoutUserInfo.value.house;
      buildingNameController.text = checkoutUserInfo.value.building;
      zipController.text = checkoutUserInfo.value.zipcode;
      cityController.text = checkoutUserInfo.value.city;
      stateController.text = checkoutUserInfo.value.state;
      addressLat = double.tryParse(checkoutUserInfo.value.latitudeCustomer) ?? 0.0;
      addressLng = double.tryParse(checkoutUserInfo.value.longitudeCustomer) ?? 0.0;
      await apiController.getDistanceAndDeliveryFeeForCheckout();
    }
    // selectedState.value = states.firstWhereOrNull((state) => state.name.toLowerCase() == checkoutUserInfo.value.state.toLowerCase())?.name ?? "";
  }

  clearMembershipDiscountData() {
    membershipCardController.clear();
    membershipCardPercentageForOrder = 0.0;
    membershipCardTypeForOrder = "";
    membershipCardNoApplied = "";
  }

  clearSpDiscountData() {
    spDiscountCodeController.clear();
    spDiscountCodeApplied = "";
    sPDiscountPercentageForOrder = 0.0;
  }

  clearCouponDiscountData() {
    couponCodeController.clear();
    couponCodeApplied = "";
    isCouponDiscountAppliedAtCheckout = false;
    couponPercentageForOrder.value = 0.0;
  }

  clearTips() {
    tipPercentage.value = 0.0;
    driverTipPercentage.value = 0.0;
    tipTotal.value = 0.0;
    tipPointsTotal.value = 0.0;
    driverTipTotal.value = 0.0;
    driverTipPointsTotal.value = 0.0;
  }

  clearAll() {
    // tipPercentage.value = 0.0;
    selectedPaymentType.value = "";
    selectedState.value = "";
    cardToken = "";
    addressLat = 0.0;
    addressLng = 0.0;
    deliveryFeeTotal.value = 0.0;
    deliveryFeePointsTotal.value = 0.0;
    isPaymentStripeSelected.value = false;
    isOrderDeliverable.value = false;
    orderType.value = "pickup";
    states.clear();
    fullAddressController.clear();
    suiteAptController.clear();
    houseController.clear();
    buildingNameController.clear();
    addressController.clear();
    // streetNameController.clear();
    neighborhoodController.clear();
    cityController.clear();
    stateController.clear();
    zipController.clear();
    deliverNoteController.clear();
    checkoutGiftCardController.clear();
    checkoutGiftPinController.clear();
    giftCardController.myGiftCardDetails.value = GiftCardDetails();
    stripeNameController.clear();
    stripeCardController.clear();
    stripeCVVController.clear();
    stripeExpiryMonthController.clear();
    stripeExpiryYearController.clear();
    checkoutUserInfo.value = CheckoutUserInfo();
    deliveryFeeInfo.value = DeliveryFeeInfoModel();
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    // getDiscountedPayableTotal();
  }
}
