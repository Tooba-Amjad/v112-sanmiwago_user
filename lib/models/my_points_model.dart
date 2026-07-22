// To parse this JSON data, do
//
//     final myPoints = myPointsFromJson(jsonString);

import 'dart:convert';

MyPoints myPointsFromJson(String str) => MyPoints.fromJson(json.decode(str));

String myPointsToJson(MyPoints data) => json.encode(data.toJson());

class MyPoints {
  String customerRewardId;
  String userId;
  String referById;
  String points;
  String transactionType;
  String orderId;
  String invoiceNumber;
  String description;
  String createdOn;

  MyPoints({
    this.customerRewardId = "",
    this.userId = "",
    this.referById = "",
    this.points = "",
    this.transactionType = "",
    this.orderId = "",
    this.invoiceNumber = "",
    this.description = "",
    this.createdOn = "",
  });

  MyPoints copyWith({
    String? customerRewardId,
    String? userId,
    String? referById,
    String? points,
    String? transactionType,
    String? orderId,
    String? invoiceNumber,
    String? description,
    String? createdOn,
  }) =>
      MyPoints(
        customerRewardId: customerRewardId ?? this.customerRewardId,
        userId: userId ?? this.userId,
        referById: referById ?? this.referById,
        points: points ?? this.points,
        transactionType: transactionType ?? this.transactionType,
        orderId: orderId ?? this.orderId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        description: description ?? this.description,
        createdOn: createdOn ?? this.createdOn,
      );

  factory MyPoints.fromJson(Map<String, dynamic> json) => MyPoints(
    customerRewardId: json["customer_reward_id"] ?? "",
    userId: json["user_id"] ?? "",
    referById: json["refer_by_id"] ?? "",
    points: json["points"] ?? "0",
    transactionType: json["transaction_type"] ?? "",
    orderId: json["order_id"] ?? "",
    invoiceNumber: json["invoice_number"] ?? "",
    description: json["description"] ?? "",
    createdOn: json["created_on"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "customer_reward_id": customerRewardId,
    "user_id": userId,
    "refer_by_id": referById,
    "points": points,
    "transaction_type": transactionType,
    "order_id": orderId,
    "invoice_number": invoiceNumber,
    "description": description,
    "created_on": createdOn,
  };
}
