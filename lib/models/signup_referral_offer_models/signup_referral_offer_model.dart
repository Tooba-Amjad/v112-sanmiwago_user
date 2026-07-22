import 'dart:convert';

class SignupReferralOffer {
  final String id;
  final String userId;
  final String count;
  final String offerId;
  final String createdAt;
  final String offerName;
  final String offerCost;
  final String offerDurations;
  final String planType;
  final String offerSubscriptions;
  final String? offerStartDate;
  final String? offerValidDate;
  final String offerConditions;
  final String noOfProducts;
  final String? offerImageName;
  final String dateOfOfferCreated;
  final String status;
  final String productId;
  final String restaurantId;
  final String refferalOffer;
  final List<ReferralHistory> referralHistory;

  SignupReferralOffer({
    this.id = "",
    this.userId = "",
    this.count = "",
    this.offerId = "",
    this.createdAt = "",
    this.offerName = "",
    this.offerCost = "",
    this.offerDurations = "",
    this.planType = "",
    this.offerSubscriptions = "",
    this.offerStartDate,
    this.offerValidDate,
    this.offerConditions = "",
    this.noOfProducts = "0",
    this.offerImageName,
    this.dateOfOfferCreated = "",
    this.status = "inactive",
    this.productId = "",
    this.restaurantId = "",
    this.refferalOffer = "",
    this.referralHistory = const [],
  });

  factory SignupReferralOffer.fromJson(Map<String, dynamic> json) {
    return SignupReferralOffer(
      id: json['id'] ?? "",
      userId: json['user_id'] ?? "",
      count: json['count'] ?? "",
      offerId: json['offer_id'] ?? "",
      createdAt: json['created_at'] ?? "",
      offerName: json['offer_name'] ?? "",
      offerCost: json['offer_cost'] ?? "",
      offerDurations: json['offer_durations'] ?? "",
      planType: json['plan_type'] ?? "",
      offerSubscriptions: json['offer_subscriptions'],
      offerStartDate: json['offer_start_date'] ?? "",
      offerValidDate: json['offer_valid_date'] ?? "",
      offerConditions: json['offer_conditions'] ?? "",
      noOfProducts: json['no_of_products'] ?? "0",
      offerImageName: json['offer_image_name'] ?? "",
      dateOfOfferCreated: json['date_of_offer_created'] ?? "",
      status: json['status'] ?? "",
      productId: json['product_id'] ?? "",
      restaurantId: json['restaurant_id'] ?? "",
      refferalOffer: json['refferal_offer'] ?? "",
      referralHistory: json['referral_history'] != null ? (jsonDecode(json['referral_history']) as List).map((e) => ReferralHistory.fromJson(e)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "user_id": userId,
      "count": count,
      "offer_id": offerId,
      "created_at": createdAt,
      "offer_name": offerName,
      "offer_cost": offerCost,
      "offer_durations": offerDurations,
      "plan_type": planType,
      "offer_subscriptions": offerSubscriptions,
      "offer_start_date": offerStartDate ?? "null",
      "offer_valid_date": offerValidDate ?? "null",
      "offer_conditions": offerConditions,
      "no_of_products": noOfProducts,
      "offer_image_name": offerImageName ?? "null",
      "date_of_offer_created": dateOfOfferCreated,
      "status": status,
      "product_id": productId,
      "restaurant_id": restaurantId,
      "refferal_offer": refferalOffer,
      "referral_history": jsonEncode(referralHistory.map((e) => e.toJson()).toList()),
    };
  }

  SignupReferralOffer copyWith({
    String? id,
    String? userId,
    String? count,
    String? offerId,
    String? createdAt,
    String? offerName,
    String? offerCost,
    String? offerDurations,
    String? planType,
    String? offerSubscriptions,
    String? offerStartDate,
    String? offerValidDate,
    String? offerConditions,
    String? noOfProducts,
    String? offerImageName,
    String? dateOfOfferCreated,
    String? status,
    String? productId,
    String? restaurantId,
    String? refferalOffer,
    List<ReferralHistory>? referralHistory,
  }) {
    return SignupReferralOffer(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      count: count ?? this.count,
      offerId: offerId ?? this.offerId,
      createdAt: createdAt ?? this.createdAt,
      offerName: offerName ?? this.offerName,
      offerCost: offerCost ?? this.offerCost,
      offerDurations: offerDurations ?? this.offerDurations,
      planType: planType ?? this.planType,
      offerSubscriptions: offerSubscriptions ?? this.offerSubscriptions,
      offerStartDate: offerStartDate ?? this.offerStartDate,
      offerValidDate: offerValidDate ?? this.offerValidDate,
      offerConditions: offerConditions ?? this.offerConditions,
      noOfProducts: noOfProducts ?? this.noOfProducts,
      offerImageName: offerImageName ?? this.offerImageName,
      dateOfOfferCreated: dateOfOfferCreated ?? this.dateOfOfferCreated,
      status: status ?? this.status,
      productId: productId ?? this.productId,
      restaurantId: restaurantId ?? this.restaurantId,
      refferalOffer: refferalOffer ?? this.refferalOffer,
      referralHistory: referralHistory ?? this.referralHistory,
    );
  }
}

class ReferralHistory {
  final String? type;
  final int? child;
  final int? parent;
  final String? childName;
  final String? createdAt;
  final int? historyId;
  final String? description;
  final String? parentName;

  ReferralHistory({
    this.type,
    this.child,
    this.parent,
    this.childName,
    this.createdAt,
    this.historyId,
    this.description,
    this.parentName,
  });

  factory ReferralHistory.fromJson(Map<String, dynamic> json) {
    return ReferralHistory(
      type: json['type'],
      child: json['child'],
      parent: json['parent'] ?? "",
      childName: json['child_name'],
      createdAt: json['created_at'],
      historyId: json['history_id'],
      description: json['description'],
      parentName: json['parent_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "child": child,
      "parent": parent,
      "child_name": childName,
      "created_at": createdAt,
      "history_id": historyId,
      "description": description,
      "parent_name": parentName,
    };
  }
}
