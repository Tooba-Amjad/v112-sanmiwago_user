// To parse this JSON data, do
//
//     final subscriptionOffer = subscriptionOfferFromJson(jsonString);

import 'dart:convert';

import 'package:sanmiwago_user/models/item_models/item_model.dart';

SubscriptionOffer subscriptionOfferFromJson(String str) => SubscriptionOffer.fromJson(json.decode(str));

String subscriptionOfferToJson(SubscriptionOffer data) => json.encode(data.toJson());

class SubscriptionOffer {
  bool isSubscribed;
  String offerId;
  String offerName;
  String offerCost;
  String offerDurations;
  String offerSubscriptions;
  String offerStartDate;
  String offerValidDate;
  String offerConditions;
  String noOfProducts;
  String offerImageName;
  String dateOfOfferCreated;
  String status;
  String productId;
  String restaurantId;
  List<OfferProduct> offerProducts;
  String planType;

  SubscriptionOffer({
    this.isSubscribed = false,
    this.offerId = "",
    this.offerName = "",
    this.offerCost = "",
    this.offerDurations = "",
    this.offerSubscriptions = "",
    this.offerStartDate = "",
    this.offerValidDate = "",
    this.offerConditions = "",
    this.noOfProducts = "",
    this.offerImageName = "",
    this.dateOfOfferCreated = "",
    this.status = "",
    this.productId = "",
    this.restaurantId = "",
    this.offerProducts = const [],
    this.planType = "",
  });

  SubscriptionOffer copyWith({
    bool? isSubscribed,
    String? offerId,
    String? offerName,
    String? offerCost,
    String? offerDurations,
    String? offerSubscriptions,
    String? offerStartDate,
    String? offerValidDate,
    String? offerConditions,
    String? noOfProducts,
    String? offerImageName,
    String? dateOfOfferCreated,
    String? status,
    String? productId,
    String? restaurantId,
    List<OfferProduct>? offerProducts,
    String? planType,
  }) =>
      SubscriptionOffer(
        isSubscribed: isSubscribed ?? this.isSubscribed,
        offerId: offerId ?? this.offerId,
        offerName: offerName ?? this.offerName,
        offerCost: offerCost ?? this.offerCost,
        offerDurations: offerDurations ?? this.offerDurations,
        offerSubscriptions: offerSubscriptions ?? this.offerSubscriptions,
        offerStartDate: offerStartDate ?? this.offerStartDate,
        offerValidDate: offerValidDate ?? this.offerValidDate,
        offerConditions: offerConditions ?? this.offerConditions,
        noOfProducts: noOfProducts ?? this.noOfProducts,
        offerImageName: offerImageName ?? this.offerImageName,
        dateOfOfferCreated: dateOfOfferCreated ?? this.dateOfOfferCreated,
        status: status ?? this.status,
        productId: productId ?? this.productId,
        restaurantId: restaurantId ?? this.restaurantId,
        offerProducts: offerProducts ?? this.offerProducts,
        planType: planType?? this.planType,
      );

  factory SubscriptionOffer.fromJson(Map<String, dynamic> json) => SubscriptionOffer(
    isSubscribed: false,
    offerId: json["offer_id"] ?? "",
    offerName: json["offer_name"] ?? "",
    offerCost: json["offer_cost"] ?? "",
    offerDurations: json["offer_durations"] ?? "",
    offerSubscriptions: json["offer_subscriptions"] ?? "",
    offerStartDate: json["offer_start_date"] ?? "",
    offerValidDate: json["offer_valid_date"] ?? "",
    offerConditions: json["offer_conditions"] ?? "",
    noOfProducts: json["no_of_products"] ?? "",
    offerImageName: json["offer_image_name"] ?? "",
    dateOfOfferCreated: json["date_of_offer_created"] ?? "",
    status: json["status"] ?? "",
    productId: json["product_id"] ?? "",
    restaurantId: json["restaurant_id"] ?? "",
    offerProducts: List<OfferProduct>.from((json["offer_products"] ?? []).map((x) => OfferProduct.fromJson(x))),
    planType: json["plan_type"]?? "",
  );

  Map<String, dynamic> toJson() => {
    "offer_id": offerId,
    "offer_name": offerName,
    "offer_cost": offerCost,
    "offer_durations": offerDurations,
    "offer_subscriptions": offerSubscriptions,
    "offer_start_date": offerStartDate,
    "offer_valid_date": offerValidDate,
    "offer_conditions": offerConditions,
    "no_of_products": noOfProducts,
    "offer_image_name": offerImageName,
    "date_of_offer_created": dateOfOfferCreated,
    "status": status,
    "product_id": productId,
    "restaurant_id": restaurantId,
    "offer_products": List<dynamic>.from(offerProducts.map((x) => x.toJson())),
    "plan_type": planType,
    "isSubscribed": isSubscribed,
  };
}

class OfferProduct {
  String offerProductId;
  String offerId;
  String menuId;
  String menuName;
  String itemId;
  String itemName;
  String quantity;
  List<MenuItem> itemDetail;

  OfferProduct({
    this.offerProductId = "",
    this.offerId = "",
    this.menuId = "",
    this.menuName = "",
    this.itemId = "",
    this.itemName = "",
    this.quantity = "",
    this.itemDetail = const [],
  });

  OfferProduct copyWith({
    String? offerProductId,
    String? offerId,
    String? menuId,
    String? menuName,
    String? itemId,
    String? itemName,
    String? quantity,
    List<MenuItem>? itemDetail,
  }) =>
      OfferProduct(
        offerProductId: offerProductId ?? this.offerProductId,
        offerId: offerId ?? this.offerId,
        menuId: menuId ?? this.menuId,
        menuName: menuName ?? this.menuName,
        itemId: itemId ?? this.itemId,
        itemName: itemName ?? this.itemName,
        quantity: quantity ?? this.quantity,
        itemDetail: itemDetail ?? this.itemDetail,
      );

  factory OfferProduct.fromJson(Map<String, dynamic> json) => OfferProduct(
    offerProductId: json["offer_product_id"] ?? "",
    offerId: json["offer_id"] ?? "",
    menuId: json["menu_id"] ?? "",
    menuName: json["menu_name"] ?? "",
    itemId: json["item_id"] ?? "",
    itemName: json["item_name"] ?? "",
    quantity: json["quantity"] ?? "",
    itemDetail: List<MenuItem>.from((json["item_detail"] ?? []).map((x) => MenuItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "offer_product_id": offerProductId,
    "offer_id": offerId,
    "menu_id": menuId,
    "menu_name": menuName,
    "item_id": itemId,
    "item_name": itemName,
    "quantity": quantity,
    "item_detail": List<dynamic>.from(itemDetail.map((x) => x.toJson())),
  };
}

// class ItemDetail {
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
//   String productId;
//
//   ItemDetail({
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
//     required this.productId,
//   });
//
//   ItemDetail copyWith({
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
//     String? productId,
//   }) =>
//       ItemDetail(
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
//         productId: productId ?? this.productId,
//       );
//
//   factory ItemDetail.fromJson(Map<String, dynamic> json) => ItemDetail(
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
//     "product_id": productId,
//   };
// }
