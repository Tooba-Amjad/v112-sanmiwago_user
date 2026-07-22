class GiftCardDetails {
  Data? data;
  List<ReloadAmount> reloadAmount;
  List<RedeemHistory> redeemHistory;
  List<RefundHistory> refundHistory;

  GiftCardDetails({
    this.data,
    this.reloadAmount = const [],
    this.redeemHistory = const [],
    this.refundHistory = const [],
  });

  GiftCardDetails copyWith({
    Data? data,
    List<ReloadAmount>? reloadAmount,
    List<RedeemHistory>? redeemHistory,
    List<RefundHistory>? refundHistory,
  }) =>
      GiftCardDetails(
        data: data ?? this.data,
        reloadAmount: reloadAmount ?? this.reloadAmount,
        redeemHistory: redeemHistory ?? this.redeemHistory,
        refundHistory: refundHistory ?? this.refundHistory,
      );

  factory GiftCardDetails.fromJson(Map<String, dynamic> json) => GiftCardDetails(
        data: Data.fromJson(json["data"]),
        reloadAmount: List<ReloadAmount>.from(json["reload_amount"].map((x) => ReloadAmount.fromJson(x))),
        redeemHistory: List<RedeemHistory>.from(json["redeem_history"].map((x) => RedeemHistory.fromJson(x))),
        refundHistory: List<RefundHistory>.from(json["refund_history"].map((x) => RefundHistory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "reload_amount": List<dynamic>.from(reloadAmount.map((x) => x.toJson())),
        "redeem_history": List<dynamic>.from(redeemHistory.map((x) => x.toJson())),
        "refund_history": List<dynamic>.from(refundHistory.map((x) => x.toJson())),
      };
}

class Data {
  String id;
  String giftItemId;
  String giftCardNo;
  String pin;
  String cardAmount;
  String totalAmount;
  String pointsEarn;
  String sendMyself;
  String userType;
  String senderName;
  String senderEmail;
  String senderPhone;
  String recipientName;
  String recipientEmail;
  String recipientPhone;
  String dateCreated;
  String paymentType;
  Items? items;

  Data({
    this.id = "",
    this.giftItemId = "",
    this.giftCardNo = "",
    this.pin = "",
    this.cardAmount = "",
    this.totalAmount = "",
    this.pointsEarn = "",
    this.sendMyself = "",
    this.userType = "",
    this.senderName = "",
    this.senderEmail = "",
    this.senderPhone = "",
    this.recipientName = "",
    this.recipientEmail = "",
    this.recipientPhone = "",
    this.dateCreated = "",
    this.paymentType = "",
    this.items,
  });

  Data copyWith({
    String? id,
    String? giftItemId,
    String? giftCardNo,
    String? pin,
    String? cardAmount,
    String? totalAmount,
    String? pointsEarn,
    String? sendMyself,
    String? userType,
    String? senderName,
    String? senderEmail,
    String? senderPhone,
    String? recipientName,
    String? recipientEmail,
    String? recipientPhone,
    String? dateCreated,
    String? paymentType,
    Items? items,
  }) =>
      Data(
        id: id ?? this.id,
        giftItemId: giftItemId ?? this.giftItemId,
        giftCardNo: giftCardNo ?? this.giftCardNo,
        pin: pin ?? this.pin,
        cardAmount: cardAmount ?? this.cardAmount,
        totalAmount: totalAmount ?? this.totalAmount,
        pointsEarn: pointsEarn ?? this.pointsEarn,
        sendMyself: sendMyself ?? this.sendMyself,
        userType: userType ?? this.userType,
        senderName: senderName ?? this.senderName,
        senderEmail: senderEmail ?? this.senderEmail,
        senderPhone: senderPhone ?? this.senderPhone,
        recipientName: recipientName ?? this.recipientName,
        recipientEmail: recipientEmail ?? this.recipientEmail,
        recipientPhone: recipientPhone ?? this.recipientPhone,
        dateCreated: dateCreated ?? this.dateCreated,
        paymentType: paymentType ?? this.paymentType,
        items: items ?? this.items,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"] ?? "",
        giftItemId: json["gift_item_id"] ?? "",
        giftCardNo: json["gift_card_no"] ?? "",
        pin: json["pin"] ?? "",
        cardAmount: json["card_amount"] ?? "",
        totalAmount: json["total_amount"] ?? "",
        pointsEarn: json["points_earn"] ?? "",
        sendMyself: json["send_myself"] ?? "",
        userType: json["user_type"] ?? "",
        senderName: json["sender_name"] ?? "",
        senderEmail: json["sender_email"] ?? "",
        senderPhone: json["sender_phone"] ?? "",
        recipientName: json["recipient_name"] ?? "",
        recipientEmail: json["recipient_email"] ?? "",
        recipientPhone: json["recipient_phone"] ?? "",
        dateCreated: json["date_created"] ?? "",
        paymentType: json["payment_type"] ?? "",
        items: json["items"] != null ? Items.fromJson(json["items"]) : Items(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gift_item_id": giftItemId,
        "gift_card_no": giftCardNo,
        "pin": pin,
        "card_amount": cardAmount,
        "total_amount": totalAmount,
        "points_earn": pointsEarn,
        "send_myself": sendMyself,
        "user_type": userType,
        "sender_name": senderName,
        "sender_email": senderEmail,
        "sender_phone": senderPhone,
        "recipient_name": recipientName,
        "recipient_email": recipientEmail,
        "recipient_phone": recipientPhone,
        "date_created": dateCreated,
        "payment_type": paymentType,
        "items": items?.toJson(),
      };
}

class Items {
  String itemId;
  String menuId;
  String itemName;
  String itemImageName;
  String status;

  Items({
    this.itemId = "",
    this.menuId = "",
    this.itemName = "",
    this.itemImageName = "",
    this.status = "",
  });

  Items copyWith({
    String? itemId,
    String? menuId,
    String? itemName,
    String? itemImageName,
    String? status,
  }) =>
      Items(
        itemId: itemId ?? this.itemId,
        menuId: menuId ?? this.menuId,
        itemName: itemName ?? this.itemName,
        itemImageName: itemImageName ?? this.itemImageName,
        status: status ?? this.status,
      );

  factory Items.fromJson(Map<String, dynamic> json) => Items(
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

class RedeemHistory {
  String id;
  String orderId;
  String invoiceNumber;
  String giftCardNo;
  String redeemAmount;
  String message;
  String dateTime;

  RedeemHistory({
    this.id = "",
    this.orderId = "",
    this.invoiceNumber = "",
    this.giftCardNo = "",
    this.redeemAmount = "",
    this.message = "",
    this.dateTime = "",
  });

  RedeemHistory copyWith({
    String? id,
    String? orderId,
    String? invoiceNumber,
    String? giftCardNo,
    String? redeemAmount,
    String? message,
    String? dateTime,
  }) =>
      RedeemHistory(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        giftCardNo: giftCardNo ?? this.giftCardNo,
        redeemAmount: redeemAmount ?? this.redeemAmount,
        message: message ?? this.message,
        dateTime: dateTime ?? this.dateTime,
      );

  factory RedeemHistory.fromJson(Map<String, dynamic> json) => RedeemHistory(
        id: json["id"] ?? "",
        orderId: json["order_id"] ?? "",
        invoiceNumber: json["invoice_number"] ?? "",
        giftCardNo: json["gift_card_no"] ?? "",
        redeemAmount: json["redeem_amount"] ?? "",
        message: json["message"] ?? "",
        dateTime: json["date_time"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "invoice_number": invoiceNumber,
        "gift_card_no": giftCardNo,
        "redeem_amount": redeemAmount,
        "message": message,
        "date_time": dateTime,
      };
}

class ReloadAmount {
  String id;
  String giftCardCode;
  String reloadAmount;
  String paymentType;
  String dateCreated;

  ReloadAmount({
    this.id = "",
    this.giftCardCode = "",
    this.reloadAmount = "",
    this.paymentType = "",
    this.dateCreated = "",
  });

  ReloadAmount copyWith({
    String? id,
    String? giftCardCode,
    String? reloadAmount,
    String? paymentType,
    String? dateCreated,
  }) =>
      ReloadAmount(
        id: id ?? this.id,
        giftCardCode: giftCardCode ?? this.giftCardCode,
        reloadAmount: reloadAmount ?? this.reloadAmount,
        paymentType: paymentType ?? this.paymentType,
        dateCreated: dateCreated ?? this.dateCreated,
      );

  factory ReloadAmount.fromJson(Map<String, dynamic> json) => ReloadAmount(
        id: json["id"] ?? "",
        giftCardCode: json["gift_card_code"] ?? "",
        reloadAmount: json["reload_amount"] ?? "",
        paymentType: json["payment_type"] ?? "",
        dateCreated: json["date_created"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gift_card_code": giftCardCode,
        "reload_amount": reloadAmount,
        "payment_type": paymentType,
        "date_created": dateCreated,
      };
}

class RefundHistory {
  String id;
  String orderId;
  String invoiceNumber;
  String giftCardNo;
  String refundAmount;
  String message;
  String dateTime;

  RefundHistory({
    this.id = "",
    this.orderId = "",
    this.invoiceNumber = "",
    this.giftCardNo = "",
    this.refundAmount = "",
    this.message = "",
    this.dateTime = "",
  });

  RefundHistory copyWith({
    String? id,
    String? orderId,
    String? invoiceNumber,
    String? giftCardNo,
    String? refundAmount,
    String? message,
    String? dateTime,
  }) =>
      RefundHistory(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        giftCardNo: giftCardNo ?? this.giftCardNo,
        refundAmount: refundAmount ?? this.refundAmount,
        message: message ?? this.message,
        dateTime: dateTime ?? this.dateTime,
      );

  factory RefundHistory.fromJson(Map<String, dynamic> json) => RefundHistory(
        id: json["id"],
        orderId: json["order_id"] ?? "",
        invoiceNumber: json["invoice_number"] ?? "",
        giftCardNo: json["gift_card_no"] ?? "",
        refundAmount: json["refund_amount"] ?? "",
        message: json["message"] ?? "",
        dateTime: json["date_time"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "invoice_number": invoiceNumber,
        "gift_card_no": giftCardNo,
        "refund_amount": refundAmount,
        "message": message,
        "date_time": dateTime,
      };
}
