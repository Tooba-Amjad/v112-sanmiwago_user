import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/api_constants.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/constants/my_logger.dart';
import 'package:sanmiwago_user/data/local_db.dart';
import 'package:sanmiwago_user/data/shared_pref.dart';
import 'package:sanmiwago_user/models/category_model.dart';
import 'package:sanmiwago_user/models/checking_delivery_order_model.dart';
import 'package:sanmiwago_user/models/delivery_fee_model.dart';
import 'package:sanmiwago_user/models/doordash_order_view_model.dart';
import 'package:sanmiwago_user/models/gift_card_models/gift_card_details_model.dart';
import 'package:sanmiwago_user/models/gift_card_models/gift_card_model.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';
import 'package:sanmiwago_user/models/membership_models/membership_category_model.dart';
import 'package:sanmiwago_user/models/membership_models/user_membership_details.dart';
import 'package:sanmiwago_user/models/my_orders_model.dart';
import 'package:sanmiwago_user/models/my_points_model.dart';
import 'package:sanmiwago_user/models/my_referral_models/my_referral_order_model.dart';
import 'package:sanmiwago_user/models/my_referral_models/my_referred_user_model.dart';
import 'package:sanmiwago_user/models/order_view_model.dart';
import 'package:sanmiwago_user/models/restaurant_model.dart';
import 'package:sanmiwago_user/models/signup_referral_offer_models/signup_referral_offer_model.dart';
import 'package:sanmiwago_user/models/site_model.dart';
import 'package:sanmiwago_user/models/subscription_models/my_subscription_model.dart';
import 'package:sanmiwago_user/models/subscription_models/subscription_offers_model.dart';
import 'package:sanmiwago_user/models/user_model/user_promotions_model.dart';
import 'package:sanmiwago_user/services/base_client.dart';
import 'package:sanmiwago_user/services/base_controller_mixin.dart';
import 'package:sanmiwago_user/services/pusher/pusher_service.dart';
import 'package:sanmiwago_user/utils/device_info.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/formatters/us_phone_number_formatter.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:sanmiwago_user/views/pages/order_placed_result/waiting_page.dart';
import 'package:sanmiwago_user/views/pages/giftcard/giftcard_history_page.dart';
import 'package:sanmiwago_user/views/pages/login/login_page.dart';

import '../models/checkout_user_info_model.dart';
import '../models/state_model.dart';
import '../services/notification_service.dart';
import '../views/pages/signup/activate_account.dart';

class ApiController extends GetxController with BaseController {
  static ApiController instance = Get.find<ApiController>();

  RxBool isLoadingRestaurants = false.obs;
  RxBool isLoadingCategories = false.obs;
  RxBool isLoadingItems = false.obs;
  RxBool isLoadingItemOptions = false.obs;
  RxBool isLoadingItemAddons = false.obs;
  RxBool isGettingCardToken = false.obs;
  RxBool isPlacingOrder = false.obs;
  RxBool isLoadingDetails = false.obs;
  RxBool isLoadingMyOrders = true.obs;

  ///  Using the isLoadingMyOrdersSimple because the other one (isLoadingMyOrders) has to be kept true so that
  ///  in case when loading the next page of records, the loading still comes and it does not show
  ///  No records found at the end of the list unless there actually aren't any left
  bool isLoadingMyOrdersSimple = false;
  RxBool isLoadingMyOrderDetails = false.obs;
  RxBool isLoadingDoorDashOrderDetails = false.obs;
  RxBool isLoadingMyReferralOrders = true.obs;
  RxBool isLoadingMyReferredUsers = false.obs;
  RxBool isLoadingMyPoints = true.obs;

  RxBool isSigningUp = false.obs;
  RxBool isLoadingUpdatedProfileData = false.obs;
  RxBool isUpdatingProfile = false.obs;
  RxBool isUpdatingProfileImage = false.obs;
  RxBool isUpdatingPassword = false.obs;
  RxBool isResendingActivationEmail = false.obs;
  RxBool isLoadingUserPoints = false.obs;
  RxBool isLoadingCheckingDeliveryOrderAllowed = false.obs;
  RxBool isLoadingStates = false.obs;
  RxBool isLoadingDefaultGiftcardRestaurantId = false.obs;
  RxBool isLoadingUserInfoForCheckout = false.obs;
  RxBool isLoadingDistanceAndDeliveryFeeForCheckout = false.obs;

  RxBool isBuyingGiftCard = false.obs;
  RxBool isReloadingGiftCard = false.obs;
  RxBool isLoadingGiftCards = false.obs;
  RxBool isCheckingGiftCardBalance = false.obs;
  RxBool isSendingRecoveryGiftCardDataForOTP = false.obs;
  RxBool isVerifyingOTPForGiftCard = false.obs;
  RxBool isResendingOTPForGiftCard = false.obs;

  RxBool isLoadingSubscriptionOffers = false.obs;
  RxBool isLoadingSubscriptionOffersForAllRestaurants = false.obs;

  RxBool isLoadingSignupReferralOffers = false.obs;
  RxBool isLoadingSpecificSignupReferralOffer = false.obs;

  RxBool isCreatingSubscription = false.obs;
  RxBool isCancelingSubscription = false.obs;
  RxBool isStoppingAutoRenewalOfSubscription = false.obs;
  RxBool isLoadingMySubscriptions = false.obs;
  RxBool isLoadingMySubscriptionOrders = false.obs;
  RxBool isBuyingItemsFromSubscriptionOffer = false.obs;

  RxBool isBuyingMembershipAsStranger = false.obs;
  RxBool isBuyingMembershipAsMember = false.obs;
  RxBool isLoadingMembershipCategories = false.obs;
  RxBool isLoadingMembershipDetails = false.obs;
  RxBool isLoadingMembershipCardDetails = false.obs;
  RxBool isLoadingSPDiscountCodeDetails = false.obs;
  RxBool isLoadingCouponCodeDetails = false.obs;
  RxBool isLoadingUserPromos = false.obs;
  RxBool isDeletingUser = false.obs;
  RxBool isSubmittingContactForm = false.obs;
  RxBool isLoadingTermsHtml = false.obs;
  RxBool isLoadingPrivacyHtml = false.obs;

