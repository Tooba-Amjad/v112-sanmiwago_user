class MembershipCategory {
  String id;
  String category;
  String price;
  String percentage;

  MembershipCategory({
    this.id = "",
    this.category = "",
    this.price = "",
    this.percentage = "",
  });

  MembershipCategory copyWith({
    String? id,
    String? category,
    String? price,
    String? percentage,
  }) =>
      MembershipCategory(
        id: id ?? this.id,
        category: category ?? this.category,
        price: price ?? this.price,
        percentage: percentage ?? this.percentage,
      );

  factory MembershipCategory.fromJson(Map<String, dynamic> json) => MembershipCategory(
    id: json["id"] ?? "",
    category: json["category"] ?? "",
    price: json["price"] ?? "",
    percentage: json["percentage"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "price": price,
    "percentage": percentage,
  };
}
