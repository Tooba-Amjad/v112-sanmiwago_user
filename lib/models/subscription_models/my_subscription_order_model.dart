// To parse this JSON data, do
//
//     final mySubscriptionOrder = mySubscriptionOrderFromJson(jsonString);

import 'dart:convert';

import 'package:sanmiwago_user/models/item_models/item_model.dart';

MySubscriptionOrder mySubscriptionOrderFromJson(String str) => MySubscriptionOrder.fromJson(json.decode(str));

String mySubscriptionOrderToJson(MySubscriptionOrder data) => json.encode(data.toJson());

class MySubscriptionOrder {
  String id;
  String offerId;
  String offerName;
  String branchName;
  String branchAddress;
  String status;
  String orderId;
  String userId;
  String offerCost;
  String offerQuantity;
  String offerFinalCost;
  String offerConditions;
  String noOfProducts;
  String createdAt;
  String updatedAt;
  String restaurantId;
  String username;
  List<OrderProduct> orderProducts;

  MySubscriptionOrder({
    this.id = "",
    this.offerId = "",
    this.offerName = "",
    this.branchName = "",
    this.branchAddress = "",
    this.status = "",
    this.orderId = "",
    this.userId = "",
    this.offerCost = "",
    this.offerQuantity = "",
    this.offerFinalCost = "",
    this.offerConditions = "",
    this.noOfProducts = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.restaurantId = "",
    this.username = "",
    this.orderProducts = const [],
  });

  MySubscriptionOrder copyWith({
    String? id,
    String? offerId,
    String? offerName,
    String? branchName,
    String? branchAddress,
    String? status,
    String? orderId,
    String? userId,
    String? offerCost,
    String? offerQuantity,
    String? offerFinalCost,
    String? offerConditions,
    String? noOfProducts,
    String? createdAt,
    String? updatedAt,
    String? restaurantId,
    String? username,
    List<OrderProduct>? orderProducts,
  }) =>
      MySubscriptionOrder(
        id: id ?? this.id,
        offerId: offerId ?? this.offerId,
        offerName: offerName ?? this.offerName,
        branchName: branchName ?? this.branchName,
        branchAddress: branchAddress ?? this.branchAddress,
        status: status ?? this.status,
        orderId: orderId ?? this.orderId,
        userId: userId ?? this.userId,
        offerCost: offerCost ?? this.offerCost,
        offerQuantity: offerQuantity ?? this.offerQuantity,
        offerFinalCost: offerFinalCost ?? this.offerFinalCost,
        offerConditions: offerConditions ?? this.offerConditions,
        noOfProducts: noOfProducts ?? this.noOfProducts,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        restaurantId: restaurantId ?? this.restaurantId,
        username: username ?? this.username,
        orderProducts: orderProducts ?? this.orderProducts,
      );

