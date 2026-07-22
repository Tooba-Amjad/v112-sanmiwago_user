class UnusedMyOrder {
  UnusedMyOrder({
    String? orderId,
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
  }) {
    _orderId = orderId ?? "";
    _refUserUid = refUserUid;
    _orderDate = orderDate ?? "";
    _orderTime = orderTime ?? "";
    _totalCost = totalCost ?? "";
    _deliveryFee = deliveryFee ?? "";
    _customerName = customerName ?? "";
    _phone = phone ?? "";
    _email = email ?? "";
    _houseNo = houseNo;
    _street = street;
    _landmark = landmark;
    _locality = locality;
    _city = city;
    _cityId = cityId;
    _pincode = pincode;
    _isPointsRedeemed = isPointsRedeemed ?? "";
    _noOfPointsRedeemed = noOfPointsRedeemed ?? "";
    _pointsValue = pointsValue ?? "";
    _totalEarnPoints = totalEarnPoints ?? "";
    _message = message ?? "";
    _dateCreated = dateCreated ?? "";
    _status = status ?? "";
    _paymentType = paymentType ?? "";
    _membershipDiscount = membershipDiscount ?? "";
    _paymentCard = paymentCard ?? "";
    _paymentGateway = paymentGateway;
    _noOfItems = noOfItems ?? "";
    _paidDate = paidDate ?? "";
    _paidAmount = paidAmount ?? "";
    _transactionId = transactionId ?? "";
    _chargeId = chargeId ?? "";
    _payerId = payerId ?? "";
    _payerEmail = payerEmail ?? "";
    _payerName = payerName ?? "";
    _paymentStatus = paymentStatus ?? "";
    _dateUpdated = dateUpdated ?? "";
    _deviceId = deviceId;
    _ratingValue = ratingValue;
    _isAdminSentToKm = isAdminSentToKm;
    _kmId = kmId;
    _kmReceivedDatetime = kmReceivedDatetime;
    _isAdminSentToDm = isAdminSentToDm;
    _isKmSentToDm = isKmSentToDm;
    _sentKmId = sentKmId;
    _dmId = dmId;
    _redeemedGiftCardNo = redeemedGiftCardNo;
    _dmReceivedDatetime = dmReceivedDatetime;
    _lastUpdatedBy = lastUpdatedBy;
    _lastUpdated = lastUpdated;
    _deliveredStatus = deliveredStatus;
    _deliveredStatusDatetime = deliveredStatusDatetime;
    _cancelledStatus = cancelledStatus;
    _cancelledStatusDatetime = cancelledStatusDatetime;
    _missedStatusDatetime = missedStatusDatetime;
    _pickupTime = pickupTime;
    _rejectReason = rejectReason;
    _rejectedDateTme = rejectedDateTme;
    _acceptedDateTme = acceptedDateTme;
    _fulfilmentDateTme = fulfilmentDateTme;
    _device = device ?? "";
    _salesTax = salesTax ?? "";
    _isDumplingOrder = isDumplingOrder ?? "";
    _isDrinkOrder = isDrinkOrder ?? "";
    _isRiceOrder = isRiceOrder ?? "";
    _showCancelInDumplingOrder = showCancelInDumplingOrder ?? "";
    _showCancelInRiceOrder = showCancelInRiceOrder ?? "";
    _showCancelInDrinkOrder = showCancelInDrinkOrder ?? "";
    _hybridRedeemGiftAmount = hybridRedeemGiftAmount ?? "";
  }

  UnusedMyOrder.fromJson(dynamic json) {
    _orderId = json['order_id'];
    _refUserUid = json['ref_user_uid'];
    _orderDate = json['order_date'];
    _orderTime = json['order_time'];
    _totalCost = json['total_cost'];
    _deliveryFee = json['delivery_fee'];
    _customerName = json['customer_name'];
    _phone = json['phone'];
    _email = json['email'];
    _houseNo = json['house_no'];
    _street = json['street'];
    _landmark = json['landmark'];
    _locality = json['locality'];
    _city = json['city'];
    _cityId = json['city_id'];
    _pincode = json['pincode'];
    _isPointsRedeemed = json['is_points_redeemed'];
    _noOfPointsRedeemed = json['no_of_points_redeemed'];
    _pointsValue = json['points_value'];
    _totalEarnPoints = json['total_earn_points'];
    _message = json['message'];
    _dateCreated = json['date_created'];
    _status = json['status'];
    _paymentType = json['payment_type'];
    _membershipDiscount = json['membership_discount'];
    _paymentCard = json['payment_card'];
    _paymentGateway = json['payment_gateway'];
    _noOfItems = json['no_of_items'];
    _paidDate = json['paid_date'];
    _paidAmount = json['paid_amount'];
    _transactionId = json['transaction_id'];
    _chargeId = json['charge_id'];
    _payerId = json['payer_id'];
    _payerEmail = json['payer_email'];
    _payerName = json['payer_name'];
    _paymentStatus = json['payment_status'];
    _dateUpdated = json['date_updated'];
    _deviceId = json['device_id'];
    _ratingValue = json['rating_value'];
    _isAdminSentToKm = json['is_admin_sent_to_km'];
    _kmId = json['km_id'];
    _kmReceivedDatetime = json['km_received_datetime'];
    _isAdminSentToDm = json['is_admin_sent_to_dm'];
    _isKmSentToDm = json['is_km_sent_to_dm'];
    _sentKmId = json['sent_km_id'];
    _dmId = json['dm_id'];
    _redeemedGiftCardNo = json['redeemed_gift_card_no'];
    _dmReceivedDatetime = json['dm_received_datetime'];
    _lastUpdatedBy = json['last_updated_by'];
    _lastUpdated = json['last_updated'];
    _deliveredStatus = json['delivered_status'];
    _deliveredStatusDatetime = json['delivered_status_datetime'];
    _cancelledStatus = json['cancelled_status'];
    _cancelledStatusDatetime = json['cancelled_status_datetime'];
    _missedStatusDatetime = json['missed_status_datetime'];
    _pickupTime = json['pickup_time'];
    _rejectReason = json['reject_reason'];
    _rejectedDateTme = json['rejected_date_tme'];
    _acceptedDateTme = json['accepted_date_tme'];
    _fulfilmentDateTme = json['fulfilment_date_tme'];
    _device = json['device'];
    _salesTax = json['sales_tax'];
    _isDumplingOrder = json['is_dumpling_order'];
    _isDrinkOrder = json['is_drink_order'];
    _isRiceOrder = json['is_rice_order'];
    _showCancelInDumplingOrder = json['show_cancel_in_dumpling_order'];
    _showCancelInRiceOrder = json['show_cancel_in_rice_order'];
    _showCancelInDrinkOrder = json['show_cancel_in_drink_order'];
    _hybridRedeemGiftAmount = json['hybrid_redeem_gift_amount'];
  }
  String? _orderId;
  dynamic _refUserUid;
  String? _orderDate;
  String? _orderTime;
  String? _totalCost;
  String? _deliveryFee;
  String? _customerName;
  String? _phone;
  String? _email;
  dynamic _houseNo;
  dynamic _street;
  dynamic _landmark;
  dynamic _locality;
  dynamic _city;
  dynamic _cityId;
  dynamic _pincode;
  String? _isPointsRedeemed;
  dynamic _noOfPointsRedeemed;
  dynamic _pointsValue;
  String? _totalEarnPoints;
  dynamic _message;
  String? _dateCreated;
  String? _status;
  String? _paymentType;
  String? _membershipDiscount;
  dynamic _paymentCard;
  dynamic _paymentGateway;
  String? _noOfItems;
  String? _paidDate;
  String? _paidAmount;
  dynamic _transactionId;
  String? _chargeId;
  String? _payerId;
  dynamic _payerEmail;
  String? _payerName;
  String? _paymentStatus;
  String? _dateUpdated;
  dynamic _deviceId;
  dynamic _ratingValue;
  dynamic _isAdminSentToKm;
  dynamic _kmId;
  dynamic _kmReceivedDatetime;
  dynamic _isAdminSentToDm;
  dynamic _isKmSentToDm;
  dynamic _sentKmId;
  dynamic _dmId;
  dynamic _redeemedGiftCardNo;
  dynamic _dmReceivedDatetime;
  dynamic _lastUpdatedBy;
  dynamic _lastUpdated;
  dynamic _deliveredStatus;
  dynamic _deliveredStatusDatetime;
  dynamic _cancelledStatus;
  dynamic _cancelledStatusDatetime;
  dynamic _missedStatusDatetime;
  dynamic _pickupTime;
  dynamic _rejectReason;
  dynamic _rejectedDateTme;
  dynamic _acceptedDateTme;
  dynamic _fulfilmentDateTme;
  String? _device;
  String? _salesTax;
  String? _isDumplingOrder;
  String? _isDrinkOrder;
  String? _isRiceOrder;
  String? _showCancelInDumplingOrder;
  String? _showCancelInRiceOrder;
  String? _showCancelInDrinkOrder;
  String? _hybridRedeemGiftAmount;

  UnusedMyOrder copyWith({
    String? orderId,
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
      UnusedMyOrder(
        orderId: orderId ?? _orderId,
        refUserUid: refUserUid ?? _refUserUid,
        orderDate: orderDate ?? _orderDate,
        orderTime: orderTime ?? _orderTime,
        totalCost: totalCost ?? _totalCost,
        deliveryFee: deliveryFee ?? _deliveryFee,
        customerName: customerName ?? _customerName,
        phone: phone ?? _phone,
        email: email ?? _email,
        houseNo: houseNo ?? _houseNo,
        street: street ?? _street,
        landmark: landmark ?? _landmark,
        locality: locality ?? _locality,
        city: city ?? _city,
        cityId: cityId ?? _cityId,
        pincode: pincode ?? _pincode,
        isPointsRedeemed: isPointsRedeemed ?? _isPointsRedeemed,
        noOfPointsRedeemed: noOfPointsRedeemed ?? _noOfPointsRedeemed,
        pointsValue: pointsValue ?? _pointsValue,
        totalEarnPoints: totalEarnPoints ?? _totalEarnPoints,
        message: message ?? _message,
        dateCreated: dateCreated ?? _dateCreated,
        status: status ?? _status,
        paymentType: paymentType ?? _paymentType,
        membershipDiscount: membershipDiscount ?? _membershipDiscount,
        paymentCard: paymentCard ?? _paymentCard,
        paymentGateway: paymentGateway ?? _paymentGateway,
        noOfItems: noOfItems ?? _noOfItems,
        paidDate: paidDate ?? _paidDate,
        paidAmount: paidAmount ?? _paidAmount,
        transactionId: transactionId ?? _transactionId,
        chargeId: chargeId ?? _chargeId,
        payerId: payerId ?? _payerId,
        payerEmail: payerEmail ?? _payerEmail,
        payerName: payerName ?? _payerName,
        paymentStatus: paymentStatus ?? _paymentStatus,
        dateUpdated: dateUpdated ?? _dateUpdated,
        deviceId: deviceId ?? _deviceId,
        ratingValue: ratingValue ?? _ratingValue,
        isAdminSentToKm: isAdminSentToKm ?? _isAdminSentToKm,
        kmId: kmId ?? _kmId,
        kmReceivedDatetime: kmReceivedDatetime ?? _kmReceivedDatetime,
        isAdminSentToDm: isAdminSentToDm ?? _isAdminSentToDm,
        isKmSentToDm: isKmSentToDm ?? _isKmSentToDm,
        sentKmId: sentKmId ?? _sentKmId,
        dmId: dmId ?? _dmId,
        redeemedGiftCardNo: redeemedGiftCardNo ?? _redeemedGiftCardNo,
        dmReceivedDatetime: dmReceivedDatetime ?? _dmReceivedDatetime,
        lastUpdatedBy: lastUpdatedBy ?? _lastUpdatedBy,
        lastUpdated: lastUpdated ?? _lastUpdated,
        deliveredStatus: deliveredStatus ?? _deliveredStatus,
        deliveredStatusDatetime: deliveredStatusDatetime ?? _deliveredStatusDatetime,
        cancelledStatus: cancelledStatus ?? _cancelledStatus,
        cancelledStatusDatetime: cancelledStatusDatetime ?? _cancelledStatusDatetime,
        missedStatusDatetime: missedStatusDatetime ?? _missedStatusDatetime,
        pickupTime: pickupTime ?? _pickupTime,
        rejectReason: rejectReason ?? _rejectReason,
        rejectedDateTme: rejectedDateTme ?? _rejectedDateTme,
        acceptedDateTme: acceptedDateTme ?? _acceptedDateTme,
        fulfilmentDateTme: fulfilmentDateTme ?? _fulfilmentDateTme,
        device: device ?? _device,
        salesTax: salesTax ?? _salesTax,
        isDumplingOrder: isDumplingOrder ?? _isDumplingOrder,
        isDrinkOrder: isDrinkOrder ?? _isDrinkOrder,
        isRiceOrder: isRiceOrder ?? _isRiceOrder,
        showCancelInDumplingOrder: showCancelInDumplingOrder ?? _showCancelInDumplingOrder,
        showCancelInRiceOrder: showCancelInRiceOrder ?? _showCancelInRiceOrder,
        showCancelInDrinkOrder: showCancelInDrinkOrder ?? _showCancelInDrinkOrder,
        hybridRedeemGiftAmount: hybridRedeemGiftAmount ?? _hybridRedeemGiftAmount,
      );
  String get orderId => _orderId ?? "";
  dynamic get refUserUid => _refUserUid ?? "";
  String get orderDate => _orderDate ?? "";
  String get orderTime => _orderTime ?? "";
  String get totalCost => _totalCost ?? "";
  String get deliveryFee => _deliveryFee ?? "";
  String get customerName => _customerName ?? "";
  String get phone => _phone ?? "";
  String get email => _email ?? "";
  dynamic get houseNo => _houseNo;
  dynamic get street => _street;
  dynamic get landmark => _landmark;
  dynamic get locality => _locality;
  dynamic get city => _city;
  dynamic get cityId => _cityId;
  dynamic get pincode => _pincode;
  String get isPointsRedeemed => _isPointsRedeemed ?? "";
  dynamic get noOfPointsRedeemed => _noOfPointsRedeemed ?? "";
  dynamic get pointsValue => _pointsValue;
  String get totalEarnPoints => _totalEarnPoints ?? "";
  dynamic get message => _message;
  String get dateCreated => _dateCreated ?? "";
  String get status => _status ?? "";
  String get paymentType => _paymentType ?? "";
  String get membershipDiscount => _membershipDiscount ?? "";
  dynamic get paymentCard => _paymentCard;
  dynamic get paymentGateway => _paymentGateway;
  String get noOfItems => _noOfItems ?? "";
  String get paidDate => _paidDate ?? "";
  String get paidAmount => _paidAmount ?? "";
  dynamic get transactionId => _transactionId;
  String get chargeId => _chargeId ?? "";
  String get payerId => _payerId ?? "";
  dynamic get payerEmail => _payerEmail;
  String get payerName => _payerName ?? "";
  String get paymentStatus => _paymentStatus ?? "";
  String get dateUpdated => _dateUpdated ?? "";
  dynamic get deviceId => _deviceId;
  dynamic get ratingValue => _ratingValue;
  dynamic get isAdminSentToKm => _isAdminSentToKm;
  dynamic get kmId => _kmId;
  dynamic get kmReceivedDatetime => _kmReceivedDatetime;
  dynamic get isAdminSentToDm => _isAdminSentToDm;
  dynamic get isKmSentToDm => _isKmSentToDm;
  dynamic get sentKmId => _sentKmId;
  dynamic get dmId => _dmId;
  dynamic get redeemedGiftCardNo => _redeemedGiftCardNo;
  dynamic get dmReceivedDatetime => _dmReceivedDatetime;
  dynamic get lastUpdatedBy => _lastUpdatedBy;
  dynamic get lastUpdated => _lastUpdated;
  dynamic get deliveredStatus => _deliveredStatus;
  dynamic get deliveredStatusDatetime => _deliveredStatusDatetime;
  dynamic get cancelledStatus => _cancelledStatus;
  dynamic get cancelledStatusDatetime => _cancelledStatusDatetime;
  dynamic get missedStatusDatetime => _missedStatusDatetime;
  dynamic get pickupTime => _pickupTime;
  dynamic get rejectReason => _rejectReason;
  dynamic get rejectedDateTme => _rejectedDateTme;
  dynamic get acceptedDateTme => _acceptedDateTme;
  dynamic get fulfilmentDateTme => _fulfilmentDateTme;
  String get device => _device ?? "";
  String get salesTax => _salesTax ?? "";
  String get isDumplingOrder => _isDumplingOrder ?? "";
  String get isDrinkOrder => _isDrinkOrder ?? "";
  String get isRiceOrder => _isRiceOrder ?? "";
  String get showCancelInDumplingOrder => _showCancelInDumplingOrder ?? "";
  String get showCancelInRiceOrder => _showCancelInRiceOrder ?? "";
  String get showCancelInDrinkOrder => _showCancelInDrinkOrder ?? "";
  String get hybridRedeemGiftAmount => _hybridRedeemGiftAmount ?? "";

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['order_id'] = _orderId;
    map['ref_user_uid'] = _refUserUid;
    map['order_date'] = _orderDate;
    map['order_time'] = _orderTime;
    map['total_cost'] = _totalCost;
    map['delivery_fee'] = _deliveryFee;
    map['customer_name'] = _customerName;
    map['phone'] = _phone;
    map['email'] = _email;
    map['house_no'] = _houseNo;
    map['street'] = _street;
    map['landmark'] = _landmark;
    map['locality'] = _locality;
    map['city'] = _city;
    map['city_id'] = _cityId;
    map['pincode'] = _pincode;
    map['is_points_redeemed'] = _isPointsRedeemed;
    map['no_of_points_redeemed'] = _noOfPointsRedeemed;
    map['points_value'] = _pointsValue;
    map['total_earn_points'] = _totalEarnPoints;
    map['message'] = _message;
    map['date_created'] = _dateCreated;
    map['status'] = _status;
    map['payment_type'] = _paymentType;
    map['membership_discount'] = _membershipDiscount;
    map['payment_card'] = _paymentCard;
    map['payment_gateway'] = _paymentGateway;
    map['no_of_items'] = _noOfItems;
    map['paid_date'] = _paidDate;
    map['paid_amount'] = _paidAmount;
    map['transaction_id'] = _transactionId;
    map['charge_id'] = _chargeId;
    map['payer_id'] = _payerId;
    map['payer_email'] = _payerEmail;
    map['payer_name'] = _payerName;
    map['payment_status'] = _paymentStatus;
    map['date_updated'] = _dateUpdated;
    map['device_id'] = _deviceId;
    map['rating_value'] = _ratingValue;
    map['is_admin_sent_to_km'] = _isAdminSentToKm;
    map['km_id'] = _kmId;
    map['km_received_datetime'] = _kmReceivedDatetime;
    map['is_admin_sent_to_dm'] = _isAdminSentToDm;
    map['is_km_sent_to_dm'] = _isKmSentToDm;
    map['sent_km_id'] = _sentKmId;
    map['dm_id'] = _dmId;
    map['redeemed_gift_card_no'] = _redeemedGiftCardNo;
    map['dm_received_datetime'] = _dmReceivedDatetime;
    map['last_updated_by'] = _lastUpdatedBy;
    map['last_updated'] = _lastUpdated;
    map['delivered_status'] = _deliveredStatus;
    map['delivered_status_datetime'] = _deliveredStatusDatetime;
    map['cancelled_status'] = _cancelledStatus;
    map['cancelled_status_datetime'] = _cancelledStatusDatetime;
    map['missed_status_datetime'] = _missedStatusDatetime;
    map['pickup_time'] = _pickupTime;
    map['reject_reason'] = _rejectReason;
    map['rejected_date_tme'] = _rejectedDateTme;
    map['accepted_date_tme'] = _acceptedDateTme;
    map['fulfilment_date_tme'] = _fulfilmentDateTme;
    map['device'] = _device;
    map['sales_tax'] = _salesTax;
    map['is_dumpling_order'] = _isDumplingOrder;
    map['is_drink_order'] = _isDrinkOrder;
    map['is_rice_order'] = _isRiceOrder;
    map['show_cancel_in_dumpling_order'] = _showCancelInDumplingOrder;
    map['show_cancel_in_rice_order'] = _showCancelInRiceOrder;
    map['show_cancel_in_drink_order'] = _showCancelInDrinkOrder;
    map['hybrid_redeem_gift_amount'] = _hybridRedeemGiftAmount;
    return map;
  }
}

/// order_id : "3627"
/// ref_user_uid : null
/// order_date : "2023-09-06"
/// order_time : "21:48 PM"
/// total_cost : "11.98"
/// delivery_fee : "0.00"
/// customer_name : "Afnan A Ahmed"
/// phone : "12348765149"
/// email : "acba2672@gmail.com"
/// house_no : null
/// street : null
/// landmark : null
/// locality : null
/// city : null
/// city_id : null
/// pincode : null
/// is_points_redeemed : "No"
/// no_of_points_redeemed : null
/// points_value : null
/// total_earn_points : "6.00"
/// message : null
/// date_created : "2023-09-06 21:48:43"
/// status : "missed"
/// payment_type : "stripe"
/// membership_discount : "0.00"
/// payment_card : null
/// payment_gateway : null
/// no_of_items : "2"
/// paid_date : "06-09-2023"
/// paid_amount : "11.98"
/// transaction_id : null
/// charge_id : "pi_3NnXKpGL2F2z9nv10S2r5sYO"
/// payer_id : "102"
/// payer_email : null
/// payer_name : " "
/// payment_status : "paid"
/// date_updated : "2023-09-06"
/// device_id : null
/// rating_value : null
/// is_admin_sent_to_km : null
/// km_id : null
/// km_received_datetime : null
/// is_admin_sent_to_dm : null
/// is_km_sent_to_dm : null
/// sent_km_id : null
/// dm_id : null
/// redeemed_gift_card_no : null
/// dm_received_datetime : null
/// last_updated_by : null
/// last_updated : null
/// delivered_status : null
/// delivered_status_datetime : null
/// cancelled_status : null
/// cancelled_status_datetime : null
/// missed_status_datetime : null
/// pickup_time : null
/// reject_reason : null
/// rejected_date_tme : null
/// accepted_date_tme : null
/// fulfilment_date_tme : null
/// device : "Windows 10"
/// sales_tax : "0.98"
/// is_dumpling_order : "no"
/// is_drink_order : "yes"
/// is_rice_order : "no"
/// show_cancel_in_dumpling_order : "yes"
/// show_cancel_in_rice_order : "yes"
/// show_cancel_in_drink_order : "yes"
/// hybrid_redeem_gift_amount : "0"
