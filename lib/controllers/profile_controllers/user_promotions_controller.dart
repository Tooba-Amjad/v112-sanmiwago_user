import 'package:get/get.dart';
import 'package:sanmiwago_user/models/user_model/user_promotions_model.dart';

import '../../constants/controller_instances.dart';

class UserPromoController extends GetxController {
  static UserPromoController instance = Get.find<UserPromoController>();

  RxList<UserPromotion> myUserPromosList = RxList<UserPromotion>.from([]);

  Rx<UserPromotion> selectedUserPromo = UserPromotion().obs;

  RxString clickedOrderId = "".obs;


  getPromotions() async {
    await apiController.getUserPromotions();
  }

}
