import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/my_referral_models/my_referral_order_model.dart';
import 'package:sanmiwago_user/models/my_referral_models/my_referred_user_model.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';

class MyReferralsController extends GetxController {
  static MyReferralsController instance = Get.find<MyReferralsController>();

  int currentOffset = 0;

  RxList<MyReferredUser> myReferredUsersList = RxList<MyReferredUser>.from([]);
  // RxList<MyReferralOrder> myOrdersList = RxList<MyReferralOrder>.from([]);
  RxList<MyReferralOrder> myReferralOrdersList = RxList<MyReferralOrder>.from([]);

  getMyReferralOrdersList({bool enforceOffset = false}) {
    apiController.getMyReferralOrdersList(enforceOffset: enforceOffset);
  }

  getMyReferredUsersList() {
    myReferredUsersList.clear();
    apiController.getMyReferredUsersList();
  }

  logout() {
    currentOffset = 0;
    // myOrdersList.clear();
    myReferralOrdersList.clear();
    apiController.isLoadingMyOrders.value = true;
  }

}