  factory MySubscriptionOrder.fromJson(Map<String, dynamic> json) => MySubscriptionOrder(
        id: json["id"] ?? "",
        offerId: json["offer_id"] ?? "",
        offerName: json["offer_name"] ?? "",
        branchName: json["branch_name"] ?? "",
        branchAddress: json["branch_address"] ?? "",
        status: json["status"] ?? "",
        orderId: json["order_id"] ?? "",
        userId: json["user_id"] ?? "",
        offerCost: json["offer_cost"] ?? "",
        offerQuantity: json["offer_quantity"] ?? "",
        offerFinalCost: json["offer_final_cost"] ?? "",
        offerConditions: json["offer_conditions"] ?? "",
        noOfProducts: json["no_of_products"] ?? "",
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "",
        restaurantId: json["restaurant_id"] ?? "",
        username: json["username"] ?? "",
        orderProducts: List<OrderProduct>.from(json["order_products"].map((x) => OrderProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "offer_id": offerId,
        "status": status,
        "order_id": orderId,
        "user_id": userId,
        "offer_name": offerName,
        "offer_cost": offerCost,
        "offer_quantity": offerQuantity,
        "offer_final_cost": offerFinalCost,
        "offer_conditions": offerConditions,
        "no_of_products": noOfProducts,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "restaurant_id": restaurantId,
        "username": username,
        "branch_name": branchName,
        "branch_address": branchAddress,
        "order_products": List<dynamic>.from(orderProducts.map((x) => x.toJson())),
      };
}

class OrderProduct {
  String orderOfferProductId;
  String orderId;
  String offerId;
  String itemId;
  String menuId;
  String itemName;
  String itemQuantity;
  String itemCost;
  String finalCost;
  String isDeleted;
  String commonId;
  List<MenuItem> item;

  OrderProduct({
    this.orderOfferProductId = "",
    this.orderId = "",
    this.offerId = "",
    this.itemId = "",
    this.menuId = "",
    this.itemName = "",
    this.itemQuantity = "",
    this.itemCost = "",
    this.finalCost = "",
    this.isDeleted = "",
    this.commonId = "",
    this.item = const [],
  });

  OrderProduct copyWith({
    String? orderOfferProductId,
    String? orderId,
    String? offerId,
    String? itemId,
    String? menuId,
    String? itemName,
    String? itemQuantity,
    String? itemCost,
    String? finalCost,
    String? isDeleted,
    String? commonId,
    List<MenuItem>? item,
  }) =>
      OrderProduct(
        orderOfferProductId: orderOfferProductId ?? this.orderOfferProductId,
        orderId: orderId ?? this.orderId,
        offerId: offerId ?? this.offerId,
        itemId: itemId ?? this.itemId,
        menuId: menuId ?? this.menuId,
        itemName: itemName ?? this.itemName,
        itemQuantity: itemQuantity ?? this.itemQuantity,
        itemCost: itemCost ?? this.itemCost,
        finalCost: finalCost ?? this.finalCost,
        isDeleted: isDeleted ?? this.isDeleted,
        commonId: commonId ?? this.commonId,
        item: item ?? this.item,
      );

  factory OrderProduct.fromJson(Map<String, dynamic> json) => OrderProduct(
        orderOfferProductId: json["order_offer_product_id"],
        orderId: json["order_id"],
        offerId: json["offer_id"],
        itemId: json["item_id"],
        menuId: json["menu_id"],
        itemName: json["item_name"],
        itemQuantity: json["item_quantity"],
        itemCost: json["item_cost"],
        finalCost: json["final_cost"],
        isDeleted: json["is_deleted"],
        commonId: json["common_id"],
        item: List<MenuItem>.from(json["item"].map((x) => MenuItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order_offer_product_id": orderOfferProductId,
        "order_id": orderId,
        "offer_id": offerId,
        "item_id": itemId,
        "menu_id": menuId,
        "item_name": itemName,
        "item_quantity": itemQuantity,
        "item_cost": itemCost,
        "final_cost": finalCost,
        "is_deleted": isDeleted,
        "common_id": commonId,
        "item": List<dynamic>.from(item.map((x) => x.toJson())),
      };
}

// class Item {
//   String itemId;
//   String sortBy;
//   String tvMenuItemPosition;
//   String menuId;
//   String restaurantId;
//   String itemCategory;
//   String itemName;
//   String itemCost;
//   String itemPoints;
//   String pointsToPurchase;
//   String itemTypeId;
//   String itemImageName;
//   String itemDescription;
//   String status;
//   String isMostSellingItem;
//   String isCustomizeItem;
//   String productId;
//
//   Item({
//     required this.itemId,
//     required this.sortBy,
//     required this.tvMenuItemPosition,
//     required this.menuId,
//     required this.restaurantId,
//     required this.itemCategory,
//     required this.itemName,
//     required this.itemCost,
//     required this.itemPoints,
//     required this.pointsToPurchase,
//     required this.itemTypeId,
//     required this.itemImageName,
//     required this.itemDescription,
//     required this.status,
//     required this.isMostSellingItem,
//     required this.isCustomizeItem,
//     required this.productId,
//   });
//
//   Item copyWith({
//     String? itemId,
//     String? sortBy,
//     String? tvMenuItemPosition,
//     String? menuId,
//     String? restaurantId,
//     String? itemCategory,
//     String? itemName,
//     String? itemCost,
//     String? itemPoints,
//     String? pointsToPurchase,
//     String? itemTypeId,
//     String? itemImageName,
//     String? itemDescription,
//     String? status,
//     String? isMostSellingItem,
//     String? isCustomizeItem,
//     String? productId,
//   }) =>
//       Item(
//         itemId: itemId ?? this.itemId,
//         sortBy: sortBy ?? this.sortBy,
//         tvMenuItemPosition: tvMenuItemPosition ?? this.tvMenuItemPosition,
//         menuId: menuId ?? this.menuId,
//         restaurantId: restaurantId ?? this.restaurantId,
//         itemCategory: itemCategory ?? this.itemCategory,
//         itemName: itemName ?? this.itemName,
//         itemCost: itemCost ?? this.itemCost,
//         itemPoints: itemPoints ?? this.itemPoints,
//         pointsToPurchase: pointsToPurchase ?? this.pointsToPurchase,
//         itemTypeId: itemTypeId ?? this.itemTypeId,
//         itemImageName: itemImageName ?? this.itemImageName,
//         itemDescription: itemDescription ?? this.itemDescription,
//         status: status ?? this.status,
//         isMostSellingItem: isMostSellingItem ?? this.isMostSellingItem,
//         isCustomizeItem: isCustomizeItem ?? this.isCustomizeItem,
//         productId: productId ?? this.productId,
//       );
//
//   factory Item.fromJson(Map<String, dynamic> json) => Item(
//     itemId: json["item_id"],
//     sortBy: json["sort_by"],
//     tvMenuItemPosition: json["tv_menu_item_position"],
//     menuId: json["menu_id"],
//     restaurantId: json["restaurant_id"],
//     itemCategory: json["item_category"],
//     itemName: json["item_name"],
//     itemCost: json["item_cost"],
//     itemPoints: json["item_points"],
//     pointsToPurchase: json["points_to_purchase"],
//     itemTypeId: json["item_type_id"],
//     itemImageName: json["item_image_name"],
//     itemDescription: json["item_description"],
//     status: json["status"],
//     isMostSellingItem: json["is_most_selling_item"],
//     isCustomizeItem: json["is_customize_item"],
//     productId: json["product_id"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "item_id": itemId,
//     "sort_by": sortBy,
//     "tv_menu_item_position": tvMenuItemPosition,
//     "menu_id": menuId,
//     "restaurant_id": restaurantId,
//     "item_category": itemCategory,
//     "item_name": itemName,
//     "item_cost": itemCost,
//     "item_points": itemPoints,
//     "points_to_purchase": pointsToPurchase,
//     "item_type_id": itemTypeId,
//     "item_image_name": itemImageName,
//     "item_description": itemDescription,
//     "status": status,
//     "is_most_selling_item": isMostSellingItem,
//     "is_customize_item": isCustomizeItem,
//     "product_id": productId,
//   };
// }
