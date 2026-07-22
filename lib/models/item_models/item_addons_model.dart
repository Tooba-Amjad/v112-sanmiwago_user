// To parse this JSON data, do
//
//     final menuItemAddons = menuItemAddonsFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

MenuItemAddon menuItemAddonsFromJson(String str) => MenuItemAddon.fromJson(json.decode(str));

String menuItemAddonsToJson(MenuItemAddon data) => json.encode(data.toJson());

class MenuItemAddon extends Equatable {
  final String addonId;
  final String addonName;
  final String categoryName;
  final String price;
  final String description;
  final String addonImage;
  final String status;
  final String itemAddonId;
  final String itemId;
  final double finalCost;

  const MenuItemAddon({
    this.addonId = "",
    this.addonName = "",
    this.categoryName = "",
    this.price = "",
    this.description = "",
    this.addonImage = "",
    this.status = "",
    this.itemAddonId = "",
    this.itemId = "",
    this.finalCost = 0.0,
  });

  MenuItemAddon copyWith({
    final String? addonId,
    final String? addonName,
    final String? categoryName,
    final String? price,
    final String? description,
    final String? addonImage,
    final String? status,
    final String? itemAddonId,
    final String? itemId,
    final double? finalCost,
  }) =>
      MenuItemAddon(
        addonId: addonId ?? this.addonId,
        addonName: addonName ?? this.addonName,
        categoryName: categoryName ?? this.categoryName,
        price: price ?? this.price,
        description: description ?? this.description,
        addonImage: addonImage ?? this.addonImage,
        status: status ?? this.status,
        itemAddonId: itemAddonId ?? this.itemAddonId,
        itemId: itemId ?? this.itemId,
        finalCost: finalCost ?? this.finalCost,
      );

  factory MenuItemAddon.fromJson(Map<String, dynamic> json) => MenuItemAddon(
    addonId: json["addon_id"] ?? "",
    addonName: json["addon_name"] ?? "",
    categoryName: json["category_name"] ?? "",
    price: json["price"] ?? "",
    description: json["description"] ?? "",
    addonImage: json["addon_image"] ?? "",
    status: json["status"] ?? "",
    itemAddonId: json["item_addon_id"] ?? "",
    itemId: json["item_id"] ?? "",
    finalCost: 0.0,
  );

  Map<String, dynamic> toJson() => {
    "addon_id": addonId,
    "addon_name": addonName,
    "price": price,
    "description": description,
    "addon_image": addonImage,
    "status": status,
    "item_addon_id": itemAddonId,
    "item_id": itemId,
    "final_cost": finalCost,
  };

  Map<String, dynamic> placeOrderToJson() => {
    "item_id": itemId,
    "addon_name": addonName,
    "addon_image": addonImage,
    "price": price,
    "quantity": "1",
    "final_cost": finalCost,
    "addon_id": addonId,
    // "description": description,
    // "status": status,
    // "item_addon_id": itemAddonId,
  };

  @override
  List<Object?> get props => [addonId, addonName, categoryName, addonImage, price, description, itemAddonId, itemId];
}
