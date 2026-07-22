import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/my_points_model.dart';

class MyPointsController extends GetxController {
  static MyPointsController instance = Get.find<MyPointsController>();

  int currentOffset = 0;

  RxList<MyPoints> myPointsList = RxList<MyPoints>.from([]);

  getMyPointsList() {
    apiController.getMyPointsList();
  }

  logout() {
    currentOffset = 0;
    myPointsList.clear();
    apiController.isLoadingMyPoints.value = true;
  }

}