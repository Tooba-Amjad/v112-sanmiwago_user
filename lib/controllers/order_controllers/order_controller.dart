import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/data/local_db.dart';
import 'package:sanmiwago_user/models/cart.dart';
import 'package:sanmiwago_user/models/cart_item_extensions.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';
import 'package:sanmiwago_user/models/order_view_model.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:uuid/uuid.dart';

class OrderController extends GetxController {
  static OrderController instance = Get.find<OrderController>();

  //+ cart data
  RxDouble cartTotal = 0.0.obs;

  RxDouble discount = 0.0.obs;

  String cartId = Uuid().v4();

  RxDouble calculatedSalesTax = 0.0.obs;
  RxList<MenuItem> cartItems = RxList<MenuItem>.from([]); //+ to add items to be ordered
  Rx<OrderViewModel> selectedOrderData = OrderViewModel(order: Order()).obs;

  //+ --- Database Methods ---
  Future<void> saveCartToDb() async {
    final cart = Cart()
      ..items = cartItems.map((item) => item.toCartItem()).toList()
      ..localCartId = cartId;
    await LocalDatabase.saveCart(cart);
    log("Cart saved to local database.");
    await apiController.cartSyncForNotEmptyNotification();
    log("Cart saved to live database.");
  }

  Future<void> loadCartFromDb() async {
    print("OrderController: loadCartFromDb called");
    final cart = await LocalDatabase.getCart();
    print("OrderController: Cart loaded from local database. isarId: ${cart?.isarId}, localCartId: ${cart?.localCartId}, items.length: ${cart?.items.length ?? 0}");
    if (cart != null) {
      cartItems.value = cart.items.map((item) => item.toMenuItem()).toList();
      cartId = cart.localCartId;
      print("OrderController: Cart loaded from local database with ${cartItems.length} items");
      // Recalculate sales tax after loading
      recalculateSalesTax();
      checkoutController.getDiscountedPayableTotal();
    } else {
      print("OrderController: No cart found in database (cart is empty)");
      clearOrderData();
    }
  }

  Future<void> clearLocalCartFromDb() async {
    print("OrderController: Clearing cart from local database...");
    await LocalDatabase.deleteCart();
    print("OrderController: Cart cleared from local database");

    await apiController.deleteSyncedCartForNotEmptyNotification(cartId);
    print("OrderController: Cart cleared from live database");
    cartId = Uuid().v4();
    print("OrderController: New cartId generated: $cartId");
  }

  //+ ------------------------

