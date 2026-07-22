import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/utils/enums.dart';
import 'package:sanmiwago_user/utils/helpers.dart';
import 'package:sanmiwago_user/views/pages/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:sanmiwago_user/views/pages/order_placed_result/order_placed_page.dart';
import 'package:sanmiwago_user/views/pages/order_placed_result/order_rejected_missed_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/subscription_order_placed_page.dart';
import 'package:sanmiwago_user/views/pages/subscriptions/subscription_order_rejected_missed_page.dart';

/// Shared navigation rules for cart and subscription order accept/reject waiting.
class OrderWaitHelper {
  OrderWaitHelper._();

  static bool isTerminalStatus(String? status) {
    if (status == null || status.isEmpty) return false;
    return status == 'accept' || status == 'delivered' || status == 'missed' || status == 'cancelled';
  }

  static Future<void> navigateForStatus({
    required String status,
    required OrderWaitFlow flow,
    required String orderId,
    String invoiceNumber = '',
    String offerId = '',
    String offerRestaurantId = '',
  }) async {
    if (Get.currentRoute != '/WaitingPage') return;

    final resolvedInvoice = invoiceNumber.isNotEmpty
        ? invoiceNumber
        : orderController.selectedOrderData.value.order.invoiceNumber;
    final resolvedOrderId = orderId.isNotEmpty
        ? orderId
        : orderController.selectedOrderData.value.order.orderId;

    if (flow == OrderWaitFlow.cart) {
      await _navigateCart(status: status);
      return;
    }

    await _navigateSubscription(
      status: status,
      orderId: resolvedOrderId,
      invoiceNumber: resolvedInvoice,
      offerId: offerId,
      offerRestaurantId: offerRestaurantId,
    );
  }

  static Future<void> _navigateCart({required String status}) async {
    if (status == 'missed') {
      navigate(type: PageType.off, page: const OrderRejectedMissedPage(isRejected: false));
      return;
    }

    if (status == 'accept' || status == 'delivered') {
      apiController.getUserPoints();
      await orderController.clearOrderData();
      navigate(type: PageType.off, page: const OrderPlacedPage());
      return;
    }

    if (status == 'cancelled') {
      navigate(type: PageType.off, page: const OrderRejectedMissedPage(isRejected: true));
    }
  }

  static Future<void> _navigateSubscription({
    required String status,
    required String orderId,
    required String invoiceNumber,
    required String offerId,
    required String offerRestaurantId,
  }) async {
    if (status == 'missed') {
      navigate(
        type: PageType.off,
        page: SubscriptionOrderRejectedMissedPage(
          isRejected: false,
          orderId: orderId,
          invoiceNumber: invoiceNumber,
          offerId: offerId,
          offerRestaurantId: offerRestaurantId,
        ),
      );
      return;
    }

    if (status == 'accept' || status == 'delivered') {
      final index = subscriptionsController.subscriptionOffers.indexWhere((element) => element.offerId == offerId);
      if (index != -1) {
        subscriptionsController.subscriptionOffers[index] =
            subscriptionsController.subscriptionOffers[index].copyWith(isSubscribed: true);
      }

      navigate(
        type: PageType.off,
        page: SubscriptionOrderPlacedPage(orderId: orderId, invoiceNumber: invoiceNumber),
      );
      return;
    }

    if (status == 'cancelled') {
      navigate(
        type: PageType.off,
        page: SubscriptionOrderRejectedMissedPage(
          isRejected: true,
          orderId: orderId,
          invoiceNumber: invoiceNumber,
          offerId: offerId,
          offerRestaurantId: offerRestaurantId,
        ),
      );
    }
  }

  static void navigateAfterTimeout({required OrderWaitFlow flow}) {
    navigate(
      type: PageType.offAll,
      page: !authController.isLoggedIn.value ? const BottomNavBarPage(homeReload: false) : const BottomNavBarPage(),
    );
  }
}
