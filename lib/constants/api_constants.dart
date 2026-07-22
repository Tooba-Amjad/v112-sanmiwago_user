import 'package:sanmiwago_user/utils/enums.dart';

class ApiConstants {
  static EnvType env = EnvType.dev;
  static String baseUrl = "";
  static String appTag = "";
  static String apiRequestFrom = "userapp";

  static const String loginEndpoint = "/user-login";
  static const String userPointsEndpoint = "/userapp/user_points";
  static const String saveUserFCMEndpoint = "/userapp-fcm-token-add";

  static const String registerEndpoint = "/user-register";
  static const String sendOTPEndpoint = "/auth-register-sendphoneotp";
  static const String verifyOTPEndpoint = "/auth-register-verifyphoneotp";

  static const String userInfoEndpoint = "/user-info";
  static const String userPromosEndpoint = "/user-promotions";
  static const String updateProfileEndpoint = "/user-modify-profile";
  static const String updateProfileImageEndpoint = "/user-modify-profile-image";
  static const String resendActivationEmailEndpoint = "/resend-link";
  static const String updatePasswordEndpoint = "/user-modify-password";
  static const String forgotPasswordEndpoint = "/user-forgot-password";
  static const String forgotUsernameStep1Endpoint = "/user-reset-username-step1";
  static const String forgotUsernameStep2Endpoint = "/user-reset-username-step2";

  static const String myOrdersListEndpoint = "/user-order-list";
  static const String myPointsListEndpoint = "/user-points";

  static const String menuListEndpoint = "/menu-list";
  static const String restaurantsListEndpoint = "/restaurant-list";
  static const String itemListEndpoint = "/item-list";
  static const String itemAddonsEndpoint = "/item-addons";
  static const String itemOptionsEndpoint = "/item-options";
  static const String statesListEndpoint = "/states-list";
  static const String userInfoAndAddressEndpoint = "/fetch-user-info";
  static const String distanceAndDeliveryFeeEndpoint = "/fetch-user-distance";

  /// cart-sync to later send notification to users about cart not being empty
  static const String cartSyncEndpoint = "/api/cart-sync-for-notification";
  static const String deleteSyncedCartEndpoint = "/api/cart-notification-delete";

  static const String placeOrderEndpoint = "/place-order";
  static const String orderViewEndpoint = "/order-view";
  static const String fetchPusherInfoEndpoint = "/fetch-pusher-info";
  static const String doorDashOrderViewEndpoint = "/doordash-record";
  // http://154.53.38.135/sanmiwago/doordash-record?order_id=14443

  static const String driverLocationEndpoint = "/driver-live-tracking-fetch";

  static const String myReferralOrdersEndpoint = "/my-refferel-orders";
  static const String myReferredUsersEndpoint = "/my-lever1-referel";

  static const String giftCardsEndpoint = "/gift-cards";
  static const String buyGiftCardEndpoint = "/buy_giftcard";
  static const String reloadGiftCardEndpoint = "/reload-Balance";
  static const String getGiftCardDetailsEndpoint = "/check-Balance";

  static const String recoverGiftCardEndpoint = "/recover-gift-card";
  static const String recoverVerifyOTPGiftCardEndpoint = "/rcg-verify-otp";
  static const String recoverResendOTPGiftCardEndpoint = "/rcg-resend-otp";

  static const String subscriptionOffersEndpoint = "/offerapi/offers-list";
  static const String createSubscriptionEndpoint = "/offerapi/subscribe-offer-create";
  static const String mySubscriptionsEndpoint = "/offerapi/subscription-list";
  static const String mySubscriptionOrdersEndpoint = "/offerapi/user_offers_orders";
  static const String buyItemsFromSubscriptionOfferEndpoint = "/offerapi/create-offer-subscription-order";
  static const String cancelSubscriptionEndpoint = "/offerapi/subsciption/cancel";
  static const String stopAutoRenewalOfSubscriptionEndpoint = "/offerapi/subsciption/stop-auto-renew";

  static const String signupOffersEndpoint = "/signup-referral/offers";

