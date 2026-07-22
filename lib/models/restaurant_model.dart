class Restaurant {
  String id;
  String branchName;
  String address;
  String phone;
  String dateTime;
  String status;
  String resType;

  Restaurant({
    this.id = "",
    this.branchName = "",
    this.address = "",
    this.phone = "",
    this.dateTime = "",
    this.status = "",
    this.resType = "",
  });

  Restaurant copyWith({
    String? id,
    String? branchName,
    String? address,
    String? phone,
    String? dateTime,
    String? status,
    String? resType,
  }) =>
      Restaurant(
        id: id ?? this.id,
        branchName: branchName ?? this.branchName,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        dateTime: dateTime ?? this.dateTime,
        status: status ?? this.status,
        resType: resType ?? this.resType,
      );

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    branchName: json["branch_name"] ?? "N/A",
    address: json["address"] ?? "N/A",
    phone: json["phone"] ?? "N/A",
    dateTime: json["date_time"] ?? "N/A",
    status: json["status"] ?? "inactive",
    resType: json["res_type"] ?? "simple",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "branch_name": branchName,
    "address": address,
    "phone": phone,
    "date_time": dateTime,
    "status": status,
    "res_type": resType,
  };
}
