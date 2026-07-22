class MyReferralOrder {
  String orderId;
  String invoiceNumber;
  dynamic refUserUid;
  String orderDate;
  String orderTime;
  String totalCost;
  String deliveryFee;
  String customerName;
  String phone;
  String email;
  dynamic houseNo;
  dynamic street;
  dynamic landmark;
  dynamic locality;
  dynamic city;
  dynamic cityId;
  dynamic pincode;
  String isPointsRedeemed;
  dynamic noOfPointsRedeemed;
  dynamic pointsValue;
  String totalEarnPoints;
  dynamic message;
  String dateCreated;
  String status;
  String paymentType;
  String membershipDiscount;
  dynamic paymentCard;
  dynamic paymentGateway;
  String noOfItems;
  String paidDate;
  String paidAmount;
  dynamic transactionId;
  String chargeId;
  String payerId;
  dynamic payerEmail;
  String payerName;
  String paymentStatus;
  String dateUpdated;
  dynamic deviceId;
  dynamic ratingValue;
  dynamic isAdminSentToKm;
  dynamic kmId;
  dynamic kmReceivedDatetime;
  dynamic isAdminSentToDm;
  dynamic isKmSentToDm;
  dynamic sentKmId;
  dynamic dmId;
  dynamic redeemedGiftCardNo;
  dynamic dmReceivedDatetime;
  dynamic lastUpdatedBy;
  dynamic lastUpdated;
  dynamic deliveredStatus;
  dynamic deliveredStatusDatetime;
  dynamic cancelledStatus;
  dynamic cancelledStatusDatetime;
  dynamic missedStatusDatetime;
  dynamic pickupTime;
  dynamic rejectReason;
  dynamic rejectedDateTme;
  dynamic acceptedDateTme;
  dynamic fulfilmentDateTme;
  String device;
  String salesTax;
  String isDumplingOrder;
  String isDrinkOrder;
  String isRiceOrder;
  String showCancelInDumplingOrder;
  String showCancelInRiceOrder;
  String showCancelInDrinkOrder;
  String hybridRedeemGiftAmount;


  MyReferralOrder({
    this.orderId = "",
    this.invoiceNumber = "",
    this.refUserUid = "",
    this.orderDate = "",
    this.orderTime = "",
    this.totalCost = "",
    this.deliveryFee = "",
    this.customerName = "",
    this.phone = "",
    this.email = "",
    this.houseNo,
    this.street,
    this.landmark,
    this.locality,
    this.city,
    this.cityId,
    this.pincode,
    this.isPointsRedeemed = "",
    this.noOfPointsRedeemed,
    this.pointsValue,
    this.totalEarnPoints = "",
    this.message,
    this.dateCreated = "",
    this.status = "",
    this.paymentType = "",
    this.membershipDiscount = "",
    this.paymentCard,
    this.paymentGateway,
    this.noOfItems = "",
    this.paidDate = "",
    this.paidAmount = "",
    this.transactionId,
    this.chargeId = "",
    this.payerId = "",
    this.payerEmail,
    this.payerName = "",
    this.paymentStatus = "",
    this.dateUpdated = "",
    this.deviceId,
    this.ratingValue,
    this.isAdminSentToKm,
    this.kmId,
    this.kmReceivedDatetime,
    this.isAdminSentToDm,
    this.isKmSentToDm,
    this.sentKmId,
    this.dmId,
    this.redeemedGiftCardNo,
    this.dmReceivedDatetime,
    this.lastUpdatedBy,
    this.lastUpdated,
    this.deliveredStatus,
    this.deliveredStatusDatetime,
    this.cancelledStatus,
    this.cancelledStatusDatetime,
    this.missedStatusDatetime,
    this.pickupTime,
    this.rejectReason,
    this.rejectedDateTme,
    this.acceptedDateTme,
    this.fulfilmentDateTme,
    this.device = "",
    this.salesTax = "",
    this.isDumplingOrder = "",
    this.isDrinkOrder = "",
    this.isRiceOrder = "",
    this.showCancelInDumplingOrder = "",
    this.showCancelInRiceOrder = "",
    this.showCancelInDrinkOrder = "",
    this.hybridRedeemGiftAmount = "",
  });

  MyReferralOrder copyWith({
    String? orderId,
    String? invoiceNumber,
    dynamic refUserUid,
    String? orderDate,
    String? orderTime,
    String? totalCost,
    String? deliveryFee,
    String? customerName,
    String? phone,
    String? email,
    dynamic houseNo,
    dynamic street,
    dynamic landmark,
    dynamic locality,
    dynamic city,
    dynamic cityId,
    dynamic pincode,
    String? isPointsRedeemed,
    dynamic noOfPointsRedeemed,
    dynamic pointsValue,
    String? totalEarnPoints,
    dynamic message,
    String? dateCreated,
    String? status,
    String? paymentType,
    String? membershipDiscount,
    dynamic paymentCard,
    dynamic paymentGateway,
    String? noOfItems,
    String? paidDate,
    String? paidAmount,
    dynamic transactionId,
    String? chargeId,
    String? payerId,
    dynamic payerEmail,
    String? payerName,
    String? paymentStatus,
    String? dateUpdated,
    dynamic deviceId,
    dynamic ratingValue,
    dynamic isAdminSentToKm,
    dynamic kmId,
    dynamic kmReceivedDatetime,
    dynamic isAdminSentToDm,
    dynamic isKmSentToDm,
    dynamic sentKmId,
    dynamic dmId,
    dynamic redeemedGiftCardNo,
    dynamic dmReceivedDatetime,
    dynamic lastUpdatedBy,
    dynamic lastUpdated,
    dynamic deliveredStatus,
    dynamic deliveredStatusDatetime,
    dynamic cancelledStatus,
    dynamic cancelledStatusDatetime,
    dynamic missedStatusDatetime,
    dynamic pickupTime,
    dynamic rejectReason,
    dynamic rejectedDateTme,
    dynamic acceptedDateTme,
    dynamic fulfilmentDateTme,
    String? device,
    String? salesTax,
    String? isDumplingOrder,
    String? isDrinkOrder,
    String? isRiceOrder,
    String? showCancelInDumplingOrder,
    String? showCancelInRiceOrder,
    String? showCancelInDrinkOrder,
    String? hybridRedeemGiftAmount,
  }) =>
      MyReferralOrder(
        orderId: orderId ?? this.orderId,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        refUserUid: refUserUid ?? this.refUserUid,
        orderDate: orderDate ?? this.orderDate,
        orderTime: orderTime ?? this.orderTime,
        totalCost: totalCost ?? this.totalCost,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        customerName: customerName ?? this.customerName,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        houseNo: houseNo ?? this.houseNo,
        street: street ?? this.street,
        landmark: landmark ?? this.landmark,
        locality: locality ?? this.locality,
        city: city ?? this.city,
        cityId: cityId ?? this.cityId,
        pincode: pincode ?? this.pincode,
        isPointsRedeemed: isPointsRedeemed ?? this.isPointsRedeemed,
        noOfPointsRedeemed: noOfPointsRedeemed ?? this.noOfPointsRedeemed,
        pointsValue: pointsValue ?? this.pointsValue,
        totalEarnPoints: totalEarnPoints ?? this.totalEarnPoints,
        message: message ?? this.message,
        dateCreated: dateCreated ?? this.dateCreated,
        status: status ?? this.status,
        paymentType: paymentType ?? this.paymentType,
        membershipDiscount: membershipDiscount ?? this.membershipDiscount,
        paymentCard: paymentCard ?? this.paymentCard,
        paymentGateway: paymentGateway ?? this.paymentGateway,
        noOfItems: noOfItems ?? this.noOfItems,
        paidDate: paidDate ?? this.paidDate,
        paidAmount: paidAmount ?? this.paidAmount,
        transactionId: transactionId ?? this.transactionId,
        chargeId: chargeId ?? this.chargeId,
        payerId: payerId ?? this.payerId,
        payerEmail: payerEmail ?? this.payerEmail,
        payerName: payerName ?? this.payerName,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        dateUpdated: dateUpdated ?? this.dateUpdated,
        deviceId: deviceId ?? this.deviceId,
        ratingValue: ratingValue ?? this.ratingValue,
        isAdminSentToKm: isAdminSentToKm ?? this.isAdminSentToKm,
        kmId: kmId ?? this.kmId,
        kmReceivedDatetime: kmReceivedDatetime ?? this.kmReceivedDatetime,
        isAdminSentToDm: isAdminSentToDm ?? this.isAdminSentToDm,
        isKmSentToDm: isKmSentToDm ?? this.isKmSentToDm,
        sentKmId: sentKmId ?? this.sentKmId,
        dmId: dmId ?? this.dmId,
        redeemedGiftCardNo: redeemedGiftCardNo ?? this.redeemedGiftCardNo,
        dmReceivedDatetime: dmReceivedDatetime ?? this.dmReceivedDatetime,
        lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
        lastUpdated: lastUpdated ?? this.lastUpdated,
        deliveredStatus: deliveredStatus ?? this.deliveredStatus,
        deliveredStatusDatetime: deliveredStatusDatetime ?? this.deliveredStatusDatetime,
        cancelledStatus: cancelledStatus ?? this.cancelledStatus,
        cancelledStatusDatetime: cancelledStatusDatetime ?? this.cancelledStatusDatetime,
        missedStatusDatetime: missedStatusDatetime ?? this.missedStatusDatetime,
        pickupTime: pickupTime ?? this.pickupTime,
        rejectReason: rejectReason ?? this.rejectReason,
        rejectedDateTme: rejectedDateTme ?? this.rejectedDateTme,
        acceptedDateTme: acceptedDateTme ?? this.acceptedDateTme,
        fulfilmentDateTme: fulfilmentDateTme ?? this.fulfilmentDateTme,
        device: device ?? this.device,
        salesTax: salesTax ?? this.salesTax,
        isDumplingOrder: isDumplingOrder ?? this.isDumplingOrder,
        isDrinkOrder: isDrinkOrder ?? this.isDrinkOrder,
        isRiceOrder: isRiceOrder ?? this.isRiceOrder,
        showCancelInDumplingOrder: showCancelInDumplingOrder ?? this.showCancelInDumplingOrder,
        showCancelInRiceOrder: showCancelInRiceOrder ?? this.showCancelInRiceOrder,
        showCancelInDrinkOrder: showCancelInDrinkOrder ?? this.showCancelInDrinkOrder,
        hybridRedeemGiftAmount: hybridRedeemGiftAmount ?? this.hybridRedeemGiftAmount,
      );

  factory MyReferralOrder.fromJson(Map<String, dynamic> json) => MyReferralOrder(
    orderId: json["order_id"] ?? "",
    invoiceNumber: json["invoice_number"] ?? "",
    refUserUid: json["ref_user_uid"] ?? "",
    orderDate: json["order_date"] ?? "",
    orderTime: json["order_time"] ?? "",
    totalCost: json["total_cost"] ?? "",
    deliveryFee: json["delivery_fee"] ?? "",
    customerName: json["customer_name"] ?? "",
    phone: json["phone"] ?? "",
    email: json["email"] ?? "",
    houseNo: json["house_no"] ?? "",
    street: json["street"] ?? "",
    landmark: json["landmark"] ?? "",
    locality: json["locality"] ?? "",
    city: json["city"] ?? "",
    cityId: json["city_id"] ?? "",
    pincode: json["pincode"] ?? "",
    isPointsRedeemed: json["is_points_redeemed"] ?? "",
    noOfPointsRedeemed: json["no_of_points_redeemed"] ?? "",
    pointsValue: json["points_value"] ?? "",
    totalEarnPoints: json["total_earn_points"] ?? "",
    message: json["message"] ?? "",
    dateCreated: json["date_created"] ?? "",
    status: json["status"] ?? "",
    paymentType: json["payment_type"] ?? "",
    membershipDiscount: json["membership_discount"] ?? "",
    paymentCard: json["payment_card"] ?? "",
    paymentGateway: json["payment_gateway"] ?? "",
    noOfItems: json["no_of_items"] ?? "",
    paidDate: json["paid_date"] ?? "",
    paidAmount: json["paid_amount"] ?? "",
    transactionId: json["transaction_id"] ?? "",
    chargeId: json["charge_id"] ?? "",
    payerId: json["payer_id"] ?? "",
    payerEmail: json["payer_email"] ?? "",
    payerName: json["payer_name"] ?? "",
    paymentStatus: json["payment_status"] ?? "",
    dateUpdated: json["date_updated"] ?? "",
    deviceId: json["device_id"] ?? "",
    ratingValue: json["rating_value"] ?? "",
    isAdminSentToKm: json["is_admin_sent_to_km"] ?? "",
    kmId: json["km_id"] ?? "",
    kmReceivedDatetime: json["km_received_datetime"] ?? "",
    isAdminSentToDm: json["is_admin_sent_to_dm"] ?? "",
    isKmSentToDm: json["is_km_sent_to_dm"] ?? "",
    sentKmId: json["sent_km_id"] ?? "",
    dmId: json["dm_id"] ?? "",
    redeemedGiftCardNo: json["redeemed_gift_card_no"] ?? "",
    dmReceivedDatetime: json["dm_received_datetime"] ?? "",
    lastUpdatedBy: json["last_updated_by"] ?? "",
    lastUpdated: json["last_updated"] ?? "",
    deliveredStatus: json["delivered_status"] ?? "",
    deliveredStatusDatetime: json["delivered_status_datetime"] ?? "",
    cancelledStatus: json["cancelled_status"] ?? "",
    cancelledStatusDatetime: json["cancelled_status_datetime"] ?? "",
    missedStatusDatetime: json["missed_status_datetime"] ?? "",
    pickupTime: json["pickup_time"] ?? "",
    rejectReason: json["reject_reason"] ?? "",
    rejectedDateTme: json["rejected_date_tme"] ?? "",
    acceptedDateTme: json["accepted_date_tme"] ?? "",
    fulfilmentDateTme: json["fulfilment_date_tme"] ?? "",
    device: json["device"] ?? "",
    salesTax: json["sales_tax"] ?? "",
    isDumplingOrder: json["is_dumpling_order"] ?? "",
    isDrinkOrder: json["is_drink_order"] ?? "",
    isRiceOrder: json["is_rice_order"] ?? "",
    showCancelInDumplingOrder: json["show_cancel_in_dumpling_order"] ?? "",
    showCancelInRiceOrder: json["show_cancel_in_rice_order"] ?? "",
    showCancelInDrinkOrder: json["show_cancel_in_drink_order"] ?? "",
    hybridRedeemGiftAmount: json["hybrid_redeem_gift_amount"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "invoice_number": invoiceNumber,
    "ref_user_uid": refUserUid,
    "order_date": orderDate,
    "order_time": orderTime,
    "total_cost": totalCost,
    "delivery_fee": deliveryFee,
    "customer_name": customerName,
    "phone": phone,
    "email": email,
    "house_no": houseNo,
    "street": street,
    "landmark": landmark,
    "locality": locality,
    "city": city,
    "city_id": cityId,
    "pincode": pincode,
    "is_points_redeemed": isPointsRedeemed,
    "no_of_points_redeemed": noOfPointsRedeemed,
    "points_value": pointsValue,
    "total_earn_points": totalEarnPoints,
    "message": message,
    "date_created": dateCreated,
    "status": status,
    "payment_type": paymentType,
    "membership_discount": membershipDiscount,
    "payment_card": paymentCard,
    "payment_gateway": paymentGateway,
    "no_of_items": noOfItems,
    "paid_date": paidDate,
    "paid_amount": paidAmount,
    "transaction_id": transactionId,
    "charge_id": chargeId,
    "payer_id": payerId,
    "payer_email": payerEmail,
    "payer_name": payerName,
    "payment_status": paymentStatus,
    "date_updated": dateUpdated,
    "device_id": deviceId,
    "rating_value": ratingValue,
    "is_admin_sent_to_km": isAdminSentToKm,
    "km_id": kmId,
    "km_received_datetime": kmReceivedDatetime,
    "is_admin_sent_to_dm": isAdminSentToDm,
    "is_km_sent_to_dm": isKmSentToDm,
    "sent_km_id": sentKmId,
    "dm_id": dmId,
    "redeemed_gift_card_no": redeemedGiftCardNo,
    "dm_received_datetime": dmReceivedDatetime,
    "last_updated_by": lastUpdatedBy,
    "last_updated": lastUpdated,
    "delivered_status": deliveredStatus,
    "delivered_status_datetime": deliveredStatusDatetime,
    "cancelled_status": cancelledStatus,
    "cancelled_status_datetime": cancelledStatusDatetime,
    "missed_status_datetime": missedStatusDatetime,
    "pickup_time": pickupTime,
    "reject_reason": rejectReason,
    "rejected_date_tme": rejectedDateTme,
    "accepted_date_tme": acceptedDateTme,
    "fulfilment_date_tme": fulfilmentDateTme,
    "device": device,
    "sales_tax": salesTax,
    "is_dumpling_order": isDumplingOrder,
    "is_drink_order": isDrinkOrder,
    "is_rice_order": isRiceOrder,
    "show_cancel_in_dumpling_order": showCancelInDumplingOrder,
    "show_cancel_in_rice_order": showCancelInRiceOrder,
    "show_cancel_in_drink_order": showCancelInDrinkOrder,
    "hybrid_redeem_gift_amount": hybridRedeemGiftAmount,
  };
}
