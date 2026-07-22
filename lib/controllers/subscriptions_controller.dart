import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/my_orders_model.dart';
import 'package:sanmiwago_user/models/signup_referral_offer_models/signup_referral_offer_model.dart';
import 'package:sanmiwago_user/models/subscription_models/my_subscription_model.dart';
import 'package:sanmiwago_user/models/subscription_models/subscription_offers_model.dart';

class SubscriptionsController extends GetxController {
  static SubscriptionsController instance = Get.find<SubscriptionsController>();

  RxList<SubscriptionOffer> subscriptionOffers = RxList<SubscriptionOffer>.from([]);
  // SubscriptionOffer selectedSignupReferralOffers = SubscriptionOffer();

  RxList<SignupReferralOffer> signupReferralOffers = RxList<SignupReferralOffer>.from([]);
  RxList<SubscriptionOffer> subscriptionOffersForAllRestaurants = RxList<SubscriptionOffer>.from([]);
  RxList<MySubscription> mySubscriptionsList = RxList<MySubscription>.from([]);

  // RxList<MySubscriptionOrder> mySubscriptionOrders = RxList<MySubscriptionOrder>.from([]);
  RxList<MyOrder> mySubscriptionOrders = RxList<MyOrder>.from([]);

  // RxList<MenuItem> mySubscriptionsOfferItems = RxList<MenuItem>.from([]);
  RxList<OfferProduct> mySubscriptionsOfferProducts = RxList<OfferProduct>.from([]);

  String selectedOfferId = "";
  RxString selectedOptionId = "".obs;
  String selectedOfferDuration = "";
  String selectedOfferAmount = "";
  String paymentMethod = "stripe";

  final GlobalKey<FormState> stripeFormKey = GlobalKey<FormState>();
  final TextEditingController stripeNameController = TextEditingController();
  final TextEditingController stripeCardController = TextEditingController();
  final TextEditingController stripeCVVController = TextEditingController();
  final TextEditingController stripeExpiryMonthController = TextEditingController();
  final TextEditingController stripeExpiryYearController = TextEditingController();

  Rx<MenuItem> selectedOfferItem = MenuItem().obs;

  // OfferProduct selectedOfferProduct = OfferProduct();

  final TextEditingController noteController = TextEditingController();

  RxList<String> selectedAddonIds = RxList<String>.from([]);

  selectAddon(String addonId, MenuItem item) {
    MenuItemAddon addon = item.addons.firstWhere((element) => element.addonId == addonId, orElse: () => MenuItemAddon());
    if (selectedAddonIds.contains(addonId)) {
      selectedAddonIds.remove(addonId);
    } else {
      selectedAddonIds.add(addonId);
    }
  }

  selectOption(String optionId) {
    if (selectedOptionId.value.isEmpty || (selectedOptionId.value.isNotEmpty && selectedOptionId.value != optionId)) {
      selectedOptionId.value = optionId;
    } else {
      selectedOptionId.value = "";
    }
    selectedOfferItem.value = selectedOfferItem.value.copyWith(
      options: selectedOptionId.value.isNotEmpty
          ? [
              selectedOfferItem.value.offerOptions.firstWhere(
                (element) => element.optionId == selectedOptionId.value,
              ),
            ]
          : [],
    );
  }

  Future<SubscriptionOffer?> getSpecificSignupReferralOffer(String offerId) async {
    return await apiController.getSpecificSignupReferralOffer(offerId);
  }

  Future<void> getSignupReferralOffers() async {
    await apiController.getSignupReferralOffersForMe();
  }

  Future<void> getSubscriptionOffers() async {
    await apiController.getSubscriptionOffers();
  }

  Future<void> getSubscriptionOffersForAllRestaurants() async {
    await apiController.getSubscriptionOffersForAllRestaurants();
  }

  Future<void> createSubscription() async {
    // showCircularLoading(isDismissible: false);
    await apiController.createSubscription();
    // dismissLoading();
  }

  Future<void> getMySubscriptions() async {
    await apiController.getMySubscriptions();
  }

  Future<void> getMySubscriptionOrders() async {
    await apiController.getMySubscriptionOrders();
  }

  setSelectedOfferData(SubscriptionOffer offer) {
    selectedOfferId = offer.offerId;
    selectedOfferDuration = offer.offerDurations;
    selectedOfferAmount = offer.offerCost;
  }

  getSubscriptionOfferItems(String offerId, {bool callGetSubOffers = true}) async {
    mySubscriptionsOfferProducts.clear();
    log("offerId to check $offerId");
    if (callGetSubOffers) await getSubscriptionOffers();
    if (subscriptionOffersForAllRestaurants.isEmpty) await getSubscriptionOffersForAllRestaurants();
    SubscriptionOffer filteredOffer = subscriptionOffersForAllRestaurants.firstWhereOrNull((offer) => offer.offerId == offerId) ?? SubscriptionOffer();
    if (filteredOffer.offerId.isNotEmpty && filteredOffer.offerProducts.isNotEmpty) {
      mySubscriptionsOfferProducts.value = filteredOffer.offerProducts.map((product) => product).toList();
    }
  }

  placeSubscriptionOfferItemsOrder({required String offerId, required String offerRestaurantId, bool isSignupOfferOrder = false}) async {
    selectedOfferItem.value = selectedOfferItem.value.copyWith(
      note: noteController.text.trim(),
    );
    await apiController.buyItemsFromSubscriptionOffer(
      offerId: offerId,
      offerRestaurantId: offerRestaurantId,
      isSignupOfferOrder: isSignupOfferOrder,
    );
  }

  clearAll() {
    selectedOfferId = "";
    selectedOfferDuration = "";
    selectedOfferAmount = "";
    selectedOptionId.value = "";
    paymentMethod = "stripe";

    stripeNameController.clear();
    stripeCardController.clear();
    stripeCVVController.clear();
    stripeExpiryMonthController.clear();
    stripeExpiryYearController.clear();
    // apiController.isCreatingSubscription.value = false;
  }

  clearItemDetailsData() {
    noteController.clear();
    selectedAddonIds.clear();
    selectedOptionId.value = "";
  }

  clearOrderData() {
    clearItemDetailsData();
    selectedOfferItem.value = MenuItem();
  }
}
