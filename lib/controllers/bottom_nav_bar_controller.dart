import 'package:get/get.dart';
import 'package:sanmiwago_user/services/base_controller_mixin.dart';

class BottomNavBarController extends GetxController with BaseController {
  static BottomNavBarController instance = Get.find<BottomNavBarController>();
  RxInt selectedIndex = 4.obs;

  updateIndex(int index) {
    selectedIndex.value = index;
  }
}
