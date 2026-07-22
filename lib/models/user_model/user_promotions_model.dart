class UserPromotion {
  String id;
  String type;
  String description;
  String status;
  String? createdAt;

  UserPromotion({
    this.id = "",
    this.type = "",
    this.description = "",
    this.status = "",
    this.createdAt = "",
  });

  UserPromotion copyWith({
    String? id,
    String? type,
    String? description,
    String? status,
    String? createdAt,
  }) =>
      UserPromotion(
        id: id ?? this.id,
        type: type ?? this.type,
        description: description ?? this.description,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
      );

  factory UserPromotion.fromJson(Map<String, dynamic> json) => UserPromotion(
        id: json["id"] ?? "",
        type: json["type"] ?? "",
        description: json["description"] ?? "",
        status: json["status"] ?? "",
        createdAt: json["created_at"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "description": description,
        "status": status,
        "created_at": createdAt,
      };
}