  static const String buyMembershipAsStrangerEndpoint = "/buy-membership";
  static const String buyMembershipAsMemberEndpoint = "/user-membership-buy";
  static const String membershipCategoriesEndpoint = "/membership-categories";
  static const String membershipDetailsEndpoint = "/membership-data";
  static const String membershipCardDetailsEndpoint = "/membership-card-info";
  static const String spDiscountCodeDetailsEndpoint = "/sale-person-discount-info";
  static const String couponDetailsEndpoint = "/api/apply_coupon";

  static const String salesTaxEndpoint = "/sale-tax";
  static const String siteInfoEndpoint = "/site-info";
  static const String workingHoursEndpoint = "/working-hours";
  static const String deleteAccountEndpoint = "/remove-account";

  static const String getDefaultGiftcardRestaurantEndpoint = "/giftcards-strip-account";
  static const String cardTokenEndpoint = "/generate-token";
  static const String stripeBaseUrl = "https://api.stripe.com";
  static const String stripeCardTokenEndpoint = "/v1/tokens";

  static const String isDeliveryOrderAllowed = "/delivery-order";
  static const String contactFormSubmissionEndpoint = "/api/page/contact-us";
  static const String termsHtmlEndpoint = "/api/page/show?slug=terms-conditions&request_from=userapp";
  static const String privacyHtmlEndpoint = "/api/page/show?slug=privacy-policy&request_from=userapp";

  static setEnvironment({required var newEnv}) {
    env = newEnv.runtimeType == String ? getEnvEnum(newEnv) : newEnv;
    switch (env) {
      case EnvType.dev:
        baseUrl = "http://66.94.117.208/sanmiwago";
        appTag = "DEV";
        break;
      case EnvType.ddev:
        baseUrl = "http://154.38.186.10/sanmiwago";
        appTag = "D-DEV";
        break;
      case EnvType.merge:
        baseUrl = "http://154.53.38.135/sanmiwago";
        appTag = "MERGE";
        break;
      case EnvType.prod2:
        baseUrl = "https://sanmiwagomeals.com/sanmiwagolatest";
        appTag = ""; // "PROD-2";
        break;
      case EnvType.prod1:
        baseUrl = "http://sanmiwagocuisine.com/sanmiwagolatest";
        // baseUrl = "http://89.117.72.18/sanmiwago-mgrv45";
        // baseUrl = "http://89.117.72.18/sanmiwago-mgrv43";
        // baseUrl = "http://89.117.72.18/sanmiwago-posv79";
        appTag = "PROD-1";
        break;
      case EnvType.prod1old:
        baseUrl = "http://89.117.72.18";
        appTag = "PROD1-OLD";
        break;
      case EnvType.prod1new:
        baseUrl = "http://89.117.72.18/sanmiwago-new";
        appTag = "PROD1-NEW";
        break;
      case EnvType.prodaws:
        baseUrl = "https://sanmiwagocuisine.com";
        // baseUrl = "https://sanmiwagomeals.com";
        // baseUrl = "https://sanmiwagodumpling.com";
        appTag = "PROD-AWS";
        break;
      case EnvType.prodbackup:
        // baseUrl = "http://sanmiwagocuisine.com";
        baseUrl = "http://89.117.72.18/sanmiwago-backup";
        // baseUrl = "https://sanmiwagodumpling.com";
        appTag = "PROD-BACKUP";
      case EnvType.prod:
        baseUrl = "https://sanmiwagomeals.com/sanmiwagolatest";
        // baseUrl = "http://sanmiwagocuisine.com";
        // baseUrl = "https://sanmiwagomeals.com";
        // baseUrl = "https://sanmiwagodumpling.com";
        appTag = "";
        break;
      default:
        baseUrl = "https://sanmiwagofood.com/sanmiwago";
        // baseUrl = "https://sanmiwagodumpling.com";
        appTag = "";
    }
  }

  static getEnvEnum(String myenv) {
    return EnvType.values.firstWhere((fenv) => fenv.toString().split('.').last == myenv, orElse: () => EnvType.merge);
  }
}
