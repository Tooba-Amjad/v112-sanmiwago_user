import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:sanmiwago_user/models/item_models/item_addons_model.dart';
import 'package:sanmiwago_user/models/item_models/item_options_model.dart';

MenuItem menuItemFromJson(String str) => MenuItem.fromJson(json.decode(str));

String menuItemToJson(MenuItem data) => json.encode(data.toJson());

class MenuItem extends Equatable {
  final String itemId;
  final String sortBy;
  final String menuId;
  final String itemCategory;
  final String itemName;
  final String itemCost;
  final int itemCount;
  final double totalPrice;
  final String itemPoints;
  final String pointsToPurchase;
  final String itemTypeId;
  final String itemImageName;
  final String itemDescription;
  final String status;
  final String isMostSellingItem;
  final String productId;
  final String note;
  final List<MenuItemOption> options;
  final List<MenuItemOption> offerOptions;
  final List<MenuItemAddon> addons;

  const MenuItem({
    this.itemId = "",
    this.sortBy = "",
    this.menuId = "",
    this.itemCategory = "",
    this.itemName = "",
    this.itemCost = "",
    this.itemCount = 0,
    this.totalPrice = 0.0,
    this.itemPoints = "",
    this.pointsToPurchase = "",
    this.itemTypeId = "",
    this.itemImageName = "",
    this.itemDescription = "",
    this.status = "",
    this.isMostSellingItem = "",
    this.productId = "",
    this.note = "",
    this.options = const [],
    this.offerOptions = const [],
    this.addons = const [],
  });

  MenuItem copyWith({
    final String? itemId,
    final String? sortBy,
    final String? menuId,
    final String? itemCategory,
    final String? itemName,
    final String? itemCost,
    final int? itemCount,
    final double? totalPrice,
    final String? itemPoints,
    final String? pointsToPurchase,
    final String? itemTypeId,
    final String? itemImageName,
    final String? itemDescription,
    final String? status,
    final String? isMostSellingItem,
    final String? productId,
    final String? note,
    final List<MenuItemOption>? options,
    final List<MenuItemOption>? offerOptions,
    final List<MenuItemAddon>? addons,
  }) =>
      MenuItem(
        itemId: itemId ?? this.itemId,
        sortBy: sortBy ?? this.sortBy,
        menuId: menuId ?? this.menuId,
        itemCategory: itemCategory ?? this.itemCategory,
        itemName: itemName ?? this.itemName,
        itemCost: itemCost ?? this.itemCost,
        itemCount: itemCount ?? this.itemCount,
        totalPrice: totalPrice ?? this.totalPrice,
        itemPoints: itemPoints ?? this.itemPoints,
        pointsToPurchase: pointsToPurchase ?? this.pointsToPurchase,
        itemTypeId: itemTypeId ?? this.itemTypeId,
        itemImageName: itemImageName ?? this.itemImageName,
        itemDescription: itemDescription ?? this.itemDescription,
        status: status ?? this.status,
        isMostSellingItem: isMostSellingItem ?? this.isMostSellingItem,
        productId: productId ?? this.productId,
        note: note ?? this.note,
        options: options ?? this.options,
        offerOptions: offerOptions ?? this.offerOptions,
        addons: addons ?? this.addons,
      );

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    var addonsList = <MenuItemAddon>[];

    if (json['addons'] != null) {
      json['addons'].forEach((v) {
        for (var addonRaw in v['addons']) {
          var addon = MenuItemAddon.fromJson(addonRaw);
          // log("v['category_name']: ${v['category_name']}");
          addon = addon.copyWith(categoryName: v['category_name']);
          // log("addon: ${addon.toJson()}");
          addonsList.add(addon);
        }
      });
    }
    return MenuItem(
      itemId: json["item_id"] ?? "",
      sortBy: json["sort_by"] ?? "",
      menuId: json["menu_id"] ?? "",
      itemCategory: json["item_category"] ?? "",
      itemName: json["item_name"] ?? "",
      itemCost: json["item_cost"] ?? "",
      itemCount: json["item_count"] ?? 1,
      totalPrice: json["total_price"] ?? 0,
      itemPoints: json["item_points"] ?? "",
      pointsToPurchase: json["points_to_purchase"] ?? "",
      itemTypeId: json["item_type_id"] ?? "",
      itemImageName: json["item_image_name"] ?? "",
      itemDescription: json["item_description"] ?? "",
      status: json["status"] ?? "",
      isMostSellingItem: json["is_most_selling_item"] ?? "",
      productId: json["product_id"] ?? "",
      note: json["note"] ?? "",
      options: const [],
      offerOptions: json["options"] != null ? List<MenuItemOption>.from(json["options"].map((x) => MenuItemOption.fromJson(x))) : const [],
      addons: json["addons"] == null ? const [] : addonsList,
    );
  }

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "sort_by": sortBy,
        "menu_id": menuId,
        "item_category": itemCategory,
        "item_name": itemName,
        "item_cost": itemCost,
        "item_count": itemCount.toString(),
        "total_price": totalPrice,
        "item_points": itemPoints,
        "points_to_purchase": pointsToPurchase,
        "item_type_id": itemTypeId,
        "item_image_name": itemImageName,
        "item_description": itemDescription,
        "status": status,
        "is_most_selling_item": isMostSellingItem,
        "product_id": productId,
        "note": note,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "offer_options": List<dynamic>.from(offerOptions.map((x) => x.toJson())),
        "addons": List<dynamic>.from(addons.map((x) => x.toJson())),
      };

  Map<String, dynamic> placeOrderToJson() => {
        "item_id": itemId,
        "menu_id": menuId,
        "item_name": itemName,
        "item_image_name": itemImageName.isNotEmpty ? itemImageName.split("/").last : "",
        "item_qty": itemCount.toString(),
        "item_cost": itemCost,
        "special_instruction": note,
        "addons": List<dynamic>.from(addons.map((x) => x.toJson())),
        // "item_points": itemPoints,
        // "points_to_purchase": pointsToPurchase,
        // "item_type_id": itemTypeId,
        // "item_description": itemDescription,
        // "status": status,
        // "product_id": productId,
      };

  @override
  List<Object?> get props => [itemId, menuId, itemCategory, itemName, itemPoints, pointsToPurchase, itemTypeId, itemDescription, productId, options, addons, note];

  @override
  bool get stringify => false;
}
