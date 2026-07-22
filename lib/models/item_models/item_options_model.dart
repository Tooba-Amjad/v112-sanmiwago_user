import 'dart:convert';

import 'package:equatable/equatable.dart';

MenuItemOption menuItemOptionsFromJson(String str) => MenuItemOption.fromJson(json.decode(str));

String menuItemOptionsToJson(MenuItemOption data) => json.encode(data.toJson());

class MenuItemOption extends Equatable {
  final String optionId;
  final String optionName;
  final String status;
  final String itemOptionId;
  final String itemId;
  final String price;

  const MenuItemOption({
    this.optionId = "",
    this.optionName = "",
    this.status = "",
    this.itemOptionId = "",
    this.itemId = "",
    this.price = "",
  });

  MenuItemOption copyWith({
    final String? optionId,
    final String? optionName,
    final String? status,
    final String? itemOptionId,
    final String? itemId,
    final String? price,
  }) =>
      MenuItemOption(
        optionId: optionId ?? this.optionId,
        optionName: optionName ?? this.optionName,
        status: status ?? this.status,
        itemOptionId: itemOptionId ?? this.itemOptionId,
        itemId: itemId ?? this.itemId,
        price: price ?? this.price,
      );

  factory MenuItemOption.fromJson(Map<String, dynamic> json) => MenuItemOption(
    optionId: json["option_id"] ?? "",
    optionName: json["option_name"] ?? "",
    status: json["status"] ?? "",
    itemOptionId: json["item_option_id"] ?? "",
    itemId: json["item_id"] ?? "",
    price: json["price"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "option_id": optionId,
    "option_name": optionName,
    "status": status,
    "item_option_id": itemOptionId,
    "item_id": itemId,
    "price": price,
  };

  @override
  List<Object?> get props => [optionId, optionName, status, itemOptionId, itemId, price];
}
