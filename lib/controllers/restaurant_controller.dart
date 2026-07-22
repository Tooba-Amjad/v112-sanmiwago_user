import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/data/shared_pref.dart';
import 'package:sanmiwago_user/models/restaurant_model.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/pages/bottom_nav_bar/bottom_nav_bar.dart';

class RestaurantController extends GetxController {
  static RestaurantController instance = Get.find<RestaurantController>();

  RxList<Restaurant> restaurants = RxList<Restaurant>.from([]);
  Rx<Restaurant> selectedRestaurant = Restaurant().obs;
  RxString selectedRestaurantId = "".obs;
  RxString selectedRestaurantAddress = "".obs;
  RxString selectedRestaurantPhone = "".obs;

  /// Calls apiController's method to get the list of restaurants here
  getRestaurantsList() {
    apiController.getRestaurants();
  }

  selectFirstRestaurant() {
    if (restaurants.isNotEmpty && selectedRestaurantId.value.isEmpty) {
      selectedRestaurantId.value = restaurants.first.id;
      selectedRestaurantAddress.value = restaurants.first.address;
      selectedRestaurantPhone.value = restaurants.first.phone;
      LocalSharedPrefDatabase.setSelectedBranchId(restaurants.first.id);
      LocalSharedPrefDatabase.setSelectedBranchAddress(restaurants.first.address);
      LocalSharedPrefDatabase.setSelectedBranchPhone(restaurants.first.phone);
      selectedRestaurant.value = restaurants.first;
    }
  }

  Timer? _debounceTimer;

  updateSelectedRestaurant(String branchId, String branchAddress, String branchPhone,
      {required Restaurant restaurant, bool isFromSplash = false, bool isFromBottomNavBarPage = false}) {
    if (orderController.cartItems.isEmpty || selectedRestaurantId.value == branchId) {
      // Cancel any existing debounce timer
      _debounceTimer?.cancel();
      selectedRestaurantId.value = branchId;
      selectedRestaurantAddress.value = branchAddress;
      selectedRestaurantPhone.value = branchPhone;
      LocalSharedPrefDatabase.setSelectedBranchId(branchId);
      LocalSharedPrefDatabase.setSelectedBranchAddress(branchAddress);
      LocalSharedPrefDatabase.setSelectedBranchPhone(branchPhone);
      selectedRestaurant.value = restaurant;
      // Set a debounce duration (e.g., 300ms)
      _debounceTimer = Timer(Duration(milliseconds: 300), () {
        catItemController.getCategoryList();
      });

      // if(isFromSplash) {
      // navigate(type: PageType.offAll, page: const HomeMenuPage(reload: false));
      log("Checking isFromBottomNavBarPage $isFromBottomNavBarPage");

      if (isFromBottomNavBarPage) {
        return;
      } else {
        if (authController.isLoggedIn.value) {
          navigate(type: PageType.offAll, page: const BottomNavBarPage());
        } else {
          navigate(type: PageType.offAll, page: const BottomNavBarPage(homeReload: false));
          // navigate(type: PageType.offAll, page: const HomeMenuPage(reload: false));
        }
      }
      // }
    } else {
      showMsg(msg: "You cannot change the branch when you have items in your cart.");
    }
  }
}
