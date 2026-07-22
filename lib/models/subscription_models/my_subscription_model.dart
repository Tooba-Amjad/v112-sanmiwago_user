// To parse this JSON data, do
//
//     final mySubscription = mySubscriptionFromJson(jsonString);

import 'dart:convert';

MySubscription mySubscriptionFromJson(String str) => MySubscription.fromJson(json.decode(str));

String mySubscriptionToJson(MySubscription data) => json.encode(data.toJson());

class MySubscription {
  String id;
  String offerId;
  String userId;
  String offerDuration;
  String paidAmount;
  String offerAmount;
  String paymentMethod;
  String subscriptionId;
  String restaurantId;
  dynamic stripToken;
  dynamic chargeId;
  String billingStartDate;
  String nextBillingDate;
  String refundAmount;
  String isRefund;
  String autoRenew;
  String createdAt;
  String updatedAt;
  String status;
  dynamic refundDate;
  String plateform;
  String subscriptionType;
  String offerName;
  String branchName;
  String branchAddress;

  MySubscription({
    this.id = "",
    this.offerId = "",
    this.userId = "",
    this.offerDuration = "",
    this.paidAmount = "",
    this.offerAmount = "",
    this.paymentMethod = "",
    this.subscriptionId = "",
    this.restaurantId = "",
    this.stripToken = "",
    this.chargeId = "",
    this.billingStartDate = "",
    this.nextBillingDate = "",
    this.refundAmount = "",
    this.isRefund = "",
    this.autoRenew = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.status = "",
    this.refundDate = "",
    this.plateform = "",
    this.subscriptionType = "",
    this.offerName = "",
    this.branchName = "",
    this.branchAddress = "",
  });

  MySubscription copyWith({
    String? id,
    String? offerId,
    String? userId,
    String? offerDuration,
    String? paidAmount,
    String? offerAmount,
    String? paymentMethod,
    String? subscriptionId,
    String? restaurantId,
    dynamic stripToken,
    dynamic chargeId,
    String? billingStartDate,
    String? nextBillingDate,
    String? refundAmount,
    String? isRefund,
    String? autoRenew,
    String? createdAt,
    String? updatedAt,
    String? status,
    dynamic refundDate,
    String? plateform,
    String? subscriptionType,
    String? offerName,
    String? branchName,
    String? branchAddress,
  }) =>
      MySubscription(
        id: id ?? this.id,
        offerId: offerId ?? this.offerId,
        userId: userId ?? this.userId,
        offerDuration: offerDuration ?? this.offerDuration,
        paidAmount: paidAmount ?? this.paidAmount,
        offerAmount: offerAmount ?? this.offerAmount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        subscriptionId: subscriptionId ?? this.subscriptionId,
        restaurantId: restaurantId ?? this.restaurantId,
        stripToken: stripToken ?? this.stripToken,
        chargeId: chargeId ?? this.chargeId,
        billingStartDate: billingStartDate ?? this.billingStartDate,
        nextBillingDate: nextBillingDate ?? this.nextBillingDate,
        refundAmount: refundAmount ?? this.refundAmount,
        isRefund: isRefund ?? this.isRefund,
        autoRenew: autoRenew ?? this.autoRenew,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        status: status ?? this.status,
        refundDate: refundDate ?? this.refundDate,
        plateform: plateform ?? this.plateform,
        subscriptionType: subscriptionType ?? this.subscriptionType,
        offerName: offerName ?? this.offerName,
        branchName: branchName ?? this.branchName,
        branchAddress: branchAddress ?? this.branchAddress,
      );

  factory MySubscription.fromJson(Map<String, dynamic> json) => MySubscription(
    id: json["id"] ?? "",
    offerId: json["offer_id"] ?? "",
    userId: json["user_id"] ?? "",
    offerDuration: json["offer_duration"] ?? "",
    paidAmount: json["paid_amount"] ?? "",
    offerAmount: json["offer_amount"] ?? "",
    paymentMethod: json["payment_method"] ?? "",
    subscriptionId: json["subscription_id"] ?? "",
    restaurantId: json["restaurant_id"] ?? "",
    stripToken: json["strip_token"] ?? "",
    chargeId: json["charge_id"] ?? "",
    billingStartDate: json["billing_start_date"] ?? "",
    nextBillingDate: json["next_billing_date"],
    refundAmount: json["refund_amount"] ?? "",
    isRefund: json["is_refund"] ?? "",
    autoRenew: json["auto_renew"] ?? "",
    createdAt: json["created_at"] ?? "",
    updatedAt: json["updated_at"] ?? "",
    status: json["status"] ?? "",
    refundDate: json["refund_date"] ?? "",
    plateform: json["plateform"] ?? "",
    subscriptionType: json["subscription_type"] ?? "",
    offerName: json["offer_name"] ?? "",
    branchName: json["branch_name"] ?? "",
    branchAddress: json["branch_address"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "offer_id": offerId,
    "user_id": userId,
    "offer_duration": offerDuration,
    "paid_amount": paidAmount,
    "offer_amount": offerAmount,
    "payment_method": paymentMethod,
    "subscription_id": subscriptionId,
    "restaurant_id": restaurantId,
    "strip_token": stripToken,
    "charge_id": chargeId,
    "billing_start_date": billingStartDate,
    "next_billing_date": nextBillingDate,
    "refund_amount": refundAmount,
    "is_refund": isRefund,
    "auto_renew": autoRenew,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "status": status,
    "refund_date": refundDate,
    "plateform": plateform,
    "subscription_type": subscriptionType,
    "offer_name": offerName,
    "branch_name": branchName,
    "branch_address": branchAddress,
  };
}
