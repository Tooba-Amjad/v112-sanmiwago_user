import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/doordash_order_view_model.dart';
import 'package:sanmiwago_user/models/my_orders_model.dart';
import 'package:sanmiwago_user/models/order_view_model.dart';

class MyOrdersController extends GetxController {
  static MyOrdersController instance = Get.find<MyOrdersController>();

  int currentOffset = 0;
  RxList<MyOrder> myOrdersList = RxList<MyOrder>.from([]);
  Rx<OrderViewModel> selectedOrderData = OrderViewModel(order: Order()).obs;
  RxString clickedOrderId = "".obs;

  getOrderDetails(String orderId, {bool shouldDismiss = false}) async {
    selectedOrderData.value = OrderViewModel(order: Order());
    await apiController.getOrderViewData(orderId, shouldDismiss: shouldDismiss);
  }

  Rx<DoorDashOrderViewModel> doorDashSelectedOrderData = DoorDashOrderViewModel().obs;

  getDoorDashOrderDetails(String orderId) async {
    doorDashSelectedOrderData.value = DoorDashOrderViewModel();
    await apiController.getDoorDashOrderViewData(orderId);
  }

  logout() {
    currentOffset = 0;
    myOrdersList.clear();
    apiController.isLoadingMyOrders.value = true;
  }
}