  //+ get restaurants list
  /// Gets Restaurants List for changing menu based on the selected restaurant
  Future<void> getRestaurants() async {
    log("In getRestaurants");
    WidgetsBinding.instance.addPostFrameCallback((time) {
      isLoadingRestaurants.value = true;
      restaurantController.restaurants.clear();
    });
    var response = await BaseClient().get(ApiConstants.baseUrl, ApiConstants.restaurantsListEndpoint).catchError((e) {
      handleError(
        e,
        onError: () {
          getRestaurants();
          // isLoadingRestaurants.value = false;
          // showMsg(msg: "Something went wrong. Please refresh this page.");
        },
      );
    });

    if (response == null) return;

    // log("response is $response");
    // String result = response['responce']['status'];

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      List restaurantsList = response["data"];

      for (var v in restaurantsList) {
        Restaurant restaurant = Restaurant.fromJson(v);
        if (restaurant.status.toLowerCase() == "active" && restaurant.resType.toLowerCase() == "simple") restaurantController.restaurants.add(restaurant);
      }
      if (restaurantController.restaurants.isNotEmpty) {
        if (LocalSharedPrefDatabase.getSelectedBranchId() != null) {
          Restaurant? rest = restaurantController.restaurants.firstWhereOrNull((element) => element.id == LocalSharedPrefDatabase.getSelectedBranchId());
          if (rest != null) {
            restaurantController.updateSelectedRestaurant(rest.id, rest.address, rest.phone, restaurant: rest, isFromBottomNavBarPage: true);
          }
        }
      }
      // restaurantController.selectFirstRestaurant();
    } else {
      // showMsg(msg: "Something wrong please refresh the page to try again");
      log("problem while fetching the restaurants");
    }
    isLoadingRestaurants.value = false;
  }

  //+ get categories or menu
  /// Gets Categories/Menu List for home screen
  Future<void> getCategories() async {
    // showCircularLoading();
    errorLog("In getCategories");
    isLoadingCategories.value = true;
    // catItemController.categories.clear();
    var response = await BaseClient()
        .post(
          ApiConstants.baseUrl,
          ApiConstants.menuListEndpoint,
          restaurantController.selectedRestaurantId.value.isNotEmpty || restaurantController.selectedRestaurantId.value != "1"
              ? {"restaurant_id": restaurantController.selectedRestaurantId.value}
              : {},
        )
        .catchError((e) {
          handleError(
            e,
            onError: () {
              isLoadingCategories.value = false;
              catItemController.categories.clear();
              showMsg(msg: "Something went wrong. Please refresh this page.");
            },
          );
        });

    if (response == null) return;

    // log("response is $response");
    // String result = response['responce']['status'];

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      List categoryListFetched = response["data"];
      List<MenuCategory> categoryListModeled = [];
      String imgBasePath = response["img_base_path"];
      log("imgBasePath: $imgBasePath");
      for (var v in categoryListFetched) {
        MenuCategory category = MenuCategory.fromJson(v);
        if (category.menuImageName.isNotEmpty) {
          category = category.copyWith(menuImageName: "$imgBasePath${category.menuImageName}");
        }
        // log("category is now: ${category.toJson()}");
        if (category.status.toLowerCase() == "active" && category.itemCount != "0") categoryListModeled.add(category);
      }
      catItemController.categories.assignAll(categoryListModeled);
      catItemController.selectFirstCategory();
      // await LocalHiveDatabase.saveSiteData(siteData);
    } else {
      // dismissLoading();
      catItemController.categories.clear();
      showMsg(msg: "No menu found for this branch");
    }
    isLoadingCategories.value = false;
  }

  //+ get items
  /// Gets Items for a selected Category/Menu
  Future<void> getItems({bool showNoItemsMsg = true}) async {
    // showCircularLoading();
    isLoadingItems.value = true;
    // catItemController.currentCategoryItems.clear();
    // errorLog("In getItems");
    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.itemListEndpoint, {
          "menu_id": catItemController.selectedMenuId,
          "restaurant_id": restaurantController.selectedRestaurantId.value,
        })
        .catchError((e) {
          handleError(
            e,
            onError: () {
              isLoadingItems.value = false;
              catItemController.currentCategoryItems.clear();
              showMsg(msg: "Something went wrong. Please refresh the page or try another category.");
            },
          );
        });

    if (response == null) return;

    // log("response is $response");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    try {
      if (result == "success") {
        List itemListFetched = response["data"];
        List<MenuItem> itemListModeled = [];
        String imgBasePath = response["img_base_path"];
        log("imgBasePath: $imgBasePath");
        for (var v in itemListFetched) {
          MenuItem item = MenuItem.fromJson(v);
          if (item.itemImageName.isNotEmpty) {
            item = item.copyWith(itemImageName: "$imgBasePath${item.itemImageName}");
          }
          // log("item is now: ${item.toJson()}");
          // catItemController.currentCategoryItems.clear(); //+New added By Saif

          if (item.status.toLowerCase() == "active") {
            itemListModeled.add(item);
          }
        }
        catItemController.currentCategoryItems.assignAll(itemListModeled);

        // await LocalHiveDatabase.saveSiteData(siteData);
      } else {
        // dismissLoading();
        catItemController.currentCategoryItems.clear();
        if (showNoItemsMsg) showMsg(msg: "No items found for this category");
      }
    } catch (e) {
      errorLog("error in getItems catch $e");
      showMsg(msg: "Something wrong please refresh the page to try again");
    }
    isLoadingItems.value = false;
  }

  //+ get item options
  /// Gets Items Options for a selected Item to show on Item Details Page
  Future<void> getItemOptions() async {
    isLoadingItemOptions.value = true;

    errorLog("In getItemOptions");
    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.itemOptionsEndpoint, {"item_id": catItemController.selectedItem.value.itemId}).catchError((
      e,
    ) {
      handleError(
        e,
        onError: () {
          isLoadingItemOptions.value = false;
          showMsg(msg: "Something went wrong. Please open this item again.");
        },
      );
    });

    if (response == null) return;

    log("response in getItemOptions is $response");
    // String result = response['responce']['status'];

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    try {
      if (result == "success") {
        List optionsList = response["data"];

        List<MenuItemOption> optionsModeledList = List.from(optionsList.map((e) => MenuItemOption.fromJson(e)).toList());

        catItemController.selectedItem.value = catItemController.selectedItem.value.copyWith(options: optionsModeledList);

        // await LocalHiveDatabase.saveSiteData(siteData);
      } else {
        // showMsg(msg: "No options found for this item");
        log("No options found for this item");
      }
    } catch (e) {
      errorLog("error in getItemOptions catch $e");
      showMsg(msg: "Something went wrong. Please open the item details again.");
    }
    isLoadingItemOptions.value = false;
  }

  //+ get item addons
  /// Gets Items Addons for a selected Item to show on Item Details Page
  Future<void> getItemAddons() async {
    isLoadingItemAddons.value = true;

    errorLog("In getItemAddons");
    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.itemAddonsEndpoint, {"item_id": catItemController.selectedItem.value.itemId}).catchError((
      e,
    ) {
      handleError(
        e,
        onError: () {
          isLoadingItemAddons.value = false;
          showMsg(msg: "Something went wrong. Please open this item again.");
          // showMsg(
          //   msg: "Something went wrong while fetching Item Addons and Options. "
          //       "Please make sure you have a stable internet connection and try again by coming back to this screen.",
          //   time: const Duration(seconds: 4),
          // );
        },
      );
    });

    if (response == null) return;

    log("response in getItemAddons is $response");
    // String result = response['responce']['status'];

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    // try {
    if (result == "success") {
      // List<Map<String, dynamic>> tempAddonsList = response["data"].toList();
      // List addonsList = tempAddonsList.map((addonTop) {
      //   String catName = addonTop["category_name"];
      //   List<Map<String, dynamic>> addonsList = addonTop["category_name"];
      //   return addonsList.map((addon) {
      //     var addonTemp = addon;
      //     addonTemp.addAll({
      //       "category_name": catName,
      //     });
      //     return addonTemp;
      //   });
      // }).toList();

      List tempAddonsList = response["data"];
      List<Map<String, dynamic>> addonsList = [];

      for (Map<String, dynamic> addonTop in tempAddonsList) {
        String catName = addonTop["category_name"];
        List<Map<String, dynamic>> addons = List<Map<String, dynamic>>.from(addonTop["addons"]);

        // Iterate over each addon and add the category name to it
        for (var addon in addons) {
          log("addon[\"status\"].: ${addon["status"]}");
          if (addon["status"].toString().toLowerCase() != "active") continue;
          addon.addAll({
            "category_name": catName,
            // "item_id": catItemController.selectedItem.value.itemId,
          });
          addonsList.add(addon); // Add modified addon to the final list
        }
      }

      List<MenuItemAddon> addonsModeledList = List.from(addonsList.map((e) => MenuItemAddon.fromJson(e)).toList());

      catItemController.selectedItem.value = catItemController.selectedItem.value.copyWith(addons: addonsModeledList);

      // await LocalHiveDatabase.saveSiteData(siteData);
    } else {
      // showMsg(msg: "No addons found for this item");
      log("No addons found for this item");
    }
    // } catch (e) {
    //   errorLog("error in getItemAddons catch $e");
    //   showMsg(msg: "Something went wrong. Please open this item again.");
    // }
    isLoadingItemAddons.value = false;
  }

  //+ get states
  /// Gets states for Checkout page
  Future<void> getStates() async {
    infoLog("In getStates");
    isLoadingStates.value = true;

    var response = await BaseClient().get(ApiConstants.baseUrl, ApiConstants.statesListEndpoint).catchError((error) {
      handleError(error);
      isLoadingStates.value = false;
      showMsg(
        msg:
            "Unable to fetch states where we deliver. "
            "Please try again by coming back to this screen again or contact the restaurant.",
        time: const Duration(seconds: 4),
      );
      // getStates(); // we should either show the message or should keep trying
    });

    if (response == null) return;

    log("response in getStates is $response");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      List tempList = [];
      tempList = response["data"];
      for (var state in tempList) {
        checkoutController.states.add(LocationState.fromJson(state));
      }
    } else {
      errorLog("Error in fetching states: $response");
      // showMsg(msg: "${response["error"]["code"].toString().replaceAll("_", " ").capitalizeFirst}");
      showMsg(msg: "${response["responce"]["message"]}");
    }
    isLoadingStates.value = false;
  }

  //+ get user info
  /// Gets user info for Checkout page
  Future<bool> getUserInfoAndAddressForCheckout() async {
    infoLog("In getUserInfoAndAddressForCheckout");
    if (authController.userData.value.id.isEmpty && checkoutController.emailController.text.trim().isEmpty) return false;
    isLoadingUserInfoForCheckout.value = true;

    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.userInfoAndAddressEndpoint, {
          "email": authController.userData.value.id.isNotEmpty ? authController.userData.value.email : checkoutController.emailController.text.trim(),
          "type": checkoutController.orderType.value,
        })
        .catchError((error) {
          handleError(error);
          isLoadingUserInfoForCheckout.value = false;
          return false;
          // showMsg(
          //   msg: "Unable to fetch user data for the given email. "
          //       "Please try again by coming back to this screen again or contact the restaurant.",
          //   time: const Duration(seconds: 4),
          // );
          // getStates(); // we should either show the message or should keep trying
        });

    if (response == null) return false;

    log("response in getUserInfoAndAddressForCheckout is $response");

    String result = response.containsKey("status") ? response["status"] : "error";

    if (result == "success") {
      checkoutController.checkoutUserInfo.value = CheckoutUserInfo.fromJson(response);
      checkoutController.checkoutUserInfo.value = checkoutController.checkoutUserInfo.value.copyWith(
        email: authController.userData.value.id.isNotEmpty ? authController.userData.value.email : checkoutController.emailController.text.trim(),
      );

      log("fetched checkout user info is: ${checkoutController.checkoutUserInfo.value.toJson()}");
      isLoadingUserInfoForCheckout.value = false;
      return true;
    } else {
      errorLog("Error in fetching checkout user info: $response");
      // showMsg(msg: "${response["error"]["code"].toString().replaceAll("_", " ").capitalizeFirst}");
      // showMsg(msg: "${response["message"] ?? "Something went wrong."}");
      isLoadingUserInfoForCheckout.value = false;
      return false;
    }
  }

  //+ get distance and delivery fee
  /// Gets user info for Checkout page
  Future<void> getDistanceAndDeliveryFeeForCheckout({bool shouldDismissLoading = false}) async {
    infoLog("In getDistanceAndDeliveryFeeForCheckout");
    if (authController.userData.value.id.isEmpty && checkoutController.emailController.text.trim().isEmpty) return;
    isLoadingDistanceAndDeliveryFeeForCheckout.value = true;

    Map<String, dynamic> data = {
      "latitude_customer": checkoutController.addressLat.toString(),
      "longitude_customer": checkoutController.addressLng.toString(),
      "restaurant_id": restaurantController.selectedRestaurantId.value,
      "total_pay": (orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) - orderController.discount.value)
          .toPrecision(2)
          .toStringAsFixed(2),
      "sale_tax":
          (((orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) - orderController.discount.value) / 100) *
                  siteDataController.salesTax.value)
              .toPrecision(2)
              .toStringAsFixed(2),
      "dropoff": checkoutController.fullAddressController.text,
    };

    if (authController.isLoggedIn.value) {
      data.putIfAbsent("cartpage", () => "cartpage");
    }

    log("data in encoded form is: ${jsonEncode(data)}");

    var response = await BaseClient()
        .post(
          ApiConstants.baseUrl,
          ApiConstants.distanceAndDeliveryFeeEndpoint,
          data,
          // shouldEncode: true,
        );
        // .catchError((error) {
        //   handleError(error);
        //   if (shouldDismissLoading) dismissLoading();
        //   isLoadingDistanceAndDeliveryFeeForCheckout.value = false;
        //   // showMsg(
        //   //   msg: "Unable to fetch user data for the given email. "
        //   //       "Please try again by coming back to this screen again or contact the restaurant.",
        //   //   time: const Duration(seconds: 4),
        //   // );
        //   // getStates(); // we should either show the message or should keep trying
        // });
    log("response in getDistanceAndDeliveryFeeForCheckout is $response");


    if (response == null) return;

    log("response in getDistanceAndDeliveryFeeForCheckout is $response");

    String result = response.containsKey("status") ? response["status"] : "error";

    if (result == "success" && double.tryParse(response["doordash_delivery_fee"].toString()) != null) {
      checkoutController.deliveryFeeInfo.value = DeliveryFeeInfoModel.fromJson(response);
      log("fetched checkout delivery info is: ${checkoutController.deliveryFeeInfo.value.toJson()}");
      checkoutController.deliveryFeePointsTotal.value = checkoutController.deliveryFeeInfo.value.reqPoints.toDouble();
      checkoutController.deliveryFeeTotal.value = checkoutController.deliveryFeeInfo.value.doordashDeliveryFee;
      checkoutController.isOrderDeliverable.value = (checkoutController.deliveryFeeInfo.value.statusfee == 0);
      if (shouldDismissLoading) dismissLoading();
    } else {
      errorLog("Error in fetching checkout delivery info: $response");
      // showMsg(msg: "${response["error"]["code"].toString().replaceAll("_", " ").capitalizeFirst}");
      /* + still setting values for the sake of UI and will use these in the UI to show appropriate message and disable Pay button if need be. + */
      checkoutController.deliveryFeeInfo.value = DeliveryFeeInfoModel.fromJson(response); // sets default as 0.0 and we'll use that as a check.
      log("fetched checkout delivery info is: ${checkoutController.deliveryFeeInfo.value.toJson()}");
      checkoutController.deliveryFeePointsTotal.value = checkoutController.deliveryFeeInfo.value.reqPoints.toDouble();
      checkoutController.deliveryFeeTotal.value = checkoutController.deliveryFeeInfo.value.doordashDeliveryFee;
      checkoutController.isOrderDeliverable.value = (checkoutController.deliveryFeeInfo.value.statusfee == 0);
      log("isOrderDeliverable: ${checkoutController.isOrderDeliverable.value}");
      if (shouldDismissLoading) dismissLoading();
      showMsg(msg: getDeliveryInfoMessage(response));
    }
    isLoadingDistanceAndDeliveryFeeForCheckout.value = false;
  }

  Future<String?> getActivatedGiftcardRestaurantId() async {
    infoLog("In getActivatedGiftcardRestaurantId");
    isLoadingDefaultGiftcardRestaurantId.value = true;

    try {
      var response = await BaseClient().get(ApiConstants.baseUrl, ApiConstants.getDefaultGiftcardRestaurantEndpoint).catchError((error) {
        handleError(error);
        isLoadingDefaultGiftcardRestaurantId.value = false;
        showMsg(
          msg: "Unable to process your request right now.",
          // time: const Duration(seconds: 4),
        );
        // getStates(); // we should either show the message or should keep trying
      });

      if (response == null) return null;

      log("response in getActivatedGiftcardRestaurantId is $response");

      String result = response.containsKey("status") ? response["status"] : "error";

      if (result == "success" && response["giftcard_account"] != false) {
        String? rId = response["giftcard_account"]?['restaurant_id'];
        return rId;
      } else {
        errorLog("Error in fetching states: $response");
        showMsg(msg: "Something went wrong. There seems to be an issue on our end. Please try again in some time or contact us if it still does not work.");
      }
      isLoadingDefaultGiftcardRestaurantId.value = false;
      return null;
    } catch (e) {
      log("error in getActivatedGiftcardRestaurantId catch $e");
      isLoadingDefaultGiftcardRestaurantId.value = false;
      return null;
    } finally {
      isLoadingDefaultGiftcardRestaurantId.value = false;
    }
  }

  //+ get card token
  /// Gets card token from stripe
  //+ get card token
  /// Gets card token from stripe
  Future<String> getCardToken({bool dismissLoadingAtError = false, bool isForGiftcard = false, bool isForMembership = false, bool overrideRestaurantId = false}) async {
    infoLog("In getCardToken");
    isGettingCardToken.value = true;
    String? overriddenRId;

    if (isForGiftcard || overrideRestaurantId) {
      overriddenRId = await getActivatedGiftcardRestaurantId();
      log("overriddenRId: $overriddenRId");
      if (overriddenRId == null) {
        log("overriddenRId was null");
        isGettingCardToken.value = false;
        return "";
      }
    }

    String cardToken = "";
    var response = await BaseClient()
        .post(
          isStripe: true,
          // headers: {
          //   "Authorization": "Bearer $stripeKey",
          //   "Content-Type": "application/x-www-form-urlencoded",
          // },
          ApiConstants.baseUrl,
          ApiConstants.cardTokenEndpoint,
          {
            "restaurant_id": (isForGiftcard || overrideRestaurantId) ? overriddenRId : restaurantController.selectedRestaurantId.value,
            "card_number": isForGiftcard
                ? giftCardController.stripeCardController.text.trim()
                : isForMembership
                ? membershipController.stripeCardController.text.trim()
                : checkoutController.stripeCardController.text.trim(),
            "exp_month": isForGiftcard
                ? giftCardController.stripeExpiryMonthController.text.trim()
                : isForMembership
                ? membershipController.stripeExpiryMonthController.text.trim()
                : checkoutController.stripeExpiryMonthController.text.trim(),
            "exp_year": isForGiftcard
                ? giftCardController.stripeExpiryYearController.text.trim()
                : isForMembership
                ? membershipController.stripeExpiryYearController.text.trim()
                : checkoutController.stripeExpiryYearController.text.trim(),
            "cvc": isForGiftcard
                ? giftCardController.stripeCVVController.text.trim()
                : isForMembership
                ? membershipController.stripeCVVController.text.trim()
                : checkoutController.stripeCVVController.text.trim(),
          },
        )
        .catchError((e) {
          handleError(
            e,
            onError: () {
              isGettingCardToken.value = false;
              return "";
            },
          );
        });

    if (response == null) return "";

    log("response in getCardToken is $response");

    String result = response["responce"]["data"].containsKey("id") ? "success" : "error";

    if (result == "success") {
      cardToken = response["responce"]["data"]["id"];
    } else {
      if (dismissLoadingAtError) dismissLoading(); //! this loading was opened in place-order
      errorLog("Error in fetching token: $response");
      // showMsg(msg: "${response["error"]["code"].toString().replaceAll("_", " ").capitalizeFirst}");
      showMsg(msg: "${response["responce"]["data"]["error"]["message"]}", time: const Duration(seconds: 3));
    }
    isGettingCardToken.value = false;
    return cardToken;
  }

  //+ place order
  /// Place order with stripe/points/giftcard
  Future<void> placeOrder({bool startLoading = true}) async {
    isPlacingOrder.value = true;

    errorLog("In placeOrder");
    if (startLoading) showCircularLoading(isDismissible: false);

    if (checkoutController.selectedPaymentType.value.toLowerCase() == "stripe" || checkoutController.selectedPaymentType.value == "hybrid") {
      checkoutController.cardToken = await getCardToken(dismissLoadingAtError: true, overrideRestaurantId: checkoutController.selectedPaymentType.value == "redeemGift");
      if (checkoutController.cardToken.isEmpty) {
        // dismissLoading();
        isPlacingOrder.value = false;
        return;
      }
    }

    Map<String, String> queryMap = {};
    String cardType = getCardType(checkoutController.stripeCardController.text.trim());
    log("cardType: $cardType");
    if (checkoutController.selectedPaymentType.value.toLowerCase() == "stripe") {
      queryMap.addAll({
        "card_type": getCardType(checkoutController.stripeCardController.text.trim()),
        "stripe_token": checkoutController.cardToken,
        "payment_type": checkoutController.selectedPaymentType.value.toLowerCase(),
        "strip_card_no": checkoutController.lastFour,
        // "card_number": checkoutController.stripeCardController.text.trim().replaceAll(" ", ""),
        // "card_cvv": checkoutController.stripeCVVController.text.trim(),
        // "card_exp_month": checkoutController.stripeExpiryMonthController.text.trim(),
        // "card_exp_year": checkoutController.stripeExpiryYearController.text.trim(),
        "total_earn_points": (checkoutController.isCouponDiscountAppliedAtCheckout && checkoutController.couponPercentageForOrder.value != 0.0)
            /* + discounted points + */
            ? (orderController.cartItems.fold(0.0, (previousValue, cartItem) => previousValue + ((double.tryParse(cartItem.itemPoints) ?? 0.0) * cartItem.itemCount)) *
                      (1 - (checkoutController.couponPercentageForOrder.value / 100)))
                  .floorToDouble()
                  .toPrecision(2)
                  .toStringAsFixed(2)
            /* + normal points + */
            : orderController.cartItems
                  .fold(0.0, (previousValue, cartItem) => previousValue + ((double.tryParse(cartItem.itemPoints) ?? 0.0) * cartItem.itemCount))
                  .toPrecision(2)
                  .toStringAsFixed(2),
      });
    } else if (checkoutController.selectedPaymentType.value == "redeemPoint") {
      queryMap.addAll({
        "payment_type": checkoutController.selectedPaymentType.value,
        "user_redeem_points": authController.userData.value.userPoints,
        "redeem_points":
            (orderController.cartItems.fold(
                      0.0,
                      (previousValue, cartItem) => previousValue + (cartItem.itemCount * (double.tryParse(cartItem.pointsToPurchase) ?? 0.0)),
                    ) +
                    checkoutController.tipPointsTotal.value +
                    checkoutController.driverTipPointsTotal.value +
                    checkoutController.deliveryFeePointsTotal.value)
                .toPrecision(0)
                .toStringAsFixed(0),
        "total_earn_points": "0",
      });
    } else if (checkoutController.selectedPaymentType.value == "redeemGift") {
      queryMap.addAll({
        "card_type": "RedeemGiftCard",
        "payment_type": checkoutController.selectedPaymentType.value,
        "gift_card_no": checkoutController.checkoutGiftCardController.text.trim(),
        "pin": checkoutController.checkoutGiftPinController.text.trim(),
        "redeem_gift_amount":
            (orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) +
                    orderController.calculatedSalesTax.value +
                    checkoutController.tipTotal.value +
                    checkoutController.driverTipTotal.value +
                    checkoutController.deliveryFeeTotal.value -
                    orderController.discount.value)
                .toPrecision(2)
                .toStringAsFixed(2),
        "total_earn_points": (checkoutController.isCouponDiscountAppliedAtCheckout && checkoutController.couponPercentageForOrder.value != 0.0)
            /* + discounted points + */
            ? (2 *
                      (orderController.cartItems.fold(
                            0.0,
                            (previousValue, cartItem) => previousValue + ((double.tryParse(cartItem.itemPoints) ?? 0.0) * cartItem.itemCount),
                          ) *
                          (1 - (checkoutController.couponPercentageForOrder.value / 100))))
                  .floorToDouble()
                  .toPrecision(2)
                  .toStringAsFixed(2)
            /* + normal points + */
            : (2 * orderController.cartItems.fold(0.0, (previousValue, cartItem) => previousValue + ((double.tryParse(cartItem.itemPoints) ?? 0.0) * cartItem.itemCount)))
                  .toDouble()
                  .toPrecision(2)
                  .toStringAsFixed(2),
        // "total_earn_points":
        //     (2 * orderController.cartItems.fold(0.0, (previousValue, cartItem) => previousValue + ((double.tryParse(cartItem.itemPoints) ?? 0.0) * cartItem.itemCount)))
        //         .toDouble()
        //         .toPrecision(2)
        //         .toStringAsFixed(2),
      });
    } else if (checkoutController.selectedPaymentType.value == "hybrid") {
      double giftCardBalance = double.tryParse(giftCardController.myGiftCardDetails.value.data?.totalAmount ?? "0.0") ?? 0.0;
      double cartTotal = (orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) + orderController.calculatedSalesTax.value)
          .toPrecision(2);
      double salesTax = ((orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) / 100) * siteDataController.salesTax.value);

      double cardAmount = (cartTotal - giftCardBalance - salesTax);
      log("cardAmount without sales tax: $cardAmount");
      queryMap.addAll({
        "stripe_token": checkoutController.cardToken,
        "strip_card_no": checkoutController.lastFour,
        "payment_type": checkoutController.selectedPaymentType.value.toLowerCase(),
        "gift_card_no": checkoutController.checkoutGiftCardController.text.trim(),
        "pin": checkoutController.checkoutGiftPinController.text.trim(),
        // "card_number": checkoutController.stripeCardController.text.trim().replaceAll(" ", ""),
        // "card_cvv": checkoutController.stripeCVVController.text.trim(),
        // "card_exp_month": checkoutController.stripeExpiryMonthController.text.trim(),
        // "card_exp_year": checkoutController.stripeExpiryYearController.text.trim(),
        /* */
        // "redeem_gift_amount": giftCardController.myGiftCardDetails.value.data?.totalAmount ?? "",
        // "card_amount": (cartTotal - giftCardBalance).toPrecision(2).toStringAsFixed(2),
        "total_earn_points": ((2 * giftCardBalance) + cardAmount).toPrecision(2).toStringAsFixed(2),
        // orderController.cartItems
        //     .fold(0.0, (previousValue, cartItem) => previousValue + ((double.tryParse(cartItem.itemPoints) ?? 0.0) * cartItem.itemCount))
        //     .toPrecision(2)
        //     .toStringAsFixed(2),
      });
    } else {
      dismissLoading();
      isPlacingOrder.value = false;
      showMsg(msg: "Please select a suitable payment method");
      return;
    }

    if (checkoutController.orderType.value == "pickup") {
      queryMap.addAll({"order_type": "pickup"});
    } else if (checkoutController.orderType.value == "delivery") {
      queryMap.addAll({
        "order_type": "delivery",
        "complete_address": checkoutController.fullAddressController.text.trim(),
        "house_no": checkoutController.houseController.text.trim(),
        "building": checkoutController.buildingNameController.text.trim(),
        "address": checkoutController.addressController.text.trim(),
        // "landmark": checkoutController.neighborhoodController.text.trim(),
        "landmark": checkoutController.suiteAptController.text.trim(),
        "state": checkoutController.stateController.text.trim(),
        "city": checkoutController.cityController.text.trim(),
        "zipcode": checkoutController.zipController.text.trim(),
        "latitude_customer": checkoutController.addressLat.toString(),
        "longitude_customer": checkoutController.addressLng.toString(),
        "delivery_note": checkoutController.deliverNoteController.text.trim(),
      });
    }

    if (checkoutController.isSPDiscountAppliedAtCheckout && checkoutController.sPDiscountPercentageForOrder != 0.0) {
      queryMap.addAll({
        "sp_discount_code": checkoutController.spDiscountCodeController.text.trim(),
        "sp_discount": orderController.discount.value.toPrecision(2).toStringAsFixed(2),
      });
    }

    if (checkoutController.isCouponDiscountAppliedAtCheckout && checkoutController.couponPercentageForOrder.value != 0.0) {
      queryMap.addAll({
        "coupon_percentage": checkoutController.couponPercentageForOrder.value.toPrecision(2).toStringAsFixed(2),
        "coupon_discount": orderController.discount.value.toPrecision(2).toStringAsFixed(2),
      });
    }

    queryMap.addAll({
      "fcm_token": NotificationService.instance.cachedFcmToken ?? "",
      "doordash_delivery_fee": (checkoutController.deliveryFeeTotal.value).toPrecision(2).toStringAsFixed(2),
      "doordash_driver_tip": (checkoutController.driverTipTotal.value).toPrecision(2).toStringAsFixed(2),
      "staff_tip": (checkoutController.tipTotal.value).toPrecision(2).toStringAsFixed(2),
      "is_sale_person_discount": checkoutController.sPDiscountPercentageForOrder != 0.0 ? "yes" : "no",
      "restaurant_id": restaurantController.selectedRestaurantId.value,
      "send_message": checkoutController.shouldSendMessage.value == true ? "yes" : "",
      "membership_discount_amount": checkoutController.membershipCardPercentageForOrder != 0.0 ? orderController.discount.value.toPrecision(2).toStringAsFixed(2) : "0",
      "category": checkoutController.membershipCardPercentageForOrder != 0.0 ? checkoutController.membershipCardTypeForOrder.toLowerCase() : "",
      "sub_total": (orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) - orderController.discount.value)
          .toPrecision(2)
          .toStringAsFixed(2),
      "total_cost":
          (orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) +
                  orderController.calculatedSalesTax.value +
                  checkoutController.tipTotal.value +
                  checkoutController.driverTipTotal.value +
                  checkoutController.deliveryFeeTotal.value -
                  orderController.discount.value)
              .toPrecision(2)
              .toStringAsFixed(2),
      "sales_tax":
          (((orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) - orderController.discount.value) / 100) *
                  siteDataController.salesTax.value)
              .toPrecision(2)
              .toStringAsFixed(2),
      "user_id": authController.userData.value.id.isNotEmpty ? authController.userData.value.id : "0",
      "customer_name": authController.userData.value.id.isNotEmpty
          ? "${authController.userData.value.firstName} ${authController.userData.value.lastName}"
          : checkoutController.nameController.text.trim(),
      "phone": authController.userData.value.id.isNotEmpty
          ? normalizeUsPhoneNumber(authController.userData.value.phone) ?? ""
          : normalizeUsPhoneNumber(checkoutController.phoneController.text.trim()) ?? "",
      "email": authController.userData.value.id.isNotEmpty ? authController.userData.value.email : checkoutController.emailController.text.trim(),
      "no_of_items": orderController.cartItems.length.toString(),
      "is_drink_order": orderController.cartItems.where((element) => element.itemCategory == "drinks" || element.itemCategory == "food").isNotEmpty ? "yes" : "no",
      "is_dumpling_order": orderController.cartItems.where((element) => element.itemCategory == "dumpling").isNotEmpty ? "yes" : "no",
      "is_rice_order": orderController.cartItems.where((element) => element.itemCategory == "rice").isNotEmpty ? "yes" : "no",
      "selected_items": jsonEncode(
        orderController.cartItems.map((cartItem) {
          Map<String, dynamic> tempMap = cartItem.placeOrderToJson();
          tempMap.addAll({
            "size_id": cartItem.options.isNotEmpty ? cartItem.options.first.optionId : "",
            "size_name": cartItem.options.isNotEmpty ? cartItem.options.first.optionName : "",
            "item_size_id": cartItem.options.isNotEmpty ? cartItem.options.first.itemOptionId : "",
            "size_price": cartItem.options.isNotEmpty ? cartItem.options.first.price : "0",
            "addons": cartItem.addons.map((e) {
              e = e.copyWith(finalCost: (double.tryParse(e.price) ?? 0.0) * cartItem.itemCount);
              return e.placeOrderToJson();
            }).toList(),
            "addons_cost_per_item": cartItem.addons
                .fold(0.0, (previousValue, addon) => previousValue + ((double.tryParse(addon.price) ?? 0.0) * cartItem.itemCount))
                .toStringAsFixed(2),
          });
          return tempMap;
        }).toList(),
      ),

      /* ! Commented because now addons are going inside the item ! */
      // "selected_items_addons": jsonEncode(
      //   orderController.cartItems
      //       .map((cartItem) {
      //         return cartItem.addons.map((e) => e
      //             .copyWith(
      //               finalCost: (double.tryParse(e.price) ?? 0.0) * cartItem.itemCount,
      //             )
      //             .placeOrderToJson());
      //       })
      //       .expand((element) => element)
      //       .toList(),
      // ),
    });

    if (checkoutController.selectedPaymentType.value == "redeemPoint" && authController.userData.value.id.isNotEmpty) {
      await Future.delayed(Duration(seconds: 5));
      await getUserPoints();
      if (!checkoutController.shouldShowRedeemSection()) {
        checkoutController.clearAll();

        /*+ Commented As Requested by Allen +*/
        /*+ Un-Commented As Requested by Allen on Aug-13-2024 +*/
        checkoutController.clearTips();
        checkoutController.getDiscountedPayableTotal();
        dismissLoading();
        isPlacingOrder.value = false;
        showMsg(msg: "It looks like you do not have enough points to redeem. Please choose another payment method.", time: const Duration(seconds: 4));
        return;
      }
    }

    try {
      // Connect to Pusher before POST so order-update is subscribed by the time we have order_id.
      unawaited(PusherService.instance.ensureConnected());

      var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.placeOrderEndpoint, queryMap);

      if (response == null) {
        dismissLoading();
        isPlacingOrder.value = false;
        unawaited(PusherService.instance.disconnect());
        return;
      }

      log("response in placeOrder is ${response.runtimeType}");
      log("response in placeOrder is $response");
      // String result = response['responce']['status'];

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";

      if (result == "success") {
        dismissLoading();
        final orderId = response["responce"]["Order-ID"].toString();
        //+ updating cart's order id so that we can delete this on Order Accepted notification.
        await LocalDatabase.updateCartOrderId(orderId);

        PusherService.instance.setWaitingOrderId(orderId);
        navigate(
          type: PageType.to,
          page: WaitingPage(orderId: orderId, flow: OrderWaitFlow.cart),
        );
        showMsg(msg: "Order placed successfully.", isSuccess: true);

        // await LocalHiveDatabase.saveSiteData(siteData);
      } else {
        dismissLoading();
        unawaited(PusherService.instance.disconnect());
        if (response["responce"].containsKey("error_code")) {
          showMsg(msg: "${response["responce"]["error_code"].toString().replaceAll("_", " ").capitalizeFirst}");
        } else if (response["responce"].containsKey("message")) {
          if (response['responce']["message"].runtimeType == String) {
            showMsg(msg: response['responce']["message"]);
          } else {
            String message = "";
            message = response['responce']["message"].values.toList().join("\n");
            log("is in else: $message");
            showMsg(msg: message, time: const Duration(seconds: 3));
          }
          // showMsg(msg: "${response["responce"]["message"]}");
        } else {
          showMsg(msg: "Couldn't place order. Please try again.");
        }
        log("Could not place order");
      }
    } catch (e) {
      dismissLoading();
      unawaited(PusherService.instance.disconnect());
      // isPlacingOrder.value = false; // already being handled at the end
      errorLog("error in placeOrder catch $e");
      showMsg(msg: "Couldn't place order. Please try again.");
    }
    isPlacingOrder.value = false;
  }

  //+ get order view data
  /// Fetches placed order details (also used as a one-shot fallback after Pusher wait timeout).
  Future<OrderViewModel?> getOrderViewData(String orderId, {bool shouldDismiss = false}) async {
    isLoadingMyOrderDetails.value = true;
    var response = await BaseClient().get(ApiConstants.baseUrl, "${ApiConstants.orderViewEndpoint}?id=$orderId").catchError((e) {
      handleError(
        e,
        onError: () {
          isLoadingMyOrderDetails.value = false;
          if (shouldDismiss) dismissLoading();

          showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
        },
      );
    });
    if (response == null) return null;

    // log("After getting data response in getOrderViewData \n $response");
    // log(" \n  Response data in getOrderViewData  \n ${response['data']}");

    // try {
    orderController.selectedOrderData.value = OrderViewModel(order: Order());
    orderController.selectedOrderData.value = OrderViewModel.fromJson(response['data']);
    myOrdersController.selectedOrderData.value = OrderViewModel.fromJson(response['data']);
    // } catch (e) {
    //   log("error in get order data: $e");
    // }
    if (shouldDismiss) dismissLoading();
    isLoadingMyOrderDetails.value = false;
    return orderController.selectedOrderData.value;
  }

  //+DoorDash Order View Data

  Future<void> getDoorDashOrderViewData(String orderId) async {
    isLoadingDoorDashOrderDetails.value = true;
    var response = await BaseClient().get(ApiConstants.baseUrl, "${ApiConstants.doorDashOrderViewEndpoint}?order_id=$orderId").catchError((e) {
      handleError(
        e,
        onError: () {
          isLoadingDoorDashOrderDetails.value = false;
          showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
        },
      );
    });
    if (response == null) return;

    // log("After getting data response in getOrderViewData \n $response");
    // log(" \n  Response data in getOrderViewData  \n ${response['data']}");

    // try {
    // orderController.selectedOrderData.value = OrderViewModel(order: Order());
    // orderController.selectedOrderData.value = OrderViewModel.fromJson(response['data']);
    myOrdersController.doorDashSelectedOrderData.value = DoorDashOrderViewModel.fromJson(response['responce']);
    log("DoorDash Order data is ${response['responce']}");
    log("DoorDash Order detail data with model to Json is ${myOrdersController.doorDashSelectedOrderData.value.toJson()}");
    // } catch (e) {
    //   log("error in get order data: $e");
    // }
    isLoadingDoorDashOrderDetails.value = false;
  }

  //+ get my orders list
  /// Gets list of orders placed by You
  Future<void> getMyOrdersList({bool enforceOffset = false}) async {
    // isLoadingMyOrders.value = true;
    isLoadingMyOrdersSimple = true;
    if (enforceOffset) myOrdersController.currentOffset = 0;
    try {
      var response = await BaseClient().get(
        ApiConstants.baseUrl,
        "${ApiConstants.myOrdersListEndpoint}?user_id=${authController.userData.value.id}"
        "&offset=${myOrdersController.currentOffset}",
      );
      // .catchError(handleError);
      if (response == null) return;

      // log("After getting data response in getMyOrders \n $response");
      // log(" \n  Response data in getMyOrders  \n ${response['data']}");
      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        List tempList = [];
        tempList = response["responce"]["my_orders_list"];
        // log("My Order list data is ${response["responce"]["my_orders_list"]}");
        for (var myOrder in tempList) {
          myOrdersController.myOrdersList.add(MyOrder.fromJson(myOrder));
          // log(" ----- ------ ---------------- -------------- ${element.toJson()}");
        }
        int lastPerPageNum = response["responce"]["per_page"];
        myOrdersController.currentOffset += lastPerPageNum;
        isLoadingMyOrdersSimple = false;
      } else {
        isLoadingMyOrders.value = false;
        isLoadingMyOrdersSimple = false;

        // showMsg(msg: "Something wrong please try again".tr);
      }
    } catch (e) {
      log("Error in getting my orders: $e");
      // showMsg(msg: "Error in getting my orders: $e");
      handleError(
        (e),
        onError: () {
          getMyOrdersList(enforceOffset: enforceOffset);
        },
      );
      // showMsg(msg: "Something wrong please try again");
    }
  }

  //+ get my referral orders list
  /// Gets list of orders placed by Users Referred by You
  Future<void> getMyReferralOrdersList({bool enforceOffset = false}) async {
    // isLoadingMyOrders.value = true;
    log("enforceOffset = $enforceOffset");
    if (enforceOffset) myReferralsController.currentOffset = 0;
    // if (enforceOffset) myReferralsController.myReferralOrdersList.clear();
    try {
      var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.myReferralOrdersEndpoint, {
        "user_id": authController.userData.value.id,
        "offset": myReferralsController.currentOffset.toString(),
      });
      // .catchError(handleError);
      if (response == null) return;

      log("After getting data response in getMyReferralOrdersList \n $response");
      // log(" \n  Response data in getMyReferralOrdersList  \n ${response['data']}");
      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        List tempList = [];
        tempList = response["data"];

        if (tempList.isNotEmpty) {
          for (var myOrder in tempList) {
            myReferralsController.myReferralOrdersList.add(MyReferralOrder.fromJson(myOrder));
            // log(" ----- ------ ---------------- -------------- ${element.toJson()}");
          }
          int lastPerPageNum = response["responce"]["per_page"];
          myReferralsController.currentOffset += lastPerPageNum;
        } else {
          isLoadingMyReferralOrders.value = false;
        }
      } else {
        isLoadingMyReferralOrders.value = false;
        // showMsg(msg: "Something wrong please try again");
      }
    } catch (e) {
      log("Error in getting my referral orders: $e");
      showMsg(msg: "Error in getting my referral orders: $e");
      // showMsg(msg: "Something wrong please try again");
    }
  }

  //+ get my referred users list
  /// Gets list of users Referred by You
  Future<void> getMyReferredUsersList() async {
    isLoadingMyReferredUsers.value = true;
    // if (enforceOffset) myReferralsController.currentOffset = 0;
    try {
      var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.myReferredUsersEndpoint, {"user_id": authController.userData.value.id});
      // .catchError(handleError);
      if (response == null) return;

      // log("After getting data response in getMyReferralOrdersList \n $response");
      // log(" \n  Response data in getMyReferralOrdersList  \n ${response['data']}");
      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        List tempList = [];
        tempList = response["data"];
        for (var myUser in tempList) {
          myReferralsController.myReferredUsersList.add(MyReferredUser.fromJson(myUser));
        }
        isLoadingMyReferredUsers.value = false;
      } else {
        isLoadingMyReferredUsers.value = false;
        // showMsg(msg: "Something wrong please while fetching referred users list");
      }
    } catch (e) {
      log("Error in getting my referred users: $e");
      isLoadingMyReferredUsers.value = false;
      showMsg(msg: "Error in getting referred users list: $e");
      // showMsg(msg: "Something wrong please try again");
    }
  }

  //+ get my points list
  /// Gets User Points Earning / Redeeming History
  Future<void> getMyPointsList({bool enforceOffset = false}) async {
    // isLoadingMyPoints.value = true;
    if (enforceOffset) myPointsController.currentOffset = 0;
    try {
      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.myPointsListEndpoint, {
            "user_id": authController.userData.value.id,
            "offset": myPointsController.currentOffset.toString(),
          })
          .catchError((e) {
            handleError(
              e,
              onError: () {
                getMyPointsList(enforceOffset: enforceOffset);
              },
            );
          });
      // .catchError(handleError);
      if (response == null) return;

      // log("After getting data response in getMyPointsList \n $response");
      // log(" \n  Response data in getMyPointsList  \n ${response['data']}");
      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        List tempList = [];
        tempList = response["data"];

        if (tempList.isNotEmpty) {
          for (var myOrder in tempList) {
            myPointsController.myPointsList.add(MyPoints.fromJson(myOrder));
          }
          int lastPerPageNum = response["responce"]["per_page"];
          myPointsController.currentOffset += lastPerPageNum;
        } else {
          isLoadingMyPoints.value = false;
        }
      } else {
        isLoadingMyPoints.value = false;
        // showMsg(msg: "Something wrong please try again");
      }
    } catch (e) {
      log("Error in get my points: $e");
      showMsg(msg: "Error in getting my points: ${e.toString()}");
      // showMsg(msg: "Something wrong please try again");
    }
  }

  //+ put the cart items on the server for later cart-not-empty notification
  /// Put the cart-items along with the fcm onto the server for later cart-not-empty notification
  Future<void> cartSyncForNotEmptyNotification() async {
    try {
      var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.cartSyncEndpoint, {
        "fcm_token": NotificationService.instance.cachedFcmToken ?? "",
        "cart_id": orderController.cartId,
        "cart_payload": jsonEncode(orderController.cartItems.map((cartItem) => cartItem.toJson()).toList()),
        "device_id": await getDeviceId(),
        "email": authController.userData.value.email,
      });
      // .catchError(handleError);
      if (response == null) return;

      log("After getting data response in cartSyncForNotEmptyNotification \n $response");
      // log(" \n  Response data in getMyReferralOrdersList  \n ${response['data']}");
      String result = response.containsKey("status") ? response["status"] : "error";

      if (result == "success") {
        log("cart sync successful");
      } else {
        log("cart sync un-successful");
        // showMsg(msg: "Something wrong please try again");
      }
    } catch (e) {
      log("Error in syncing cart is: $e");
      // showMsg(msg: "Error in syncing cart is: $e");
      // showMsg(msg: "Something wrong please try again");
    }
  }

  Future<void> deleteSyncedCartForNotEmptyNotification(String cartId) async {
    try {
      var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.deleteSyncedCartEndpoint, {"cart_id": cartId});
      // .catchError(handleError);
      if (response == null) return;

      log("After getting data response in deleteSyncedCartForNotEmptyNotification \n $response");
      // log(" \n  Response data in getMyReferralOrdersList  \n ${response['data']}");
      String result = response.containsKey("status") ? response["status"] : "error";

      if (result == "success") {
        log("\n Synced cart deleted\n ");
      } else {
        log("\n Synced cart deletion failed\n ");
        // showMsg(msg: "Something wrong please try again");
      }
    } catch (e) {
      log("Error in deleting synced cart is: $e");
      // showMsg(msg: "Error in deleting synced cart is: $e");
      // showMsg(msg: "Something wrong please try again");
    }
  }

  //+ get site info
  /// Gets Site Info to show in different parts of app
  Future<void> getSiteInfo() async {
    // showCircularLoading();
    log("In getSiteInfo");
    var response = await BaseClient().get(ApiConstants.baseUrl, ApiConstants.siteInfoEndpoint).catchError((e) {
      handleError(
        e,
        onError: () {
          getSiteInfo();
        },
      );
    });

    log("After getting site info \n");

    // log("response is $response");
    // String result = response['responce']['status'];

    if (response == null) return;

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      // dismissLoading();
      siteDataController.siteData = SiteInfo.fromJson(response["data"]["info"]);
      // await LocalHiveDatabase.saveSiteData(siteData);
      // wtfLog("siteData from model == : ${siteDataController.siteData.toJson()}");
      // showMsg(msg: "Order ready successfully");
    } else {
      // dismissLoading();
      showMsg(msg: "Something wrong please try again");
    }
  }

  //+ get sales tax
  /// Gets Sales Tax set by the restaurant
  Future<void> getSalesTax() async {
    var response = await BaseClient().get(ApiConstants.baseUrl, ApiConstants.salesTaxEndpoint).catchError((e) {
      handleError(
        e,
        onError: () {
          getSalesTax();
        },
      );
    });
    if (response == null) return;

    log("After getting sales tax \n");
    // log("After getting sales tax \n $response");
    // log(" \n  Response data in getSalesTax  \n ${response['data']}");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      siteDataController.salesTax.value = double.tryParse(response["data"]["sale_tax"]) ?? 8.875;
      // showMsg(msg: "Order ready successfully");
    } else {
      // dismissLoading();
      showMsg(msg: "Something wrong please try again");
    }
  }

  /* ++ ------------------------------------- PROFILE SECTION  --------------------------------- ++ */

  //+ register/signup user
  /// Register a new user
  Future<void> signup() async {
    if (authController.signupFormKey.currentState?.validate() ?? false) {
      authController.signupFormKey.currentState?.save();
      authController.loading.value = true;
      isSigningUp.value = true;
      showCircularLoading();

      // String deviceId = await getDeviceId();

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.registerEndpoint, {
            'first_name': authController.signupFirstNameController.text.trim(),
            'last_name': authController.signupLastNameController.text.trim(),
            'email': authController.signupEmailController.text.trim(),
            'phone': normalizeUsPhoneNumber(authController.signupPhoneNumController.text.trim()) ?? "",
            'date_of_birth': getFormattedDate(authController.signupDobController.text.trim()), //03-04-2000
            'password': authController.signupPasswordController.text,
            'confirm_password': authController.signupPasswordController.text,
            'referral_code': authController.signupReferralController.text.trim(),
          })
          .catchError((e) {
            handleError(
              e,
              onError: () {
                authController.loading.value = false;
                isSigningUp.value = false;
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("response is  $response");

      if (response != null) {
        String result = response.containsKey("responce")
            ? response["responce"].containsKey("status")
                  ? response["responce"]["status"]
                  : ""
            : "error";
        if (result == "success") {
          log("Signup Successful");

          authController.isActivationLinkSent.value = true;
          authController.activationLinkEmail.value = authController.signupEmailController.text.trim();
          authController.activateEmailController.text = authController.signupEmailController.text.trim();
          // Get.offAll(() => const HomeMenuPage());
          dismissLoading();
          navigate(type: PageType.offAll, page: const ActivateAccountPage(allowBack: false));
          Future.delayed(const Duration(milliseconds: 700), () {
            authController.loading.value = false;
            authController.clearSignupControllers();
          });
          // showMsg(msg: response['responce']["message"], isSuccess: true, position: SnackPosition.TOP);
        } else {
          authController.loading.value = false;
          dismissLoading();
          if (response['responce']["message"].runtimeType == String) {
            showMsg(msg: response['responce']["message"]);
          } else {
            String message = "";
            message = response['responce']["message"].values.toList().join("\n");
            showMsg(msg: message, time: const Duration(seconds: 3));
          }
          // else {
          //   showMsg(msg: "Something went wrong. Please try again.");
          // }

          log("Something wrong");
        }
      } else {
        dismissLoading();
        showMsg(
          msg:
              "There seems to be some issue on our side. "
              "We will resolve it as soon as we can. Please try again after some time.",
        );
      }
    } else {
      log("form not validated");
    }
    isSigningUp.value = false;
  }

  //+ update profile data
  /// Update user profile
  Future<void> updateProfile() async {
    if (profileController.updateProfileFormKey.currentState?.validate() ?? false) {
      profileController.updateProfileFormKey.currentState?.save();
      isUpdatingProfile.value = true;
      log("Inside updateProfile function");

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.updateProfileEndpoint, {
            'id': authController.userData.value.id,
            'first_name': profileController.firstNameController.text.trim(),
            'last_name': profileController.lastNameController.text.trim(),
            'phone': normalizeUsPhoneNumber(profileController.phoneController.text.trim()) ?? "",
          })
          .catchError((e) {
            handleError(
              e,
              onError: () {
                isUpdatingProfile.value = false;
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response \n $response");

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        log("profile updated successfully !");
        if (Get.currentRoute == "/MyProfilePage") {
          Get.back();
        }
        showMsg(msg: "Profile updated successfully.", isSuccess: true);
        authController.userData.value = authController.userData.value.copyWith(
          firstName: response['responce']['updated_user_data']['first_name'],
          lastName: response['responce']['updated_user_data']['last_name'],
          username: response['responce']['updated_user_data']['username'],
          phone: response['responce']['updated_user_data']['phone'],
        );

        LocalDatabase.saveUser(authController.userData.value);
        isUpdatingProfile.value = false;
      } else {
        isUpdatingProfile.value = false;
        if (response["responce"].containsKey("message")) {
          if (response["responce"]['message'].runtimeType == String) {
            showMsg(msg: response['responce']['message']);
          } else {
            // Map<String, dynamic> msgMap = response['responce']['message'];
            // msgMap.putIfAbsent("Some", () => "Something went wrong!");
            // List<String> strList = [];
            // for (var msg in msgMap.values) {
            //   String str = msg.toString().padLeft(msg.toString().length + 1, "- ");
            //   strList.add(str);
            // }
            // showMsg(msg: strList.join("\n"));
            showMsg(msg: response['responce']['message'].values.join("\n"));
          }
        }

        profileController.profileDataInitialization();

        // showMsg(msg: response['responce']['message']);
        log("Something wrong");
      }
    } else {
      isUpdatingProfile.value = false;
      log("form not validated");
      showMsg(msg: "Please enter valid data.");
    }
  }

  //+ update profile data
  /// Update user profile
  Future<void> updateProfileImage({VoidCallback? onStart, VoidCallback? onSuccess}) async {
    if (profileController.profileImage != null) {
      isUpdatingProfileImage.value = true;

      try {
        if (onStart != null) onStart.call();
      } catch (e) {
        log("error in onSuccess in image update: $e");
      }
      // showMsg(msg: "Uploading image...", isSuccess: true);
      // showCircularLoading();
      log("Inside updateProfile function");

      var response = await BaseClient()
          .multipartPostRequest(
            ApiConstants.baseUrl,
            ApiConstants.updateProfileImageEndpoint,
            {'user_id': authController.userData.value.id},
            fileFieldName: 'profile_image',
            filePath: profileController.profileImage?.path ?? "",
          )
          .catchError((e) {
            handleError(
              e,
              onError: () {
                dismissLoading();
                isUpdatingProfileImage.value = false;
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response in updateProfileImage \n $response");

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        // dismissLoading();
        log("Image updated successfully !");
        String imageBaseUrl = response["profile_image_base_path"];
        String imgName = "";

        if (authController.userData.value.photo.contains("/")) {
          List<String> lastImageSplittedList = authController.userData.value.photo.split("/");
          imgName = lastImageSplittedList.last;
        }

        log("imgName: $imgName");
        log("imageBaseUrl: $imageBaseUrl");
        log("imageBaseUrl: $imageBaseUrl$imgName");
        authController.userData.value = authController.userData.value.copyWith(photo: "$imageBaseUrl$imgName");

        LocalDatabase.saveUser(authController.userData.value);
        profileController.selectedProfileImagePath.value = "";
        log("Get.currentRoute: ${Get.currentRoute}");
        getUpdatedProfileData(showSnackOnError: false);
        // if (Get.currentRoute == "/MyProfilePage") {
        //   Get.back();
        // }
        try {
          if (onSuccess != null) onSuccess.call();
        } catch (e) {
          log("error in onSuccess in image update: $e");
        }
        // showMsg(msg: "Image updated successfully.", isSuccess: true);
      } else {
        // dismissLoading();
        showMsg(msg: response['responce']['message']);
        log("Something wrong");
      }
    } else {
      // dismissLoading();
      log("form not validated");
      showMsg(msg: "Please select a new image to update");
    }
    isUpdatingProfileImage.value = false;
  }

  //+ update password
  /// Updates user profile password
  Future<void> updatePassword() async {
    if (authController.changePasswordFormKey.currentState?.validate() ?? false) {
      if (authController.changePassCurrentPassController.text.trim() == authController.changePassNewPassController.text.trim()) {
        showMsg(msg: "New and Old password cannot be same.", isSuccess: false);
        return;
      }
      authController.changePasswordFormKey.currentState?.save();
      isUpdatingPassword.value = true;
      log("Inside updatePassword function");

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.updatePasswordEndpoint, {
            'email': authController.userData.value.email,
            'old_password': authController.changePassCurrentPassController.text.trim(),
            'new_password': authController.changePassNewPassController.text.trim(),
            'new_confirm_password': authController.changePassConfirmNewPassController.text.trim(),
          })
          .catchError((e) {
            handleError(
              e,
              onError: () {
                isUpdatingPassword.value = false;
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response \n $response");

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        log("Password changed successfully !");
        Get.back();
        showMsg(msg: "Password changed successfully.", isSuccess: true);
        isUpdatingPassword.value = false;
        authController.changePassCurrentPassController.clear();
        authController.changePassNewPassController.clear();
        authController.changePassConfirmNewPassController.clear();
      } else {
        isUpdatingPassword.value = false;
        showMsg(msg: response['responce']['message'].toString().replaceAll("#", ""));
        log("Something wrong");
      }
    } else {
      isUpdatingPassword.value = false;
      log("form not validated");
      showMsg(msg: "Please enter valid data.");
    }
  }

  //+ get updated profile data
  /// Gets updated user profile data
  Future<void> getUpdatedProfileData({bool showSnackOnError = true}) async {
    if (authController.userData.value.id.isNotEmpty) {
      isLoadingUpdatedProfileData.value = true;
      log("Inside getUpdatedProfileData function");

      try {
        var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.userInfoEndpoint, {'user_id': authController.userData.value.id}).catchError((e) {
          handleError(
            e,
            onError: () {
              if (authController.userData.value.id.isNotEmpty) getUpdatedProfileData();
            },
          );
        });

        log("Response in getUpdatedProfileData::::: \n $response");

        String result = response.containsKey("responce")
            ? response["responce"].containsKey("status")
                  ? response["responce"]["status"]
                  : ""
            : "error";
        if (result == "success") {
          log("updated profile data fetched successfully !");
          String imageBaseUrl = "";
          if (authController.userData.value.photo.contains("/")) {
            List<String> lastImageSplittedList = authController.userData.value.photo.split("/");
            lastImageSplittedList.removeLast();
            imageBaseUrl = lastImageSplittedList.join("/");
            log("lastImageSplittedList in update profile: $lastImageSplittedList");
            log("image base url in update profile: $imageBaseUrl");
          }

          if (response.containsKey("data")) {
            if (response["data"].isNotEmpty) {
              Map<String, dynamic> d = response["data"][0];
              authController.userData.value = authController.userData.value.copyWith(
                id: d['id'],
                ipAddress: d['ip_address'] ?? "",
                username: d['username'] ?? "",
                password: d['password'] ?? "",
                salt: d['salt'] ?? "",
                email: d['email'] ?? "",
                activationCode: d['activation_code'] ?? "",
                forgottenPasswordCode: d['forgotten_password_code'] ?? "",
                forgottenPasswordTime: d['forgotten_password_time'] ?? "",
                rememberCode: d['remember_code'] ?? "",
                createdOn: d['created_on'] ?? "",
                active: d['active'] ?? "0",
                firstName: d['first_name'] ?? "",
                lastName: d['last_name'] ?? "",
                photo: "$imageBaseUrl/${d['photo'] ?? "user.png"}",
                phone: d['phone'] ?? "",
                dateOfBirth: d['date_of_birth'] ?? "",
                secondaryEmail: d['secondary_email'] ?? "",
                securityQuestion1: d['security_question_1'] ?? "",
                securityQuestionOneAnswer: d['security_question_one_answer'] ?? "",
                securityQuestion2: d['security_question_2'] ?? "",
                securityQuestionTwoAnswer: d['security_question_two_answer'] ?? "",
                address: d['address'] ?? "",
                city: d['city'] ?? "",
                pincode: d['pincode'] ?? "",
                landmark: d['landmark'] ?? "",
                deviceId: d['device_id'] ?? "",
                platform: d['platform'] ?? "",
                registrationThrough: d['registration_through'] ?? "",
                registrationType: d['registration_type'] ?? "",
                referralCode: d['referral_code'] ?? "",
                userPoints: d['user_points'] ?? "",
                referBy: d['refer_by'] ?? "",
                referByCode: d['refer_by_code'] ?? "",
                createdDatetime: d['created_datetime'] ?? "",
                updatedDatetime: d['updated_datetime'] ?? "",
                isActivated: d['is_activated'] ?? "No",
                assignedCities: d['assigned_cities'] ?? "",
                giftCardMembership: d['gift_card_membership'] ?? "no",
                appId: d['app_id'] ?? "no",
              );
            }
          }

          LocalDatabase.saveUser(authController.userData.value);
        } else {
          if (showSnackOnError) showMsg(msg: response['responce']['message']);
          log("Something wrong: ${response['responce']['message']}");
        }
      } catch (e) {
        log("Error in user profile data update: $e");
      }
      isLoadingUpdatedProfileData.value = false;
    } else {
      // do nothing
      log("User Id was empty while trying to get updated user data");
    }
  }

  //+ resend activation email
  /// Resends Activation Email
  Future<void> resendActivationEmail() async {
    if (authController.activateFormKey.currentState?.validate() ?? false) {
      authController.activateFormKey.currentState?.save();
      isResendingActivationEmail.value = true;
      log("Inside resendActivationEmail function");

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.resendActivationEmailEndpoint, {'email': authController.activateEmailController.text.trim()})
          .catchError((e) {
            handleError(
              e,
              onError: () {
                isResendingActivationEmail.value = false;
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response \n $response");

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        log("email sent successfully!");
        showMsg(msg: response['responce']['message'], isSuccess: true, time: const Duration(seconds: 4));
      } else {
        showMsg(msg: response['responce']['message']);
        log("Something wrong");
      }
    } else {
      log("form not validated");
      showMsg(msg: "Please enter valid data.");
    }
    isResendingActivationEmail.value = false;
  }

  //+ user points
  /// Gets user points of the signed in user.
  Future<void> getUserPoints() async {
    if (authController.userData.value.id.isEmpty) return;
    isLoadingUserPoints.value = true;
    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.userPointsEndpoint, {"user_id": authController.userData.value.id}).catchError((e) {
      handleError(
        e,
        onError: () {
          if (authController.userData.value.id.isNotEmpty) getUserPoints();
        },
      );
    });
    if (response == null) return;

    // log("After getting user points \n $response");
    // log(" \n  Response data in getUserPoints  \n ${response['data']}");

    String result = response.containsKey("response")
        ? response["response"].containsKey("status")
              ? response["response"]["status"]
              : ""
        : "error";

    if (result == "success") {
      authController.userData.value = authController.userData.value.copyWith(userPoints: response["data"]["total_points"]);
    } else {
      log("");
      showMsg(msg: "Something wrong while fetching the user points details. Please try again");
    }
    isLoadingUserPoints.value = false;
  }

  //+ user promotions
  /// Gets user promotions of the signed in user.
  Future<void> getUserPromotions() async {
    isLoadingUserPromos.value = true;

    errorLog("In getUserPromotions");
    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.userPromosEndpoint, {"user_id": authController.userData.value.id}).catchError((e) {
      handleError(
        e,
        onError: () {
          getUserPromotions();
        },
      );
    });

    if (response == null) return;

    log("response in getUserPromotions is $response");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    try {
      if (result == "success") {
        List promosList = response["data"];

        userPromoController.myUserPromosList = RxList.from(
          promosList.where((element) => element["status"].toLowerCase() == "active").map((e) => UserPromotion.fromJson(e)).toList(),
        );
      } else {
        // showMsg(msg: "No promotions available right now");
        log("No promotions available right now");
      }
    } catch (e) {
      errorLog("error in getUserPromotions catch $e");
      showMsg(msg: "Something went wrong. Please open the promotions page again.");
    }
    isLoadingUserPromos.value = false;
  }

  /* ++ ------------------------------------- GIFT-CARD SECTION  --------------------------------- ++ */

  //+ get gift cards
  /// Gets available Gift Cards
  Future<void> getGiftCards() async {
    isLoadingGiftCards.value = true;
    var response = await BaseClient().get(ApiConstants.baseUrl, ApiConstants.giftCardsEndpoint).catchError((e) {
      handleError(
        e,
        onError: () {
          getGiftCards();
        },
      );
    });
    if (response == null) return;

    log("After getting gift cards \n $response");
    log(" \n  Response data in getGiftCards  \n ${response['data']}");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      String imagePath = "${ApiConstants.baseUrl}/${response["image_path"]}";
      giftCardController.giftCardsList.clear();

      for (var gc in response["data"]) {
        if (gc["status"].toLowerCase() == "active") {
          GiftCard tempGiftCard = GiftCard.fromJson(gc);
          tempGiftCard = tempGiftCard.copyWith(itemImageName: "$imagePath${tempGiftCard.itemImageName}");

          giftCardController.giftCardsList.add(tempGiftCard);
        }
      }
    } else {
      showMsg(msg: "Something wrong while fetching the GiftCards please try again");
    }
    isLoadingGiftCards.value = false;
  }

  //+ buy gift card
  /// Buys a Gift Card which is then sent to receiver's email along with its Pin
  Future<void> buyGiftCard() async {
    if (giftCardController.buyGiftCardFormKey.currentState?.validate() ?? false) {
      giftCardController.buyGiftCardFormKey.currentState?.save();
      isBuyingGiftCard.value = true;
      log("Inside buyGiftCard function");

      if (giftCardController.selectedPaymentType.trim().toLowerCase() == "stripe") {
        giftCardController.cardToken = await getCardToken(isForGiftcard: true, overrideRestaurantId: true); // , overrideRestaurantId: true
        if (giftCardController.cardToken.isEmpty) {
          isBuyingGiftCard.value = false;
          return;
        }
      }

      var response = await BaseClient()
          .post(
            ApiConstants.baseUrl,
            ApiConstants.buyGiftCardEndpoint,
            giftCardController.sendToMyself.value
                ? {
                    "stripe_token": giftCardController.cardToken,
                    'card_id': giftCardController.selectedCardId,
                    'send_myself': giftCardController.sendToMyself.value.toString(),
                    'payment_type': giftCardController.selectedPaymentType.trim().toLowerCase(),
                    'amount': giftCardController.buySelectedAmount.replaceAll("\$", "").trim(),
                    'sender_name': giftCardController.buyGiftCardSenderNameController.text.trim(),
                    'sender_email': giftCardController.buyGiftCardSenderEmailController.text.trim(),
                    'sender_phone': normalizeUsPhoneNumber(giftCardController.buyGiftCardSenderPhoneController.text.trim()) ?? "",
                  }
                : {
                    "stripe_token": giftCardController.cardToken,
                    'card_id': giftCardController.selectedCardId,
                    'payment_type': giftCardController.selectedPaymentType.trim().toLowerCase(),
                    'amount': giftCardController.buySelectedAmount.replaceAll("\$", "").trim(),
                    'card_name': giftCardController.stripeNameController.text.trim(),
                    'sender_name': giftCardController.buyGiftCardSenderNameController.text.trim(),
                    'sender_email': giftCardController.buyGiftCardSenderEmailController.text.trim(),
                    'sender_phone': normalizeUsPhoneNumber(giftCardController.buyGiftCardSenderPhoneController.text.trim()) ?? "",
                    'recipient_name': giftCardController.buyGiftCardRecipientNameController.text.trim(),
                    'recipient_email': giftCardController.buyGiftCardRecipientEmailController.text.trim(),
                    'recipient_phone': normalizeUsPhoneNumber(giftCardController.buyGiftCardRecipientPhoneController.text.trim()) ?? "",
                  },
          )
          .catchError((e) {
            handleError(
              e,
              onError: () {
                isBuyingGiftCard.value = false;
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response \n $response");

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        log("Card bought successfully !");
        giftCardController.isBuyingGiftCardSuccessful = true;
        showMsg(msg: response['responce']['message'], isSuccess: true);
        // showMsg(msg: "Card bought successfully.", isSuccess: true);
      } else {
        if (response["responce"].containsKey("error_code")) {
          showMsg(msg: "${response["responce"]["error_code"].toString().replaceAll("_", " ").capitalizeFirst}");
        } else if (response["responce"].containsKey("message")) {
          if (response["responce"]['message'].runtimeType == String) {
            showMsg(msg: response['responce']['message']);
          } else {
            showMsg(msg: response['responce']['message'].values.join(" "));
          }
        }

        log("Something wrong");
      }
    } else {
      log("form not validated");
      showMsg(msg: "Please enter valid data.");
    }
    isBuyingGiftCard.value = false;
  }

  //+ reload gift card
  /// Reloads a Gift Card by providing Gift Card No. and Pin
  Future<void> reloadGiftCard() async {
    if (giftCardController.reloadGiftCardFormKey.currentState?.validate() ?? false) {
      giftCardController.reloadGiftCardFormKey.currentState?.save();
      isReloadingGiftCard.value = true;
      log("Inside reloadGiftCard function");

      if (giftCardController.selectedPaymentType.trim().toLowerCase() == "stripe") {
        giftCardController.cardToken = await getCardToken(isForGiftcard: true, overrideRestaurantId: true); // , overrideRestaurantId: true
        if (giftCardController.cardToken.isEmpty) {
          isReloadingGiftCard.value = false;
          return;
        }
      }

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.reloadGiftCardEndpoint, {
            "stripe_token": giftCardController.cardToken,
            'gift_code_number': giftCardController.reloadGiftCardController.text.trim(),
            'pin': giftCardController.reloadGiftPinController.text.trim(),
            'payment_type': giftCardController.selectedPaymentType.trim().toLowerCase(),
            'amount': giftCardController.reloadSelectedAmount.replaceAll("\$", "").trim(),
          })
          .catchError((e) {
            handleError(
              e,
              onError: () {
                isReloadingGiftCard.value = false;
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response \n $response");

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        log("Card reloaded successfully !");
        showMsg(msg: "Card reloaded successfully.", isSuccess: true);
        isReloadingGiftCard.value = false;
        giftCardController.isReloadingGiftCardSuccessful = true;
      } else {
        isReloadingGiftCard.value = false;
        // showMsg(msg: response['responce']['message']);
        if (response["responce"].containsKey("error_code")) {
          showMsg(msg: "${response["responce"]["error_code"].toString().replaceAll("_", " ").capitalizeFirst}");
        } else if (response["responce"].containsKey("message")) {
          showMsg(msg: "${response["responce"]["message"]}");
        }
        log("Something wrong");
      }
    } else {
      isReloadingGiftCard.value = false;
      log("form not validated");
      showMsg(msg: "Please enter valid data.");
    }
  }

  //+ check gift card balance and other data including history
  /// Gets gift-card balance and other details including
  /// redeem and reload history.
  Future<void> checkGiftCardBalance({bool shouldNavigate = true, bool checkingOnCheckout = false, bool showingOutsideLoading = false}) async {
    if (giftCardController.checkBalanceFormKey.currentState?.validate() ?? false || checkingOnCheckout) {
      giftCardController.checkBalanceFormKey.currentState?.save();

      isCheckingGiftCardBalance.value = true;
      log("Inside checkGiftCardBalance function");

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.getGiftCardDetailsEndpoint, {
            'gift_code_number': checkingOnCheckout
                ? checkoutController.checkoutGiftCardController.text.trim()
                : giftCardController.checkBalanceGiftCardController.text.trim(),
            'pin': checkingOnCheckout ? checkoutController.checkoutGiftPinController.text.trim() : giftCardController.checkBalanceGiftPinController.text.trim(),
          })
          .catchError((e) {
            handleError(
              e,
              onError: () {
                isCheckingGiftCardBalance.value = false;
                if (showingOutsideLoading) dismissLoading();
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response \n $response");

      if (response == null) return;

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      // result = "success";
      if (result == "success") {
        log("balance check data fetched successfully !");
        isCheckingGiftCardBalance.value = false;
        giftCardController.myGiftCardDetails.value = GiftCardDetails.fromJson(response);

        String imagePath = "${ApiConstants.baseUrl}/${response["image_path"]}";
        giftCardController.myGiftCardDetails.value = giftCardController.myGiftCardDetails.value.copyWith(
          data: giftCardController.myGiftCardDetails.value.data?.copyWith(
            items: giftCardController.myGiftCardDetails.value.data?.items?.copyWith(
              itemImageName: "$imagePath${giftCardController.myGiftCardDetails.value.data?.items?.itemImageName}",
            ),
          ),
        );
        //+ navigate here after assigning data
        if (shouldNavigate) {
          Get.to(() => const GiftCardHistoryPage(), transition: Transition.rightToLeftWithFade, duration: const Duration(milliseconds: 500));
        }
        // showMsg(msg: "Card reloaded successfully.", isSuccess: true);
      } else {
        isCheckingGiftCardBalance.value = false;
        if (showingOutsideLoading) dismissLoading();
        showMsg(msg: response['responce']['message']);
        log("Something wrong");
      }
    } else {
      isCheckingGiftCardBalance.value = false;
      if (showingOutsideLoading) dismissLoading();

      log("form not validated");
      showMsg(msg: "Please enter valid data.");
      return;
    }
  }

  //+ send giftcard last 4, email and phone  to recover gift card

  /// Information is sent through this to get the otp
  /// and then this info is verified and if valid,
  /// an otp is sent on provided phone number
  Future<void> recoverGiftCardSendInfoToGetOTP({bool shouldNavigate = true}) async {
    if (giftCardController.recoverFormKey.currentState?.validate() ?? false) {
      giftCardController.recoverFormKey.currentState?.save();

      isSendingRecoveryGiftCardDataForOTP.value = true;
      log("Inside recoverGiftCardSendInfoToGetOTP function");

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.recoverGiftCardEndpoint, {
            'last_4_digits': giftCardController.recoverGiftCardLast4Controller.text.trim(),
            'email': giftCardController.recoverGiftCardEmailController.text.trim(),
            'phone': normalizeUsPhoneNumber(giftCardController.recoverGiftCardPhoneController.text.trim()) ?? "",
          })
          .catchError((e) {
            handleError(
              e,
              onError: () {
                isSendingRecoveryGiftCardDataForOTP.value = false;
                // recoverGiftCardSendInfoToGetOTP(shouldNavigate: shouldNavigate);
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response \n $response");

      if (response == null) return;

      String result = response.containsKey("status") ? response["status"] : "error";
      // result = "success";
      if (result == "success") {
        log("recover giftcard initial otp request sent successfully !");

        giftCardController.recoveringGiftCardId = response["gift_id"];
        giftCardController.otpSentAt = DateTime.now();
        giftCardController.isOTPSentForRecovery.value = true;
        giftCardController.otpExpireTimeInSec = (double.tryParse(response["otp_expire_minutes"]) ?? 0) * 60;

        isSendingRecoveryGiftCardDataForOTP.value = false;

        showMsg(msg: response['message'], isSuccess: true);

        // showMsg(msg: "Card reloaded successfully.", isSuccess: true);
      } else {
        isSendingRecoveryGiftCardDataForOTP.value = false;
        giftCardController.isOTPSentForRecovery.value = false;

        showMsg(msg: response['message']);
        log("Something wrong");
      }
    } else {
      isSendingRecoveryGiftCardDataForOTP.value = false;
      giftCardController.isOTPSentForRecovery.value = false;

      log("form not validated");
      showMsg(msg: "Please enter valid data.");
      return;
    }
  }

  //+ verifying OTP sent to added phone to recover gift card
  /// Verifying the otp
  Future<void> recoverVerifyOTPForGiftCard({bool shouldNavigate = true}) async {
    if (giftCardController.recoverFormKey.currentState?.validate() ?? false) {
      giftCardController.recoverFormKey.currentState?.save();

      isVerifyingOTPForGiftCard.value = true;
      log("Inside recoverVerifyOTPForGiftCard function");

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.recoverVerifyOTPGiftCardEndpoint, {
            'last_4_digits': giftCardController.recoverGiftCardLast4Controller.text.trim(),
            'email': giftCardController.recoverGiftCardEmailController.text.trim(),
            'phone': normalizeUsPhoneNumber(giftCardController.recoverGiftCardPhoneController.text.trim()) ?? "",
            'otp_code': giftCardController.recoverGiftCardOTPController.text.trim(),
          })
          .catchError((e) {
            handleError(
              e,
              onError: () {
                isVerifyingOTPForGiftCard.value = false;
                // recoverGiftCardSendInfoToGetOTP(shouldNavigate: shouldNavigate);
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response \n $response");

      if (response == null) return;

      String result = response.containsKey("status") ? response["status"] : "error";
      // result = "success";
      if (result == "success") {
        log("recover giftcard otp verification done successfully!");

        // giftCardController.isRecoveredSuccessfully.value = true;
        giftCardController.recoveredGiftCardNo = response["gift_data"]["gift_card_no"];
        log("response['gift_data']['pin']: ${response['gift_data']['pin']}");
        log("response['gift_data']['pin']: ${response['gift_data']['pin'].runtimeType}");
        giftCardController.recoveredPin = response["gift_data"]["pin"].toString();

        isVerifyingOTPForGiftCard.value = false;

        showMsg(msg: response['message'], isSuccess: true);

        giftCardController.selectMenu(giftCardController.menus[4]);

        // showMsg(msg: "Card reloaded successfully.", isSuccess: true);
      } else {
        isVerifyingOTPForGiftCard.value = false;

        showMsg(msg: response['message']);
        log("Something wrong");
      }
    } else {
      isVerifyingOTPForGiftCard.value = false;

      log("form not validated");
      showMsg(msg: "Please enter valid data.");
      return;
    }
  }

  //+ Resending OTP to added phone to recover gift card
  /// Resending the otp
  Future<void> recoverResendOTPForGiftCard({bool shouldNavigate = true}) async {
    // if (giftCardController.recoverFormKey.currentState?.validate() ?? false) {
    //   giftCardController.recoverFormKey.currentState?.save();

    isResendingOTPForGiftCard.value = true;
    log("Inside recoverVerifyOTPForGiftCard function");

    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.recoverResendOTPGiftCardEndpoint, {
          'last_4_digits': giftCardController.recoverGiftCardLast4Controller.text.trim(),
          'email': giftCardController.recoverGiftCardEmailController.text.trim(),
          'phone': normalizeUsPhoneNumber(giftCardController.recoverGiftCardPhoneController.text.trim()) ?? "",
          'id': giftCardController.recoveringGiftCardId,
        })
        .catchError((e) {
          handleError(
            e,
            onError: () {
              isResendingOTPForGiftCard.value = false;
              // recoverGiftCardSendInfoToGetOTP(shouldNavigate: shouldNavigate);
              showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
            },
          );
        });

    log("Response \n $response");

    if (response == null) return;

    String result = response.containsKey("status") ? response["status"] : "error";
    // result = "success";
    if (result == "success") {
      log("recover giftcard otp resending done successfully!");

      giftCardController.recoveringGiftCardId = response["gift_id"];
      giftCardController.otpSentAt = DateTime.now();
      giftCardController.isOTPSentForRecovery.value = true;
      giftCardController.otpExpireTimeInSec = (double.tryParse(response["otp_expire_minutes"]) ?? 0) * 60;

      isResendingOTPForGiftCard.value = false;

      showMsg(msg: response['message'], isSuccess: true);
    } else {
      isResendingOTPForGiftCard.value = false;

      showMsg(msg: response['message']);
      log("Something wrong");
    }
    // } else {
    //   isResendingOTPForGiftCard.value = false;
    //
    //   log("form not validated");
    //   showMsg(msg: "Please enter valid data.");
    //   return;
    // }
  }

  /* ++ ------------------------------------- GIFT-CARD SECTION END --------------------------------- ++ */

  /* ++ ------------------------------------- SUBSCRIPTIONS SECTION --------------------------------- ++ */

  int subOffersRetryCount = 0;

  //+ get subscription offers
  /// Gets Subscription Offers
  Future<void> getSubscriptionOffers() async {
    // showCircularLoading();
    isLoadingSubscriptionOffers.value = true;

    WidgetsBinding.instance.addPostFrameCallback((time) {
      subscriptionsController.subscriptionOffers.clear();
    }); // to remove loading indicator from screen after loading instance
    log("restaurantController.selectedRestaurantId.value PASS  INSIDE getSubscriptionOffers ${restaurantController.selectedRestaurantId.value}");
    // errorLog("In getSubscriptionOffers");
    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.subscriptionOffersEndpoint, {"restaurant_id": restaurantController.selectedRestaurantId.value})
        .catchError((e) {
          handleError(
            e,
            onError: () {
              if (subOffersRetryCount <= 5) {
                subOffersRetryCount++;
                getSubscriptionOffers();
              } else {
                subOffersRetryCount = 0;
                isLoadingSubscriptionOffers.value = false;
                showMsg(msg: "Something went wrong. Please refresh the page or try after some time.");
              }
            },
          );
        });

    // log("Response of Offers: $response");
    if (response == null) return;

    // log("response is $response");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    // try {
    if (result == "success") {
      if (response["data"] != null) {
        // log("result is Success and offers list from response ${response["data"]}");
        List offers = response["data"];
        String imgBasePath = response["responce"]["img_base_path"];
        String offerImgBasePath = response["responce"]["OFFER_IMG_UPLOAD_PATH_URL"];
        offerImgBasePath = "${ApiConstants.baseUrl}/$offerImgBasePath";
        log("imgBasePath: $imgBasePath");

        /* + Check if user is logged in or not and accordingly fetch his/her subscriptions + */

        if (authController.userData.value.id.isNotEmpty) {
          await getMySubscriptions(); // uncommented again because we need to check if user is subscribed to any offer or not
          await getMySubscriptionOrders();
        }

        for (var offerRaw in offers) {
          SubscriptionOffer offer = SubscriptionOffer.fromJson(offerRaw);

          if (offer.offerImageName.isNotEmpty) {
            offer = offer.copyWith(offerImageName: "$offerImgBasePath${offer.offerImageName}");
          }

          List<OfferProduct> updatedOrderProducts = [];

          for (var product in offer.offerProducts) {
            List<MenuItem> updatedItemDetails = [];

            for (var productItem in product.itemDetail) {
              if (productItem.itemImageName.isNotEmpty) {
                // Update the itemImageName
                productItem = productItem.copyWith(itemImageName: "$imgBasePath${productItem.itemImageName}");
              }
              //! Add the updated productItem back to the itemDetail list
              updatedItemDetails.add(productItem);
            }

            //! Update the product with the updated itemDetail list
            product = product.copyWith(itemDetail: updatedItemDetails);

            /* + this "if" makes sure that we do not add a product in the list if its itemDetails list is empty + */
            if (product.itemDetail.isNotEmpty) {
              //! Add the updated product to the orderProducts list
              updatedOrderProducts.add(product);
            }
          }

          //! Update the offer with the updated orderProducts list
          offer = offer.copyWith(offerProducts: updatedOrderProducts);
          // log("item is now: ${item.toJson()}");

          if (authController.userData.value.id.isNotEmpty) {
            // if (subscriptionsController.mySubscriptionsList.where((mySub) => mySub.offerId == offer.offerId).isNotEmpty) {

            // log("subscriptionsController.mySubscriptionsList.where((mySub) => mySub.offerId == offer.offerId): ${offer.offerId}");
            // log("subscriptionsController.mySubscriptionsList.where((mySub) => mySub.offerId == offer.offerId): ${offer.offerId}");
            // log("subscriptionsController.mySubscriptionsList.where((mySub) => mySub.offerId == offer.offerId): ${subscriptionsController.mySubscriptionsList.where((mySub) => mySub.offerId == offer.offerId).isNotEmpty}");
            if ((subscriptionsController.mySubscriptionsList.where((mySub) => mySub.offerId == offer.offerId && mySub.status.toLowerCase() != "deactive").isNotEmpty) ||
                (subscriptionsController.mySubscriptionOrders
                        .where((mySubOrder) => mySubOrder.offerId == offer.offerId && (!['missed', 'cancel', 'cancelled'].contains(mySubOrder.status.toLowerCase())))
                        .isNotEmpty &&
                    offer.planType.toLowerCase() == "free")) {
              offer = offer.copyWith(isSubscribed: true);
            }
          }

          /* +  && offer.offerProducts.isNotEmpty ==> this makes sure that the offers with empty offer products are not added to final list + */
          if (offer.status.toLowerCase() == "active" && offer.offerProducts.isNotEmpty) {
            subscriptionsController.subscriptionOffers.add(offer);
          }
        }
        if (subscriptionsController.subscriptionOffers.isNotEmpty) {
          subscriptionsController.getSubscriptionOfferItems(subscriptionsController.subscriptionOffers.first.offerId, callGetSubOffers: false);
        }
      } else {
        isLoadingSubscriptionOffers.value = false;
      }
      // await LocalHiveDatabase.saveSiteData(siteData);
    } else {
      // dismissLoading();
      isLoadingSubscriptionOffers.value = false;

      showMsg(msg: "No offers available right now");
    }
    subOffersRetryCount = 0;
    // } catch (e) {
    //   errorLog("error in getSubscriptionOffers catch $e");
    //   showMsg(msg: "Something wrong please refresh the page to try again");
    // }
    isLoadingSubscriptionOffers.value = false;
  }

  int subOffersForAllRestaurantsRetryCount = 0;

  //+ get subscription offers
  /// Gets Subscription Offers of all restaurants so that we can get teh items for each offer even from different restaurants
  Future<void> getSubscriptionOffersForAllRestaurants() async {
    // showCircularLoading();
    isLoadingSubscriptionOffersForAllRestaurants.value = true;
    subscriptionsController.subscriptionOffersForAllRestaurants.clear();
    // errorLog("In getSubscriptionOffers");
    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.subscriptionOffersEndpoint, {
          // "restaurant_id": restaurantController.selectedRestaurantId.value,
        })
        .catchError((e) {
          handleError(
            e,
            onError: () {
              if (subOffersForAllRestaurantsRetryCount <= 5) {
                subOffersForAllRestaurantsRetryCount++;
                getSubscriptionOffersForAllRestaurants();
              } else {
                subOffersForAllRestaurantsRetryCount = 0;
                isLoadingSubscriptionOffersForAllRestaurants.value = false;
                showMsg(msg: "Something went wrong. Please refresh the page or try after some time.");
              }
            },
          );
        });

    if (response == null) return;

    // log("response is $response");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    try {
      if (result == "success") {
        List offers = response["data"];
        String imgBasePath = response["responce"]["img_base_path"];
        String offerImgBasePath = response["responce"]["OFFER_IMG_UPLOAD_PATH_URL"];
        offerImgBasePath = "${ApiConstants.baseUrl}/$offerImgBasePath";
        log("imgBasePath: $imgBasePath");

        /* + Check if user is logged in or not and accordingly fetch his/her subscriptions + */

        // if (authController.userData.value.id.isNotEmpty) {
        //   await getMySubscriptions();
        // }

        for (var offerRaw in offers) {
          SubscriptionOffer offer = SubscriptionOffer.fromJson(offerRaw);

          if (offer.offerImageName.isNotEmpty) {
            offer = offer.copyWith(offerImageName: "$offerImgBasePath${offer.offerImageName}");
          }

          List<OfferProduct> updatedOrderProducts = [];

          for (var product in offer.offerProducts) {
            List<MenuItem> updatedItemDetails = [];

            for (var productItem in product.itemDetail) {
              if (productItem.itemImageName.isNotEmpty) {
                // Update the itemImageName
                productItem = productItem.copyWith(itemImageName: "$imgBasePath${productItem.itemImageName}");
              }
              //! Add the updated productItem back to the itemDetail list
              updatedItemDetails.add(productItem);
            }

            //! Update the product with the updated itemDetail list
            product = product.copyWith(itemDetail: updatedItemDetails);
            /* + this "if" makes sure that we do not add a product in the list if its itemDetails list is empty + */
            if (product.itemDetail.isNotEmpty) {
              //! Add the updated product to the orderProducts list
              updatedOrderProducts.add(product);
            }
          }

          //! Update the offer with the updated orderProducts list
          offer = offer.copyWith(offerProducts: updatedOrderProducts);
          // log("item is now: ${item.toJson()}");

          // if (authController.userData.value.id.isNotEmpty) {
          //   if (subscriptionsController.mySubscriptions.where((mySub) => mySub.offerId == offer.offerId).isNotEmpty) {
          //     offer = offer.copyWith(isSubscribed: true);
          //   }
          // }
          /* +  && offer.offerProducts.isNotEmpty ==> this makes sure that the offers with empty offer products are not added to final list + */

          if (offer.status.toLowerCase() == "active" && offer.offerProducts.isNotEmpty) subscriptionsController.subscriptionOffersForAllRestaurants.add(offer);
        }

        // await LocalHiveDatabase.saveSiteData(siteData);
      } else {
        // dismissLoading();
        showMsg(msg: "No offers available right now");
      }
      subOffersForAllRestaurantsRetryCount = 0;
    } catch (e) {
      errorLog("error in getSubscriptionOffers catch $e");
      showMsg(msg: "Something wrong please refresh the page to try again");
    }
    isLoadingSubscriptionOffersForAllRestaurants.value = false;
  }

  int signupReferralOffersRetryCount = 0;

  //+ get signup referral offers
  /// Gets Signup Referral Offers
  Future<void> getSignupReferralOffersForMe() async {
    // showCircularLoading();
    isLoadingSignupReferralOffers.value = true;

    WidgetsBinding.instance.addPostFrameCallback((time) {
      subscriptionsController.signupReferralOffers.clear();
    }); // to remove loading indicator from screen after loading instance
    log("restaurantController.selectedRestaurantId.value PASS  INSIDE getSubscriptionOffers ${restaurantController.selectedRestaurantId.value}");
    // errorLog("In getSubscriptionOffers");
    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.signupOffersEndpoint, {"user_id": authController.userData.value.id}).catchError((e) {
      handleError(
        e,
        onError: () {
          if (signupReferralOffersRetryCount <= 5) {
            signupReferralOffersRetryCount++;
            getSignupReferralOffersForMe();
          } else {
            signupReferralOffersRetryCount = 0;
            isLoadingSignupReferralOffers.value = false;
            showMsg(msg: "Something went wrong. Please refresh the page or try after some time.");
          }
        },
      );
    });

    // log("Response of Offers: $response");
    if (response == null) return;

    // log("response is $response");

    String result = response.containsKey("status") ? response["status"] : "error";

    // try {
    if (result == "success") {
      if (response["offers"] != null) {
        // log("result is Success and offers list from response ${response["offers"]}");
        List offers = response["offers"];
        // String imgBasePath = response["responce"]["img_base_path"];
        // String offerImgBasePath = response["responce"]["OFFER_IMG_UPLOAD_PATH_URL"];
        // offerImgBasePath = "${ApiConstants.baseUrl}/$offerImgBasePath";
        // log("imgBasePath: $imgBasePath");

        /* + Check if user is logged in or not and accordingly fetch his/her subscriptions + */

        if (authController.userData.value.id.isNotEmpty) {
          // await getMySubscriptions();
          await getMySubscriptionOrders();
        }

        for (var offerRaw in offers) {
          SignupReferralOffer offer = SignupReferralOffer.fromJson(offerRaw);

          // if (offer.offerImageName.isNotEmpty) {
          //   offer = offer.copyWith(offerImageName: "$offerImgBasePath${offer.offerImageName}");
          // }

          List<OfferProduct> updatedOrderProducts = [];

          /* ! Update the images for offers and items with base url ! */
          // for (var product in offer.offerProducts) {
          //   List<MenuItem> updatedItemDetails = [];
          //
          //   for (var productItem in product.itemDetail) {
          //     if (productItem.itemImageName.isNotEmpty) {
          //       // Update the itemImageName
          //       productItem = productItem.copyWith(
          //         itemImageName: "$imgBasePath${productItem.itemImageName}",
          //       );
          //     }
          //     //! Add the updated productItem back to the itemDetail list
          //     updatedItemDetails.add(productItem);
          //   }
          //
          //   //! Update the product with the updated itemDetail list
          //   product = product.copyWith(itemDetail: updatedItemDetails);
          //   //! Add the updated product to the orderProducts list
          //   updatedOrderProducts.add(product);
          // }

          /* ! Update the offer with the updated orderProducts list !*/
          // offer = offer.copyWith(offerProducts: updatedOrderProducts);
          // log("item is now: ${item.toJson()}");

          /* ! Update the isSubscribed status ! */
          // if (authController.userData.value.id.isNotEmpty) {
          //   // if (subscriptionsController.mySubscriptionsList.where((mySub) => mySub.offerId == offer.offerId).isNotEmpty) {
          //   if (subscriptionsController.mySubscriptionOrders
          //       .where((mySubOrder) => mySubOrder.offerId == offer.offerId && (!['missed', 'cancel', 'cancelled'].contains(mySubOrder.status.toLowerCase())))
          //       .isNotEmpty) {
          //     offer = offer.copyWith(isSubscribed: true);
          //   }
          // }

          if (offer.status.toLowerCase() == "active") {
            subscriptionsController.signupReferralOffers.add(offer);
          }
        }
      } else {
        isLoadingSignupReferralOffers.value = false;
      }
      // await LocalHiveDatabase.saveSiteData(siteData);
    } else {
      // dismissLoading();
      isLoadingSignupReferralOffers.value = false;

      showMsg(msg: "No signup referral offers available right now");
    }
    signupReferralOffersRetryCount = 0;
    // } catch (e) {
    //   errorLog("error in getSubscriptionOffers catch $e");
    //   showMsg(msg: "Something wrong please refresh the page to try again");
    // }
    isLoadingSignupReferralOffers.value = false;
  }

  int specificSignupReferralOfferRetryCount = 0;

  //+ get a specific signup referral offer
  /// Gets a specific Signup Referral Offers
  Future<SubscriptionOffer?> getSpecificSignupReferralOffer(String offerId, {bool shouldDismissLoading = false}) async {
    // showCircularLoading();
    isLoadingSpecificSignupReferralOffer.value = true;

    List<SubscriptionOffer> signupReferralOffers = [];

    WidgetsBinding.instance.addPostFrameCallback((time) {
      subscriptionsController.subscriptionOffers.clear();
    }); // to remove loading indicator from screen after loading instance
    log("restaurantController.selectedRestaurantId.value PASS  INSIDE getSubscriptionOffers ${restaurantController.selectedRestaurantId.value}");
    // errorLog("In getSubscriptionOffers");
    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.subscriptionOffersEndpoint, {
          // "restaurant_id": restaurantController.selectedRestaurantId.value,
          "offer_id": offerId,
        })
        .catchError((e) {
          handleError(
            e,
            onError: () {
              if (specificSignupReferralOfferRetryCount <= 5) {
                specificSignupReferralOfferRetryCount++;
                getSpecificSignupReferralOffer(offerId);
              } else {
                specificSignupReferralOfferRetryCount = 0;
                isLoadingSpecificSignupReferralOffer.value = false;
                // if(shouldDismissLoading) dismissLoading();
                // showMsg(msg: "Something went wrong. Please refresh the page or try after some time.");
                return null;
              }
            },
          );
        });

    // log("Response of Offers: $response");
    if (response == null) return null;

    // log("response is $response");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    // try {
    if (result == "success") {
      if (response["data"] != null && response["data"].isNotEmpty) {
        // log("result is Success and offers list from response ${response["data"]}");
        List offers = response["data"] ?? [];
        String imgBasePath = response["responce"]["img_base_path"];
        String offerImgBasePath = response["responce"]["OFFER_IMG_UPLOAD_PATH_URL"];
        offerImgBasePath = "${ApiConstants.baseUrl}/$offerImgBasePath";
        log("imgBasePath: $imgBasePath");

        /* + Check if user is logged in or not and accordingly fetch his/her subscriptions + */

        // if (authController.userData.value.id.isNotEmpty) {
        //   // await getMySubscriptions();
        //   await getMySubscriptionOrders();
        // }

        for (var offerRaw in offers) {
          SubscriptionOffer offer = SubscriptionOffer.fromJson(offerRaw);

          if (offer.offerImageName.isNotEmpty) {
            offer = offer.copyWith(offerImageName: "$offerImgBasePath${offer.offerImageName}");
          }

          List<OfferProduct> updatedOrderProducts = [];

          for (var product in offer.offerProducts) {
            List<MenuItem> updatedItemDetails = [];

            for (var productItem in product.itemDetail) {
              if (productItem.itemImageName.isNotEmpty) {
                // Update the itemImageName
                productItem = productItem.copyWith(itemImageName: "$imgBasePath${productItem.itemImageName}");
              }
              //! Add the updated productItem back to the itemDetail list
              updatedItemDetails.add(productItem);
            }

            //! Update the product with the updated itemDetail list
            product = product.copyWith(itemDetail: updatedItemDetails);
            //! Add the updated product to the orderProducts list
            updatedOrderProducts.add(product);
          }

          //! Update the offer with the updated orderProducts list
          offer = offer.copyWith(offerProducts: updatedOrderProducts);
          // log("item is now: ${item.toJson()}");

          log("offer.: ${offer.offerName}");
          log("offer.planType.toLowerCase(): ${offer.planType.toLowerCase()}");

          if (authController.userData.value.id.isNotEmpty) {
            // if (subscriptionsController.mySubscriptionsList.where((mySub) => mySub.offerId == offer.offerId).isNotEmpty) {
            if (subscriptionsController.mySubscriptionsList.where((mySub) => mySub.offerId == offer.offerId).isNotEmpty ||
                subscriptionsController.mySubscriptionOrders
                    .where((mySubOrder) => mySubOrder.offerId == offer.offerId && (!['missed', 'cancel', 'cancelled'].contains(mySubOrder.status.toLowerCase())))
                    .isNotEmpty) {
              offer = offer.copyWith(isSubscribed: true);
            }
          }

          if (offer.status.toLowerCase() == "active") {
            signupReferralOffers.add(offer);
          }
        }
      } else {
        isLoadingSpecificSignupReferralOffer.value = false;
        if (shouldDismissLoading) dismissLoading();
        return null;
      }
      // await LocalHiveDatabase.saveSiteData(siteData);
    } else {
      // dismissLoading();
      isLoadingSpecificSignupReferralOffer.value = false;
      // if(shouldDismissLoading) dismissLoading();

      // showMsg(msg: "Offer not available right now");
      return null;
    }
    specificSignupReferralOfferRetryCount = 0;
    // } catch (e) {
    //   errorLog("error in getSubscriptionOffers catch $e");
    //   showMsg(msg: "Something wrong please refresh the page to try again");
    // }
    isLoadingSpecificSignupReferralOffer.value = false;
    // if(shouldDismissLoading) dismissLoading();
    return signupReferralOffers.isNotEmpty ? signupReferralOffers.first : null;
  }

  //+ create a subscription
  /// Creates a subscription for a user for the provided restaurant id
  Future<void> createSubscription() async {
    if (subscriptionsController.stripeFormKey.currentState?.validate() ?? false) {
      subscriptionsController.stripeFormKey.currentState?.save();
      showCircularLoading(isDismissible: false);
      isCreatingSubscription.value = true;
      log("Inside createSubscription function");

      // if (giftCardController.selectedPaymentType.trim().toLowerCase() == "stripe") {
      //   giftCardController.cardToken = await getCardToken(isForGiftcard: true);
      //   if (giftCardController.cardToken.isEmpty) {
      //     isCreatingSubscription.value = false;
      //     return;
      //   }
      // }
      /* */
      // user_id:318
      // offer_id:88
      // offer_duration:month
      // strip_token:null
      // charge_id:null
      // card_number:4242424242424242
      // card_cvv:133
      // card_exp_month:08
      // card_exp_year:2028
      // payment_method:stripe
      // offer_amount:50.0
      // paid_amount:50.0
      // restaurant_id:1
      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.createSubscriptionEndpoint, {
            "user_id": authController.userData.value.id,
            "offer_id": subscriptionsController.selectedOfferId,
            "offer_duration": subscriptionsController.selectedOfferDuration,
            "card_number": subscriptionsController.stripeCardController.text.trim(),
            "card_cvv": subscriptionsController.stripeCVVController.text.trim(),
            "card_exp_month": subscriptionsController.stripeExpiryMonthController.text.trim(),
            "card_exp_year": subscriptionsController.stripeExpiryYearController.text.trim(),
            'payment_method': subscriptionsController.paymentMethod,
            'offer_amount': subscriptionsController.selectedOfferAmount,
            'paid_amount': subscriptionsController.selectedOfferAmount,
            'restaurant_id': restaurantController.selectedRestaurantId.value,
            'plateform': "APP",
          })
          .catchError((e) {
            handleError(
              e,
              onError: () {
                isCreatingSubscription.value = false;
                showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
              },
            );
          });

      log("Response \n $response");

      String result = response.containsKey("status") ? response["status"] : "error";
      if (result == "success") {
        log("Subscription created successfully !");

        if (authController.userData.value.id.isNotEmpty) {
          int indexOfFilteredOffer = subscriptionsController.subscriptionOffers.indexWhere((offer) => offer.offerId == subscriptionsController.selectedOfferId);
          if (indexOfFilteredOffer != -1) {
            var filteredOffer = subscriptionsController.subscriptionOffers[indexOfFilteredOffer];
            filteredOffer = filteredOffer.copyWith(isSubscribed: true);
            subscriptionsController.subscriptionOffers[indexOfFilteredOffer] = filteredOffer;
          }
          // subscriptionsController.subscriptionOffers. = offer.copyWith(isSubscribed: true);
        }

        dismissLoading();
        navigate(type: PageType.offAll, page: const BottomNavBarPage(homeReload: false));
        Future.delayed(Duration(milliseconds: 500), () {
          showMsg(msg: "Subscription created successfully", isSuccess: true, time: Duration(seconds: 5));
          subscriptionsController.clearAll();
        });
        isCreatingSubscription.value = false;
        // giftCardController.isReloadingGiftCardSuccessful = true;
      } else {
        dismissLoading();
        isCreatingSubscription.value = false;
        // showMsg(msg: response['responce']['message']);

        showMsg(msg: "${response["message"]}");

        log("Something wrong");
      }
    } else {
      isCreatingSubscription.value = false;
      log("form not validated");
      // dismissLoading();
      showMsg(msg: "Please enter valid data.");
    }
  }

  int mySubsRetryCount = 0;

  //+ get my subscriptions
  /// Gets User Subscriptions
  Future<void> getMySubscriptions() async {
    // showCircularLoading();
    isLoadingMySubscriptions.value = true;
    subscriptionsController.mySubscriptionsList.clear();
    // errorLog("In getMySubscriptions");
    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.mySubscriptionsEndpoint, {"user_id": authController.userData.value.id}).catchError((e) {
      handleError(
        e,
        onError: () {
          if (mySubsRetryCount <= 5) {
            mySubsRetryCount++;
            getMySubscriptions();
          } else {
            mySubsRetryCount = 0;
            isLoadingMySubscriptions.value = false;
            showMsg(msg: "Something went wrong. Please refresh the page or come back to this page again.");
          }
        },
      );
    });

    if (response == null) return;

    // log("response of getMySubscriptions is :  $response");

    String result = response.containsKey("response")
        ? response["response"].containsKey("status")
              ? response["response"]["status"]
              : ""
        : "error";

    try {
      if (result == "success") {
        List mySubs = response["response"]["records"];
        // log("mySubs: $mySubs");

        for (var subRaw in mySubs) {
          MySubscription mySub = MySubscription.fromJson(subRaw);
          // log("mySub model to Json is ${mySub.toJson()}");

          if (mySub.status.toLowerCase() == "active") {
            subscriptionsController.mySubscriptionsList.add(mySub);
          }
          // log("after adding into list ${subscriptionsController.mySubscriptionsList.value}");
          // for (var mySub in subscriptionsController.mySubscriptionsList) {
          //   log("forEach Restaurant Id inside forEach Loop  : ${mySub.restaurantId} and Record is ${mySub.id} and Offer id ${mySub.offerId}");
          // }
        }

        /* + fetches the latest items for the subscriptions from all restaurants + */
        await getSubscriptionOffersForAllRestaurants();
      } else {
        // dismissLoading();
        showMsg(msg: "No subscriptions right now");
      }
      mySubsRetryCount = 0;
    } catch (e) {
      errorLog("error in getMySubscriptions catch $e");
      showMsg(msg: "Something wrong please refresh the page to try again");
    }
    isLoadingMySubscriptions.value = false;
  }

  int mySubOrdersRetryCount = 0;

  //+ get my subscription orders
  /// Gets User Subscription Orders
  Future<void> getMySubscriptionOrders() async {
    // showCircularLoading();
    isLoadingMySubscriptionOrders.value = true;
    subscriptionsController.mySubscriptionOrders.clear();
    // errorLog("In getMySubscriptions");
    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.mySubscriptionOrdersEndpoint, {"user_id": authController.userData.value.id}).catchError((
      e,
    ) {
      handleError(
        e,
        onError: () {
          if (mySubOrdersRetryCount <= 5) {
            mySubOrdersRetryCount++;
            getMySubscriptionOrders();
          } else {
            mySubOrdersRetryCount = 0;
            isLoadingMySubscriptionOrders.value = false;
            showMsg(msg: "Something went wrong. Please refresh the page or come back to this page again.");
          }
        },
      );
    });

    if (response == null) return;

    // log("response is $response");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    try {
      if (result == "success") {
        List mySubOrders = response["data"]["orders"] ?? [];

        for (var subOrderRaw in mySubOrders) {
          // MySubscriptionOrder mySubOrder = MySubscriptionOrder.fromJson(subOrderRaw);
          MyOrder mySubOrder = MyOrder.fromJson(subOrderRaw);

          // if (mySub.status.toLowerCase() == "active")
          subscriptionsController.mySubscriptionOrders.add(mySubOrder);
        }
      } else {
        // dismissLoading();
        showMsg(msg: "No orders right now");
      }
      mySubOrdersRetryCount = 0;
    } catch (e) {
      errorLog("error in getMySubscriptionOrders catch $e");
      showMsg(msg: "Something wrong please refresh the page to try again or come back to this page again.");
    }
    isLoadingMySubscriptionOrders.value = false;
  }

  //+ buy subscription offer items
  /// Buys the items against a subscription for a user for the provided restaurant id
  Future<void> buyItemsFromSubscriptionOffer({required String offerId, required String offerRestaurantId, bool isSignupOfferOrder = false}) async {
    log("offerRestaurantId to pass inside buyItemsFromSubscriptionOffer $offerRestaurantId");
    showCircularLoading();
    isBuyingItemsFromSubscriptionOffer.value = true;
    log("Inside buyItemsFromSubscriptionOffer function");

    subscriptionsController.mySubscriptionsOfferProducts.removeWhere((product) => product.itemDetail.isEmpty);

    Map<String, dynamic> tempMap = subscriptionsController.selectedOfferItem.value.placeOrderToJson();

    var addons = subscriptionsController.selectedOfferItem.value.addons.where((addon) => subscriptionsController.selectedAddonIds.contains(addon.addonId)).toList();

    tempMap.addAll({
      "size_id": subscriptionsController.selectedOfferItem.value.offerOptions.isNotEmpty
          ? subscriptionsController.selectedOfferItem.value.offerOptions.first.optionId
          : "",
      "size_name": subscriptionsController.selectedOfferItem.value.offerOptions.isNotEmpty
          ? subscriptionsController.selectedOfferItem.value.offerOptions.first.optionName
          : "",
      "item_size_id": subscriptionsController.selectedOfferItem.value.offerOptions.isNotEmpty
          ? subscriptionsController.selectedOfferItem.value.offerOptions.first.itemOptionId
          : "",
      "size_price": subscriptionsController.selectedOfferItem.value.offerOptions.isNotEmpty
          ? subscriptionsController.selectedOfferItem.value.offerOptions.first.price
          : "0",
      "addons": addons.map((e) {
        // e = e.copyWith(finalCost: (double.tryParse(e.price) ?? 0.0) * cartItem.itemCount);
        return e.placeOrderToJson();
      }).toList(),
    });

    Map<String, dynamic> queryMap = {
      "offer_id": offerId,
      "user_id": authController.userData.value.id,
      "no_of_products": "1",
      'restaurant_id': offerRestaurantId,
      // 'restaurant_id': restaurantController.selectedRestaurantId.value,
      "selected_items": jsonEncode(
        [tempMap],
        // subscriptionsController.mySubscriptionsOfferProducts.map(
        //   (product) {
        //     return product.itemDetail.first.placeOrderToJson();
        //   },
        // ).toList(),
      ),
    };

    if (isSignupOfferOrder) {
      queryMap.addAll({"type": "referral"});
    }

    // offer_id:94
    // user_id:318
    // no_of_products:5
    // restaurant_id:2
    // selected_items:[↵{"item_id":"856943","menu_id":"67","item_name":"冰咖啡 Iced Coffee","item_qty":"1","item_cost":"3.50"},{"item_id":"856943","menu_id":"67","item_name":"冰咖啡 Iced Coffee","item_qty":"2","item_cost":"3.50"}]
    unawaited(PusherService.instance.ensureConnected());

    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.buyItemsFromSubscriptionOfferEndpoint, queryMap).catchError((e) {
      handleError(
        e,
        onError: () {
          dismissLoading();
          isBuyingItemsFromSubscriptionOffer.value = false;
          unawaited(PusherService.instance.disconnect());
          showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
        },
      );
    });

    if (response == null) {
      dismissLoading();
      isBuyingItemsFromSubscriptionOffer.value = false;
      unawaited(PusherService.instance.disconnect());
      showMsg(msg: "Something went wrong. We are trying to fix it.");
      return;
    }
    log("Response of buyItemsFromSubscriptionOffer is :  $response");

    String result = response.containsKey("status") ? response["status"] : "error";
    if (result == "success") {
      log("Subscription Order placed successfully !");

      isBuyingItemsFromSubscriptionOffer.value = false;
      dismissLoading();

      final orderId = response["order_id"].toString();
      final invoiceNumber = response["invoice_number"]?.toString() ?? '';

      PusherService.instance.setWaitingOrderId(orderId);
      navigate(
        type: PageType.to,
        page: WaitingPage(
          orderId: orderId,
          flow: OrderWaitFlow.subscription,
          invoiceNumber: invoiceNumber,
          offerId: offerId,
          offerRestaurantId: offerRestaurantId,
        ),
      );
      showMsg(msg: "Order placed successfully.", isSuccess: true);
    } else if (result == "error") {
      log("Error in buyItemsFromSubscriptionOffer: \n $response");
      isBuyingItemsFromSubscriptionOffer.value = false;
      dismissLoading();
      unawaited(PusherService.instance.disconnect());

      showMsg(
        msg:
            response["message"] ??
            response["responce"]["message"] ??
            "There seems to be some issue on our side. We will resolve it as soon as we can. Please try again after some time.!",
      );
      // showMsg(msg: "There seems to be some issue on our side. We will resolve it as soon as we can. Please try again after some time.!");

      log("Something wrong");
    } else {
      isBuyingItemsFromSubscriptionOffer.value = false;
      dismissLoading();
      unawaited(PusherService.instance.disconnect());

      showMsg(msg: "${response["message"]}");

      log("Something wrong");
    }
  }

  //+ cancel a subscription
  /// Cancel a subscription for a user for the provided subscription id
  Future<void> cancelSubscription({required String subId, required String offerId}) async {
    // if (subscriptionsController.stripeFormKey.currentState?.validate() ?? false) {
    //   subscriptionsController.stripeFormKey.currentState?.save();
    log("subId to pass for cancellation: $subId");
    showCircularLoading(isDismissible: false);
    isCancelingSubscription.value = true;
    log("Inside cancelSubscription function");

    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.cancelSubscriptionEndpoint, {"id": subId}).catchError((e) {
      handleError(
        e,
        onError: () {
          isCancelingSubscription.value = false;
          showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
        },
      );
    });

    log("Response of cancelling subscription: \n $response");
    if (response == null) return;
    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      log("Subscription cancelled successfully!");
      if (authController.userData.value.id.isNotEmpty) {
        int indexOfFilteredOffer = subscriptionsController.subscriptionOffers.indexWhere((offer) => offer.offerId == offerId);
        log("indexOfFilteredOffer: $indexOfFilteredOffer");
        if (indexOfFilteredOffer != -1) {
          var filteredOffer = subscriptionsController.subscriptionOffers[indexOfFilteredOffer];
          log("filteredOffer name: ${filteredOffer.offerName}");
          log("filteredOffer isSubscribed: ${filteredOffer.isSubscribed}");
          filteredOffer = filteredOffer.copyWith(isSubscribed: false);
          subscriptionsController.subscriptionOffers[indexOfFilteredOffer] = filteredOffer;
        }
      }
      dismissLoading();
      getMySubscriptions();
      // navigate(type: PageType.offAll, page: const HomeMenuPage(reload: false));
      showMsg(msg: "${response["responce"]["message"] ?? "Subscription cancelled successfully!"}", isSuccess: true);

      isCancelingSubscription.value = false;
    } else {
      dismissLoading();
      isCancelingSubscription.value = false;
      // showMsg(msg: response['responce']['message']);

      showMsg(msg: "${response["responce"]["message"] ?? "Something went wrong"}");

      log("Something wrong");
    }
    // } else {
    //   isCreatingSubscription.value = false;
    //   log("form not validated");
    //   // dismissLoading();
    //   showMsg(msg: "Please enter valid data.");
    // }
  }

  //+ stop subscription auto-renewal
  /// Stop subscription from auto-renewing for the provided subscription id
  Future<void> stopAutoRenewalOfSubscription({required String subId}) async {
    log("Id to Pass for stopping auto-renewal: $subId");
    showCircularLoading(isDismissible: false);
    isStoppingAutoRenewalOfSubscription.value = true;
    log("Inside stopAutoRenewalOfSubscription function");

    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.stopAutoRenewalOfSubscriptionEndpoint, {"id": subId}).catchError((e) {
      handleError(
        e,
        onError: () {
          isStoppingAutoRenewalOfSubscription.value = false;
          showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
        },
      );
    });

    log("Response of stopping auto-renewal: \n $response");

    if (response == null) return;
    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      log("Subscription auto-renewal turned off successfully !");
      dismissLoading();
      await getMySubscriptions();
      // navigate(type: PageType.offAll, page: const HomeMenuPage(reload: false));
      showMsg(msg: "${response["responce"]["message"] ?? "Subscription auto-renewal turned off successfully!"}", isSuccess: true);

      isStoppingAutoRenewalOfSubscription.value = false;
    } else {
      dismissLoading();
      isStoppingAutoRenewalOfSubscription.value = false;
      // showMsg(msg: response['responce']['message']);

      showMsg(msg: "${response["responce"]["message"] ?? "Something went wrong"}");

      log("Something wrong");
    }
  }

  /* ++ ------------------------------------- COUPON SECTION --------------------------------- ++ */

  //+ coupon code details
  /// Gets coupon code details for the order discount
  Future<void> getCouponDiscountCodeDetails(String couponCode) async {
    isLoadingCouponCodeDetails.value = true;
    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.couponDetailsEndpoint, {"coupon": couponCode}).catchError((e) {
      handleError(
        e,
        onError: () {
          isLoadingCouponCodeDetails.value = false;
        },
      );
    });
    if (response == null) return;

    // log("After getting coupon details \n $response");
    log(" \n  Response data in getCouponDiscountCodeDetails  \n $response");

    String result = response.containsKey("status") ? response["status"] : "error";

    if (result == "success") {
      checkoutController.couponPercentageForOrder.value = double.tryParse(response["percentage"]) ?? 0.0;
      checkoutController.isCouponDiscountAppliedAtCheckout = true;
      checkoutController.couponCodeApplied = couponCode;
      checkoutController.getDiscountedPayableTotal();
      showMsg(msg: "Coupon Code successfully applied. You got ${checkoutController.couponPercentageForOrder.value}% discount.", isSuccess: true);
    } else {
      showMsg(msg: "Invalid discount code");
      checkoutController.couponPercentageForOrder.value = 0.0;
      checkoutController.isCouponDiscountAppliedAtCheckout = false;
      checkoutController.couponCodeApplied = "";
      checkoutController.getDiscountedPayableTotal();

      // showMsg(msg: response["responce"]["message"]);
      // showMsg(msg: "Something went wrong while fetching the coupon details. Please try again");
    }
    isLoadingCouponCodeDetails.value = false;
  }

  /* ++ ------------------------------------- COUPON SECTION END --------------------------------- ++ */

  /* ++ ------------------------------------- MEMBERSHIP SECTION --------------------------------- ++ */

  //+ membership categories
  /// Gets membership categories to show on get membership page.
  Future<void> getMembershipCategories() async {
    isLoadingMembershipCategories.value = true;
    var response = await BaseClient().get(ApiConstants.baseUrl, ApiConstants.membershipCategoriesEndpoint).catchError((error) => handleError(error));
    if (response == null) return;

    // log("After getting membership categories \n $response");
    // log(" \n  Response data in getMembershipCategories  \n ${response['data']}");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      membershipController.membershipCategories.clear();
      for (var mc in response["data"]) {
        membershipController.membershipCategories.add(MembershipCategory.fromJson(mc));
      }
    } else {
      showMsg(msg: "Something wrong while fetching the membership categories. Please try again");
    }
    isLoadingMembershipCategories.value = false;
  }

  //+ user membership details
  /// Gets user membership details of the signed in user.
  Future<void> getUserMembershipDetails({bool showSnackOnError = true}) async {
    isLoadingMembershipDetails.value = true;
    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.membershipDetailsEndpoint, {"user_id": authController.userData.value.id})
        .catchError((error) => handleError(error));
    if (response == null) return;

    // log("After getting membership details \n $response");
    // log(" \n  Response data in getUserMembershipDetails  \n ${response['data']}");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      if (response['data'].isNotEmpty) {
        membershipController.userMembershipDetails.value = UserMembershipDetails.fromJson(response['data']);
      }
    } else {
      if (showSnackOnError) showMsg(msg: "Something wrong while fetching the membership details. Please try again");
    }
    isLoadingMembershipDetails.value = false;
  }

  //+ membership card details
  /// Gets membership card details for the order discount
  Future<void> getMembershipCardDetails() async {
    isLoadingMembershipCardDetails.value = true;
    checkoutController.membershipCardNoApplied = checkoutController.membershipCardController.text.trim();
    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.membershipCardDetailsEndpoint, {"cardno": checkoutController.membershipCardController.text.trim()})
        .catchError((e) {
          handleError(
            e,
            onError: () {
              isLoadingMembershipCardDetails.value = false;
              // getMembershipCardDetails();
            },
          );
        });
    if (response == null) return;

    // log("After getting membership card details \n $response");
    // log(" \n  Response data in getMembershipCardDetails  \n ${response['data']}");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      checkoutController.membershipCardPercentageForOrder = double.tryParse(response['data']['percentage']) ?? 0.0;
      checkoutController.membershipCardTypeForOrder = response['data']['category'];
      checkoutController.isMembershipCardAppliedAtCheckout = true;
      checkoutController.getDiscountedPayableTotal();
      showMsg(msg: "Membership card successfully applied. You got ${checkoutController.membershipCardPercentageForOrder}% discount.", isSuccess: true);
    } else {
      showMsg(msg: "Invalid membership card no");
      checkoutController.membershipCardPercentageForOrder = 0.0;
      checkoutController.membershipCardTypeForOrder = "";
      checkoutController.isMembershipCardAppliedAtCheckout = false;
      checkoutController.getDiscountedPayableTotal();

      // showMsg(msg: response["responce"]["message"]);
      // showMsg(msg: "Something went wrong while fetching the membership card details. Please try again");
    }
    isLoadingMembershipCardDetails.value = false;
  }

  //+ sales person discount code details
  /// Gets sales person discount code details for the order discount
  Future<void> getSalesPersonDiscountCodeDetails() async {
    isLoadingSPDiscountCodeDetails.value = true;
    checkoutController.spDiscountCodeApplied = checkoutController.spDiscountCodeController.text.trim();
    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.spDiscountCodeDetailsEndpoint, {"discount_code": checkoutController.spDiscountCodeController.text.trim()})
        .catchError((e) {
          handleError(
            e,
            onError: () {
              isLoadingSPDiscountCodeDetails.value = false;
            },
          );
        });
    if (response == null) return;

    // log("After getting membership card details \n $response");
    // log(" \n  Response data in getMembershipCardDetails  \n ${response['data']}");

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";

    if (result == "success") {
      checkoutController.sPDiscountPercentageForOrder = double.tryParse(response['data']['discount_percent']) ?? 0.0;
      // checkoutController.membershipCardTypeForOrder = response['data']['category'];
      checkoutController.isSPDiscountAppliedAtCheckout = true;
      checkoutController.getDiscountedPayableTotal();
      showMsg(msg: "Discount Code successfully applied. You got ${checkoutController.sPDiscountPercentageForOrder}% discount.", isSuccess: true);
    } else {
      showMsg(msg: "Invalid discount code");
      checkoutController.sPDiscountPercentageForOrder = 0.0;
      checkoutController.isSPDiscountAppliedAtCheckout = false;
      checkoutController.getDiscountedPayableTotal();

      // showMsg(msg: response["responce"]["message"]);
      // showMsg(msg: "Something went wrong while fetching the membership card details. Please try again");
    }
    isLoadingSPDiscountCodeDetails.value = false;
  }

  //+ buy membership as un-registered user
  /// Buys membership for an un-registered user.
  /// This will also register the user.
  Future<void> buyMembershipAsStranger() async {
    if (membershipController.buyMembershipFormKey.currentState?.validate() ?? false) {
      membershipController.buyMembershipFormKey.currentState?.save();
      isBuyingMembershipAsStranger.value = true;
      log("Inside buyMembershipAsStranger function");

      if (membershipController.selectedPaymentType.trim().toLowerCase() == "stripe") {
        membershipController.cardToken = await getCardToken(isForMembership: true);
        if (membershipController.cardToken.isEmpty) {
          isBuyingMembershipAsStranger.value = false;
          return;
        }
      }

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.buyMembershipAsStrangerEndpoint, {
            'type': membershipController.selectedMembershipCategory.category,
            "stripe_token": membershipController.cardToken,
            // 'card_name': membershipController.stripeNameController.text.trim(),
            // 'card_number': membershipController.stripeCardController.text.trim(),
            // 'card_cvc': membershipController.stripeCVVController.text.trim(),
            // 'card_exp_day': membershipController.stripeExpiryMonthController.text.trim(),
            // 'card_exp_year': membershipController.stripeExpiryYearController.text.trim(),
            'first_name': membershipController.buyMembershipFirstNameController.text.trim(),
            'last_name': membershipController.buyMembershipLastNameController.text.trim(),
            'email': membershipController.buyMembershipEmailController.text.trim(),
            // 'Confirm_email': membershipController.buyMembershipConfirmEmailController.text.trim(),
            'phone': normalizeUsPhoneNumber(membershipController.buyMembershipPhoneNumController.text.trim()) ?? "",
            'date_of_birth': getFormattedDate(membershipController.buyMembershipDobController.text.trim()), //03-04-2000
            'password': membershipController.buyMembershipPasswordController.text.trim(),
            'referral_code': membershipController.buyMembershipReferralController.text.trim(),
          })
          .catchError((error) => handleError(error));

      log("Response \n $response");

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        log("Membership bought successfully and hopefully email is also sent !");
        showMsg(msg: response['responce']['message'], isSuccess: true);
        // showMsg(msg: "Membership bought successfully.", isSuccess: true);

        authController.isActivationLinkSent.value = true;
        authController.activationLinkEmail.value = membershipController.buyMembershipEmailController.text.trim();
        authController.activateEmailController.text = membershipController.buyMembershipEmailController.text.trim();
        navigate(type: PageType.offAll, page: const ActivateAccountPage());
        Future.delayed(const Duration(milliseconds: 700), () {
          isBuyingMembershipAsStranger.value = false;
          authController.loading.value = false;
          membershipController.clearBuyMembershipControllers();
        });
      } else {
        isBuyingMembershipAsStranger.value = false;
        if (response['responce']['message'].runtimeType == String) {
          showMsg(msg: response['responce']['message']);
        } else {
          showMsg(msg: response['responce']['message'].values.join(". "));
        }
        log("Something wrong in buyMembershipAsStranger");
      }
    } else {
      log("form not validated");
      isBuyingMembershipAsStranger.value = false;
      showMsg(msg: "Please enter valid data.");
    }
  }

  //+ buy membership as registered user
  /// Buys membership for a registered user.
  Future<void> buyMembershipAsMember() async {
    if (membershipController.buyMembershipFormKey.currentState?.validate() ?? false) {
      membershipController.buyMembershipFormKey.currentState?.save();
      isBuyingMembershipAsMember.value = true;
      log("Inside buyMembershipAsStranger function");

      if (membershipController.selectedPaymentType.trim().toLowerCase() == "stripe") {
        membershipController.cardToken = await getCardToken(isForMembership: true);
        if (membershipController.cardToken.isEmpty) {
          isBuyingMembershipAsMember.value = false;
          return;
        }
      }

      var response = await BaseClient()
          .post(ApiConstants.baseUrl, ApiConstants.buyMembershipAsMemberEndpoint, {
            'user_id': authController.userData.value.id,
            'type': membershipController.selectedMembershipCategory.category,
            "stripe_token": membershipController.cardToken,
            // 'card_name': membershipController.stripeNameController.text.trim(),
            // 'card_number': membershipController.stripeCardController.text.trim(),
            // 'card_cvc': membershipController.stripeCVVController.text.trim(),
            // 'card_exp_day': membershipController.stripeExpiryMonthController.text.trim(),
            // 'card_exp_year': membershipController.stripeExpiryYearController.text.trim(),
          })
          .catchError((error) => handleError(error));

      log("Response \n $response");

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      if (result == "success") {
        try {
          await Future.wait([getUpdatedProfileData(showSnackOnError: false), membershipController.getMembershipData(showSnackOnError: false)]);
        } catch (e) {
          log("error occurred while refreshing profile and membership together: $e");
        }
        isBuyingMembershipAsMember.value = false;
        log("Membership bought successfully!");
        // Get.back(); //! for going back to Membership Cards page
        // Get.back(); //! for going back to Membership Info page in profile or to Gift Card Store
        navigate(type: PageType.offAll, page: const BottomNavBarPage(homeReload: false));
        // navigate(type: PageType.offAll, page: const HomeMenuPage(reload: false));
        showMsg(msg: "Membership bought successfully. Go to your profile to view your membership details.", isSuccess: true, time: const Duration(seconds: 4));
        // showMsg(msg: response['responce']['message'], isSuccess: true);

        Future.delayed(const Duration(milliseconds: 700), () {
          isBuyingMembershipAsMember.value = false;
          membershipController.clearBuyMembershipControllers();
        });
      } else {
        isBuyingMembershipAsMember.value = false;
        if (response['responce']['message'].runtimeType == String) {
          showMsg(msg: response['responce']['message']);
        } else {
          showMsg(msg: response['responce']['message'].values.join(". "));
        }
        log("Something wrong in buyMembershipAsStranger");
      }
    } else {
      isBuyingMembershipAsMember.value = false;
      log("form not validated");
      showMsg(msg: "Please enter valid data.");
    }
  }

  /* ++ ------------------------------------- MEMBERSHIP SECTION END --------------------------------- ++ */

  //+ delete user account
  /// Deletes the user account and all associated data from our servers
  Future<void> deleteUserAccount() async {
    isDeletingUser.value = true;
    log("Inside deleteUserAccount function");

    var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.deleteAccountEndpoint, {'user_id': authController.userData.value.userId}).catchError((e) {
      handleError(
        e,
        onError: () {
          // isDeletingUser.value = false;
          // showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
          // deleteUserAccount();
          isDeletingUser.value = false;
          showMsg(msg: "Your data couldn't be deleted for some unknown reason. Please try again in some time.");
        },
      );
    });

    log("Response \n $response");

    if (response == null) {
      showMsg(msg: "Your data couldn't be deleted for some unknown reason. Please try again in some time.");
      return;
    }

    String result = response.containsKey("responce")
        ? response["responce"].containsKey("status")
              ? response["responce"]["status"]
              : ""
        : "error";
    if (result == "success") {
      log("User deleted successfully !");
      authController.logout(showMessage: false);
      navigate(type: PageType.offAll, page: const LoginPage());
      showMsg(msg: response['responce']['message'], isSuccess: true);
      // showMsg(msg: "Card bought successfully.", isSuccess: true);
    } else {
      if (response["responce"].containsKey("message")) {
        if (response["responce"]['message'].runtimeType == String) {
          showMsg(msg: response['responce']['message']);
        } else {
          showMsg(msg: response['responce']['message'].values.join(" "));
        }
      }
      log("Something wrong");
    }
    isDeletingUser.value = false;
  }

  //+ Check ISDelivery Order Allowed
  /// Check is Delivery Order Allowed or Not.

  Future<void> getIsDeliveryOrderAllowed() async {
    log("inside getIsDeliveryOrderAllowed api Controller ");
    log("ApiConstants.baseUrl ${ApiConstants.baseUrl} \n ${ApiConstants.isDeliveryOrderAllowed}");
    isLoadingCheckingDeliveryOrderAllowed.value = true;
    String restaurantId = restaurantController.selectedRestaurantId.value;
    log("restaurantId to pass $restaurantId in getIsDeliveryOrderAllowed api Controller ");
    var response = await BaseClient()
        .get(
          ApiConstants.baseUrl,
          // ApiConstants.isDeliveryOrderAllowed,
          "${ApiConstants.isDeliveryOrderAllowed}?resturant_id=$restaurantId",
        )
        .catchError((e) {
          handleError(e, onError: () {});
        });
    if (response == null) return;

    log("Response of getIsDeliveryOrderAllowed  \n $response");

    String result = response.containsKey("status") ? response["status"] : "error";

    if (result == "success") {
      checkoutController.deliveryAllowedModel.value = DeliveryAllowedModel.fromJson(response as Map<String, dynamic>);
      log("Delivery Order Model toJson() :  ${checkoutController.deliveryAllowedModel.value.toJson()}");
    } else {
      log("Delivery setting was empty");
      checkoutController.deliveryAllowedModel.value = DeliveryAllowedModel(status: "success", isDeliveryOrderAllow: "No");
      // showMsg(msg: "");
    }
    isLoadingCheckingDeliveryOrderAllowed.value = false;
  }

  //+ update profile data
  /// Update user profile
  Future<void> contactFormSubmission({
    required String firstName,
    required String lastName,
    required String email,
    required String accountEmail,
    required String phone,
    required String message,
  }) async {
    isSubmittingContactForm.value = true;
    log("Inside updateProfile function");

    showCircularLoading(isDismissible: false);

    var response = await BaseClient()
        .post(ApiConstants.baseUrl, ApiConstants.contactFormSubmissionEndpoint, {
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'account_email': accountEmail.isEmpty ? email : accountEmail,
          'phone': normalizeUsPhoneNumber(phone) ?? "",
          'message': message,
        })
        .catchError((e) {
          handleError(
            e,
            onError: () {
              isSubmittingContactForm.value = false;
              dismissLoading();
              showMsg(msg: "Something went wrong. Please make sure you have a stable internet connection and try again.");
            },
          );
        });

    log("Response \n $response");

    String result = response.containsKey("status") ? response["status"] : "error";

    if (result == "success") {
      log("contact form submitted successfully");

      dismissLoading();
      // Get.back();
      showMsg(msg: "Form submitted successfully.", isSuccess: true);
      isSubmittingContactForm.value = false;
    } else {
      dismissLoading();
      isSubmittingContactForm.value = false;
      showMsg(msg: response['responce']['message']);
      log("Something wrong");
    }
  }

  Future getTermsHtml() async {
    infoLog("In getTermsHtml");
    isLoadingTermsHtml.value = true;

    var response = await BaseClient().getUnprocessed(ApiConstants.baseUrl, ApiConstants.termsHtmlEndpoint).catchError((error) {
      handleError(error);
      isLoadingTermsHtml.value = false;
    });

    if (response == null) return;

    isLoadingTermsHtml.value = false;

    return response;
  }

  Future getPrivacyHtml() async {
    infoLog("In getPrivacyHtml");
    isLoadingPrivacyHtml.value = true;

    var response = await BaseClient().getUnprocessed(ApiConstants.baseUrl, ApiConstants.privacyHtmlEndpoint).catchError((error) {
      handleError(error);
      isLoadingPrivacyHtml.value = false;
    });

    if (response == null) return;

    isLoadingPrivacyHtml.value = false;

    return response;
  }
}