  void recalculateSalesTax() {
    calculatedSalesTax.value =
        (((orderController.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice) - discount.value) / 100) *
        siteDataController.salesTax.value);
  }

  //+ ------------------------

  addToCart(BuildContext context) {
    //+ just remove this if to let the user add similar id products with same/or
    //! different options and/or addons after related changes have already been done on the backend.
    // isItemAlreadyThere = cartItems.firstWhere((element) => element.itemId == catItemController.selectedItem.value.itemId, orElse: () => const MenuItem()).itemId.isNotEmpty;
    List<MenuItemAddon> addonsNewList = [];
    for (String addonId in catItemController.selectedAddonIds) {
      addonsNewList.add(catItemController.selectedItem.value.addons.firstWhere((element) => element.addonId == addonId));
    }

    catItemController.selectedItem.value = catItemController.selectedItem.value.copyWith(
      totalPrice: catItemController.itemTotal.value,
      itemCount: catItemController.itemCount.value,
      note: catItemController.noteController.text.trim(),
      addons: addonsNewList,
      options: catItemController.selectedOptionId.value.isNotEmpty
          ? [catItemController.selectedItem.value.options.firstWhere((element) => element.optionId == catItemController.selectedOptionId.value)]
          : [],
    );
    cartItems.add(catItemController.selectedItem.value);
    recalculateSalesTax();
    showScaffoldMsg(context: context, msg: "Item successfully added to cart", isSuccess: true);
    Future.delayed(const Duration(milliseconds: 100), () {
      catItemController.clearItemVariables();
    });
    checkoutController.getDiscountedPayableTotal();
    saveCartToDb();

    // infoLog("that addons combine list check is: "
    //     "${orderController.cartItems.map((element) => element.addons.map((e) => e.toJson())).toList()}");
    //
    // wtfLog("that addons combine list check is: "
    //     "${orderController.cartItems.map((element) => element.addons.map((e) => e.toJson())).expand((element) => element).toList()}");

    // log("item data with options data: "
    //     "${orderController.cartItems.map(
    //       (element) {
    //         Map<String, dynamic> tempMap = element.placeOrderToJson();
    //         tempMap.addAll(
    //           {
    //             "size_id": element.options.isNotEmpty ? element.options.first.optionId : "",
    //             "size_name": element.options.isNotEmpty ? element.options.first.optionName : "",
    //             "item_size_id": element.options.isNotEmpty ? element.options.first.itemOptionId : "",
    //             "size_price": element.options.isNotEmpty ? element.options.first.price : "",
    //             "addons_cost_per_item":
    //             element.addons.fold(0.0, (previousValue, element) => previousValue + (double.tryParse(element.price) ?? 0.0)).toStringAsFixed(2),
    //           },
    //         );
    //         return tempMap;
    //       }
    // ).toList()}");
    // } else {
    //   catItemController.clearItemVariables();
    //   showMsg(msg: "Item already exists in the cart", isSuccess: false);
    // }
  }

  modifiedAddToCart({VoidCallback? onSuccess}) {
    //+ just remove this if to let the user add similar id products with same/or
    //! different options and/or addons after related changes have already been done on the backend.;
    // isItemAlreadyThere = cartItems.firstWhere((element) => element.itemId == catItemController.selectedItem.value.itemId, orElse: () => const MenuItem()).itemId.isNotEmpty;
    List<MenuItemAddon> addonsNewList = [];
    for (String addonId in catItemController.selectedAddonIds) {
      addonsNewList.add(catItemController.selectedItem.value.addons.firstWhere((element) => element.addonId == addonId));
    }

    log(' catItemController.itemTotal.value before update: ${catItemController.itemTotal.value}');

    log("addonsNewList.isEmpty: ${addonsNewList.isEmpty}");
    log("addonsNewList.isEmpty: ${addonsNewList.map((e) => e.toJson())}");

    //+ this weird part is also part of that workaround which supports same item count increase thingy
    addonsNewList.add(const MenuItemAddon());

    catItemController.selectedItem.value = catItemController.selectedItem.value.copyWith(
      totalPrice: catItemController.itemTotal.value,
      itemCount: catItemController.itemCount.value,
      note: catItemController.noteController.text.trim(),
      addons: addonsNewList,
      options: catItemController.selectedOptionId.value.isNotEmpty
          ? [catItemController.selectedItem.value.options.firstWhere((element) => element.optionId == catItemController.selectedOptionId.value)]
          : [],
    );

    //+ Below part is being added because we have to add an empty addon for some reason
    //+ and then we need to remove it to support the same item  count increase if it is already in cart

    List<MenuItemAddon> temp = catItemController.selectedItem.value.addons;
    temp.removeWhere((element) => element.addonId.isEmpty);
    catItemController.selectedItem.value = catItemController.selectedItem.value.copyWith(addons: temp);
    //+ --------------------------------- END OF THE WORKAROUND ---------------------------------------

    int index = cartItems.indexWhere((element) => element == catItemController.selectedItem.value);
    if (index != -1) {
      //+ item exists and is Same
      // bool isSame = cartItems.firstWhere((element) => element.itemId == catItemController.selectedItem.value.itemId, orElse: () => const MenuItem()) ==
      //     catItemController.selectedItem.value;
      // log("has same addons isSame: $isSame");
      log("has same addons isSame addonsNewList: ${catItemController.selectedItem.value.hashCode}");
      log(
        "has same addons isSame already item addons: ${cartItems.firstWhere((element) => element.itemId == catItemController.selectedItem.value.itemId, orElse: () => const MenuItem()).hashCode}",
      );

      // if (isSame) {
      updateItemCountModified(isIncrement: true, index: index, updateBy: catItemController.itemCount.value);
      // }
    } else {
      log("catItemController.selectedItem.value.itemCount: ${catItemController.selectedItem.value.itemCount}");
      log("catItemController.selectedItem.value.itemCost: ${catItemController.selectedItem.value.itemCost}");

      cartItems.add(catItemController.selectedItem.value);

      log("cartItems.first.itemCost: ${cartItems.first.itemCost}");
      log("cartItems.first.itemCost: ${cartItems.first.itemCount}");
    }
    recalculateSalesTax();
    log("calculatedSalesTax: $calculatedSalesTax");
    Future.delayed(const Duration(milliseconds: 100), () {
      catItemController.clearItemVariables();
    });
    checkoutController.getDiscountedPayableTotal();

    if (onSuccess != null) onSuccess.call();

    saveCartToDb();

    // infoLog("that addons combine list check is: "
    //     "${orderController.cartItems.map((element) => element.addons.map((e) => e.toJson())).toList()}");
    //
    // wtfLog("that addons combine list check is: "
    //     "${orderController.cartItems.map((element) => element.addons.map((e) => e.toJson())).expand((element) => element).toList()}");

    // log("item data with options data: "
    //     "${orderController.cartItems.map(
    //       (element) {
    //         Map<String, dynamic> tempMap = element.placeOrderToJson();
    //         tempMap.addAll(
    //           {
    //             "size_id": element.options.isNotEmpty ? element.options.first.optionId : "",
    //             "size_name": element.options.isNotEmpty ? element.options.first.optionName : "",
    //             "item_size_id": element.options.isNotEmpty ? element.options.first.itemOptionId : "",
    //             "size_price": element.options.isNotEmpty ? element.options.first.price : "",
    //             "addons_cost_per_item":
    //             element.addons.fold(0.0, (previousValue, element) => previousValue + (double.tryParse(element.price) ?? 0.0)).toStringAsFixed(2),
    //           },
    //         );
    //         return tempMap;
    //       }
    // ).toList()}");
    // } else {
    //   catItemController.clearItemVariables();
    //   showMsg(msg: "Item already exists in the cart", isSuccess: false);
    // }
  }

  deleteAnItem({String itemId = "", required int index, VoidCallback? onSuccess}) {
    // cartItems.removeWhere((element) => element.itemId == itemId);
    cartItems.removeAt(index);
    recalculateSalesTax();
    if (cartItems.isEmpty) {
      checkoutController.clearMembershipDiscountData();
      checkoutController.clearSpDiscountData();
      checkoutController.clearCouponDiscountData();
    }
    checkoutController.getDiscountedPayableTotal();
    if (onSuccess != null) {
      onSuccess.call();
    }
    saveCartToDb();
  }

  updateItemCount({required bool isIncrement, required int index}) {
    double itemAddition = 0.0;

    itemAddition += (double.tryParse(cartItems[index].itemCost) ?? 0);
    log("itemAddition after itemCost addition: $itemAddition");
    double currentAddonsPrice = cartItems[index].addons.fold(0.0, (previousValue, element) => previousValue + (double.tryParse(element.price) ?? 0.0));
    log("currentAddonsPrice: $currentAddonsPrice");
    log("itemAddition after currentAddonsPrice addition: $itemAddition");

    itemAddition += currentAddonsPrice;
    if (cartItems[index].options.isNotEmpty) {
      MenuItemOption selectedOption = cartItems[index].options.first;
      itemAddition += (double.tryParse(selectedOption.price) ?? 0.0);
      log("selectedOption.price: ${selectedOption.price}");
    }
    log("itemAddition after option price addition: $itemAddition");
    if (isIncrement) {
      // cartItems[index].itemCount += 1;
      // cartItems[index].totalPrice += (double.tryParse(cartItems[index].itemCost) ?? 0);
      cartItems[index] = cartItems[index].copyWith(totalPrice: cartItems[index].totalPrice + itemAddition, itemCount: cartItems[index].itemCount + 1);
      log("cart item after updates is: ${cartItems[index]}");
    } else {
      // cartItems[index].itemCount -= 1;
      // cartItems[index].totalPrice -= (double.tryParse(cartItems[index].itemCost) ?? 0);
      log('cartItems[index].itemCount: ${cartItems[index].itemCount}');
      if (cartItems[index].itemCount > 1) {
        cartItems[index] = cartItems[index].copyWith(totalPrice: cartItems[index].totalPrice - itemAddition, itemCount: cartItems[index].itemCount - 1);
      }
    }
    recalculateSalesTax();
    checkoutController.getDiscountedPayableTotal();
    saveCartToDb();
  }

  updateItemCountModified({required bool isIncrement, required int index, int updateBy = 1}) {
    double itemAddition = 0.0;

    itemAddition += (updateBy * (double.tryParse(cartItems[index].itemCost) ?? 0));
    log("itemAddition after itemCost addition: $itemAddition");
    double currentAddonsPrice = cartItems[index].addons.fold(0.0, (previousValue, element) => previousValue + (double.tryParse(element.price) ?? 0.0));
    log("currentAddonsPrice: $currentAddonsPrice");
    log("itemAddition after currentAddonsPrice addition: $itemAddition");

    itemAddition += (updateBy * currentAddonsPrice);
    if (cartItems[index].options.isNotEmpty) {
      MenuItemOption selectedOption = cartItems[index].options.first;
      itemAddition += (updateBy * (double.tryParse(selectedOption.price) ?? 0.0));
      log("selectedOption.price: ${selectedOption.price}");
    }
    log("itemAddition after option price addition: $itemAddition");
    if (isIncrement) {
      // cartItems[index].itemCount += 1;
      // cartItems[index].totalPrice += (double.tryParse(cartItems[index].itemCost) ?? 0);
      cartItems[index] = cartItems[index].copyWith(totalPrice: cartItems[index].totalPrice + itemAddition, itemCount: cartItems[index].itemCount + updateBy);
      log("cart item after updates is: ${cartItems[index]}");
    } else {
      // cartItems[index].itemCount -= 1;
      // cartItems[index].totalPrice -= (double.tryParse(cartItems[index].itemCost) ?? 0);
      log('cartItems[index].itemCount: ${cartItems[index].itemCount}');
      if (cartItems[index].itemCount > 1) {
        cartItems[index] = cartItems[index].copyWith(totalPrice: cartItems[index].totalPrice - itemAddition, itemCount: cartItems[index].itemCount - updateBy);
      }
    }
    recalculateSalesTax();
    checkoutController.getDiscountedPayableTotal();
    saveCartToDb();
  }

  clearCart({VoidCallback? onSuccess}) {
    cartItems.clear();
    cartTotal.value = 0.0;
    discount.value = 0.0;
    // showMsg(msg: "Cart cleared!", isSuccess: true); //! moved to onSuccess with context
    if (onSuccess != null) {
      onSuccess.call();
    }
    checkoutController.clearMembershipDiscountData();
    checkoutController.clearSpDiscountData();
    checkoutController.clearCouponDiscountData();
    checkoutController.getDiscountedPayableTotal();
    clearLocalCartFromDb();
  }

  clearOrderData({bool clearLocalCart = true}) {
    cartItems.clear();
    cartTotal.value = 0.0;
    cartTotal.value = 0.0;
    discount.value = 0.0;
    calculatedSalesTax.value = 0.0;
    catItemController.clearItemVariables();
    checkoutController.clearMembershipDiscountData();
    checkoutController.clearSpDiscountData();
    checkoutController.clearCouponDiscountData();

    /*+ Commented As Requested by Allen +*/
    /*+ Un-Commented As Requested by Allen on Aug-13-2024 +*/
    checkoutController.clearTips();
    checkoutController.clearAll();
    if (clearLocalCart) {
      clearLocalCartFromDb();
    }
  }
}
