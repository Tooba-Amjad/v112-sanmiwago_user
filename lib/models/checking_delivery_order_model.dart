import 'dart:convert';

DeliveryAllowedModel deliveryModelFromJson(String str) => DeliveryAllowedModel.fromJson(json.decode(str));

String deliveryModelToJson(DeliveryAllowedModel data) => json.encode(data.toJson());

class DeliveryAllowedModel {
  final String? status;
  final String? isDeliveryOrderAllow;

  DeliveryAllowedModel({
    this.status,
    this.isDeliveryOrderAllow = "No",
  });

  factory DeliveryAllowedModel.fromJson(Map<String, dynamic> json) => DeliveryAllowedModel(
        status: json["status"],
        isDeliveryOrderAllow: json["is_delivery_order_allow"] ?? "No",
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "is_delivery_order_allow": isDeliveryOrderAllow,
      };
}
