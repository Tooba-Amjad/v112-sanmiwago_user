class GiftCard {
  String itemId;
  String menuId;
  String itemName;
  String itemImageName;
  String status;

  GiftCard({
    this.itemId = "",
    this.menuId = "",
    this.itemName = "",
    this.itemImageName = "",
    this.status = "",
  });

  GiftCard copyWith({
    String? itemId,
    String? menuId,
    String? itemName,
    String? itemImageName,
    String? status,
  }) =>
      GiftCard(
        itemId: itemId ?? this.itemId,
        menuId: menuId ?? this.menuId,
        itemName: itemName ?? this.itemName,
        itemImageName: itemImageName ?? this.itemImageName,
        status: status ?? this.status,
      );

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
    itemId: json["item_id"] ?? "",
    menuId: json["menu_id"] ?? "",
    itemName: json["item_name"] ?? "",
    itemImageName: json["item_image_name"] ?? "",
    status: json["status"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "item_id": itemId,
    "menu_id": menuId,
    "item_name": itemName,
    "item_image_name": itemImageName,
    "status": status,
  };
}
