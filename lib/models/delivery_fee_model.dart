import 'dart:convert';

DeliveryFeeInfoModel deliveryFeeModelFromJson(String str) => DeliveryFeeInfoModel.fromJson(json.decode(str));

String deliveryFeeModelToJson(DeliveryFeeInfoModel data) => json.encode(data.toJson());

class DeliveryFeeInfoModel {
  double doordashDeliveryFee;
  String distance;
  int statusfee;
  int reqPoints;
  String status;
  bool isOutOfBound;
  String isOutOfBoundMessage;

  DeliveryFeeInfoModel({
    this.doordashDeliveryFee = 0.0,
    this.distance = "0.0 miles",
    this.statusfee = 0,
    this.reqPoints = 0,
    this.status = "",
    this.isOutOfBound = false,
    this.isOutOfBoundMessage = "",
  });

  DeliveryFeeInfoModel copyWith({double? doordashDeliveryFee, String? distance, int? statusfee, int? reqPoints, String? status}) => DeliveryFeeInfoModel(
    doordashDeliveryFee: doordashDeliveryFee ?? this.doordashDeliveryFee,
    distance: distance ?? this.distance,
    statusfee: statusfee ?? this.statusfee,
    reqPoints: reqPoints ?? this.reqPoints,
    status: status ?? this.status,
  );

  factory DeliveryFeeInfoModel.fromJson(Map<String, dynamic> json) => DeliveryFeeInfoModel(
    doordashDeliveryFee: double.tryParse(json["doordash_delivery_fee"]?.toString() ?? "0.0") ?? 0.0,
    distance: json["distance"] ?? "",
    statusfee: json["statusfee"] ?? 0,
    reqPoints: json["req_points"] ?? 0,
    status: json["status"] ?? "",
    isOutOfBound: json["doordash_delivery_fee"] != null
        ? json["doordash_delivery_fee"].runtimeType == String && json["doordash_delivery_fee"].toString().toLowerCase().contains("cannot deliver over radius")
        : true, // true because if we did not get a valid delivery fee, it means we are out of bounds
    isOutOfBoundMessage: json["doordash_delivery_fee"]?.toString() ?? "",
  );

  Map<String, dynamic> toJson() => {
    "doordash_delivery_fee": doordashDeliveryFee,
    "isOutOfBound": isOutOfBound,
    "isOutOfBoundMessage": isOutOfBoundMessage,
    "distance": distance,
    "statusfee": statusfee,
    "req_points": reqPoints,
    "status": status,
  };
}
