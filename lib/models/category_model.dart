import 'dart:convert';

MenuCategory categoryFromJson(String str) => MenuCategory.fromJson(json.decode(str));

String categoryToJson(MenuCategory data) => json.encode(data.toJson());

class MenuCategory {
  String menuId;
  String orderBy;
  String menuName;
  String punchLine;
  String description;
  String menuImageName;
  String status;

  String itemCount;

  MenuCategory({
    this.menuId = "",
    this.orderBy = "",
    this.menuName = "",
    this.punchLine = "",
    this.description = "",
    this.menuImageName = "",
    this.status = "",
    this.itemCount = "",
  });

  MenuCategory copyWith({
    String? menuId,
    String? orderBy,
    String? menuName,
    String? punchLine,
    String? description,
    String? menuImageName,
    String? status,
    String? itemCount,
  }) =>
      MenuCategory(
        menuId: menuId ?? this.menuId,
        orderBy: orderBy ?? this.orderBy,
        menuName: menuName ?? this.menuName,
        punchLine: punchLine ?? this.punchLine,
        description: description ?? this.description,
        menuImageName: menuImageName ?? this.menuImageName,
        status: status ?? this.status,
        itemCount: status ?? this.itemCount,
      );

  factory MenuCategory.fromJson(Map<String, dynamic> json) => MenuCategory(
        menuId: json["menu_id"] ?? "",
        orderBy: json["order_by"] ?? "",
        menuName: json["menu_name"] ?? "",
        punchLine: json["punch_line"] ?? "",
        description: json["description"] ?? "",
        menuImageName: json["menu_image_name"] ?? "",
        status: json["status"] ?? "",
        itemCount: json.containsKey("item_count") ? json["item_count"] ?? "0" : "1",
      );

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "order_by": orderBy,
        "menu_name": menuName,
        "punch_line": punchLine,
        "description": description,
        "menu_image_name": menuImageName,
        "status": status,
        "item_count": itemCount,
      };
}
