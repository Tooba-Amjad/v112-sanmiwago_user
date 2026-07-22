import 'dart:convert';

OrderViewModel orderViewModelFromJson(String str) => OrderViewModel.fromJson(json.decode(str));

String orderViewModelToJson(OrderViewModel data) => json.encode(data.toJson());

class OrderViewModel {
  OrderViewModel({
    required this.order,
    this.orderItems = const [],
    this.isFirstOrder = "No",
    this.addons = const [],
    this.offers = const [],
    this.refundHistory = const [],
    this.restaurantInfo = const [],
  });

  Order order;
  List<OrderItem> orderItems;
  String isFirstOrder;
  List<OrderAddon> addons;
  List<dynamic> offers;
  List<RefundHistory> refundHistory;
  List<RestaurantInfo> restaurantInfo;

  factory OrderViewModel.fromJson(Map<String, dynamic> json) => OrderViewModel(
        order: Order.fromJson(json["order"]),
        isFirstOrder: json.containsKey("is_first_order") ? json["is_first_order"] : "No",
        orderItems: List<OrderItem>.from(json["order_items"].map((x) => OrderItem.fromJson(x))),
        addons: List<OrderAddon>.from(json["addons"].map((x) => OrderAddon.fromJson(x))),
        offers: List<dynamic>.from(json["offers"].map((x) => x)),
        refundHistory: List<RefundHistory>.from(json["refund_history"].map((x) => RefundHistory.fromJson(x))),
        restaurantInfo: List<RestaurantInfo>.from(json["restaurant_info"].map((x) => RestaurantInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "order": order.toJson(),
        "is_first_order": isFirstOrder,
        "order_items": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "addons": List<dynamic>.from(addons.map((x) => x)),
        "offers": List<dynamic>.from(offers.map((x) => x)),
        "refund_history": List<dynamic>.from(refundHistory.map((x) => x.toJson())),
        "restaurant_info": List<dynamic>.from(restaurantInfo.map((x) => x.toJson())),
      };
}

class Order {
  Order({
    this.orderId = "",
    this.invoiceNumber = "",
    this.userId = "",
    this.refUserUid = "",
    this.orderDate = "",
    this.orderTime = "",
    this.totalCost = "",
    this.stripeCardNo = "",
    this.salesTax = "",
    this.refundTax = "",
    this.refundStaffTip = "",
    this.refundDriverTip = "",
    this.refundType = "",
    this.refundAmount = "",
    this.discountAmount = "",
    this.refundPoints = "",
    this.refundItemIds = "",
    this.realCost = "",
    this.realStaffTip = "",
    this.realSubtotal = "",
    this.realSaleTax = "",
    this.couponPercentage = "",
    this.couponDiscount = "",
    this.discount = "",
    this.deliveryFee = "",
    this.doordashDeliveryFee = "",
    this.customerName = "",
    this.phone = "",
    this.email = "",
    this.houseNo = "",
    this.street = "",
    this.landmark = "",
    this.locality = "",
    this.city = "",
    this.cityId = "",
    this.state = "",
    this.zipcode = "",
    this.pincode = "",
    this.isPointsRedeemed = "",
    this.noOfPointsRedeemed = "",
    this.pointsValue = "",
    this.totalEarnPoints = "",
    this.message = "",
    this.dateCreated = "",
    this.refundDateTime = "",
    this.status = "",
    this.paymentType = "",
    this.planType = "",
    this.orderType = "",
    this.paymentCard = "",
    this.paymentGateway = "",
    this.noOfItems = "",
    this.paidDate = "",
    this.paidAmount = "0.0",
    this.transactionId = "",
    this.chargeId = "",
    this.payerId = "",
    this.payerEmail = "",
    this.payerName = "",
    this.paymentStatus = "",
    this.dateUpdated = "",
    this.deviceId = "",
    this.ratingValue = "",
    this.isAdminSentToKm = "",
    this.kmId = "",
    this.kmReceivedDatetime = "",
    this.isAdminSentToDm = "",
    this.isKmSentToDm = "",
    this.sentKmId = "",
    this.dmId = "",
    this.latitudeCustomer = "",
    this.longitudeCustomer = "",
    this.latitudeResturant = "",
    this.longitudeResturant = "",
    this.redeemedGiftCardNo = "",
    this.dmReceivedDatetime = "",
    this.lastUpdatedBy = "",
    this.lastUpdated = "",
    this.deliveredStatus = "",
    this.deliveredStatusDatetime = "",
    this.cancelledStatus = "",
    this.cancelledStatusDatetime = "",
    this.missedStatusDatetime = "",
    this.pickupTime = "",
    this.rejectReason = "",
    this.rejectedDateTme = "",
    this.acceptedDateTme = "",
    this.fulfilmentDateTme = "",
    this.kitchenManager = "",
    this.sentKmUser = "",
    this.deliveryManager = "",
    this.hybridRedeemGiftAmount = "",
    this.staffTip = "",
    this.driverTip = "",
    this.doordashDriverTip = "",
    this.deliveryNote = "",
  });

  String orderId;
  String invoiceNumber;
  String userId;
  dynamic refUserUid;
  String orderDate;
  String orderTime;
  String totalCost;
  String stripeCardNo;
  String salesTax;
  String refundTax;
  String refundStaffTip;
  String refundDriverTip;
  String refundType;
  String refundAmount;
  String discountAmount;
  String refundPoints;
  String refundItemIds;
  String realCost;
  String realStaffTip;
  String realSubtotal;
  String realSaleTax;

  String couponPercentage;
  String couponDiscount;
  String discount;
  String deliveryFee;
  String doordashDeliveryFee;
  String customerName;
  String phone;
  String email;
  String houseNo;
  String street;
  String landmark;
  String locality;
  String city;
  dynamic cityId;
  String state;
  String zipcode;
  dynamic pincode;
  String isPointsRedeemed;
  dynamic noOfPointsRedeemed;
  dynamic pointsValue;
  String totalEarnPoints;
  dynamic message;
  String dateCreated;
  String refundDateTime;
  String status;
  String paymentType;
  String planType;
  String orderType;
  dynamic paymentCard;
  dynamic paymentGateway;
  String noOfItems;
  dynamic paidDate;
  dynamic paidAmount;
  dynamic transactionId;
  dynamic chargeId;
  dynamic payerId;
  dynamic payerEmail;
  dynamic payerName;
  dynamic paymentStatus;
  String dateUpdated;
  String hybridRedeemGiftAmount;
  dynamic deviceId;
  dynamic ratingValue;
  dynamic isAdminSentToKm;
  dynamic kmId;
  dynamic kmReceivedDatetime;
  dynamic isAdminSentToDm;
  dynamic isKmSentToDm;
  dynamic sentKmId;
  String dmId;
  String latitudeCustomer;
  String longitudeCustomer;
  String latitudeResturant;
  String longitudeResturant;

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
  dynamic kitchenManager;
  dynamic sentKmUser;
  dynamic deliveryManager;
  String staffTip;
  String driverTip;
  String doordashDriverTip;
  String deliveryNote;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["order_id"] ?? "",
        invoiceNumber: json["invoice_number"] ?? "",
        userId: json["user_id"] ?? "",
        refUserUid: json["ref_user_uid"] ?? "",
        orderDate: json["order_date"] ?? "",
        orderTime: json["order_time"] ?? "",
        totalCost: json["total_cost"] ?? "",
        stripeCardNo: json["strip_card_no"] ?? "",
        salesTax: json["sales_tax"] ?? "",
        refundTax: json["refund_tax"] ?? "",
        refundStaffTip: json["refund_staff_tip"] ?? "",
        refundDriverTip: json["refund_doordash_driver_tip"] ?? "",
        refundType: json["refund_type"] ?? "",
        refundAmount: json["refund_amount"] ?? "",
        discountAmount: json["discount_amount"] ?? "",
        refundPoints: json["refund_points"] ?? "",
        refundItemIds: json["refund_item_ids"] ?? "",
        realCost: json["real_cost"] ?? "",
        realStaffTip: json["real_staff_tip"] ?? "",
        realSubtotal: json["real_subtotal"] ?? "",
        realSaleTax: json["real_saletax"] ?? "",
        couponPercentage: json["coupon_percentage"] ?? "",
        couponDiscount: json["coupon_discount"] ?? "",
        discount: json["membership_discount"] ?? "",
        deliveryFee: json["delivery_fee"] ?? "",
        doordashDeliveryFee: json["doordash_delivery_fee"] ?? "",
        customerName: json["customer_name"] ?? "",
        phone: json["phone"] ?? "",
        email: json["email"] ?? "",
        houseNo: json["house_no"] ?? "",
        street: json["address"] ?? "",
        landmark: json["landmark"] ?? "",
        locality: json["locality"] ?? "",
        city: json["city"] ?? "",
        cityId: json["city_id"] ?? "",
        state: json["state"] ?? "",
        zipcode: json["zipcode"] ?? "",
        pincode: json["pincode"] ?? "",
        isPointsRedeemed: json["is_points_redeemed"] ?? "",
        noOfPointsRedeemed: json["no_of_points_redeemed"] ?? "",
        pointsValue: json["points_value"] ?? "",
        totalEarnPoints: json["total_earn_points"] ?? "",
        message: json["message"] ?? "",
        dateCreated: json["date_created"] ?? "",
        refundDateTime: json["refund_date_time"] ?? "",
        status: json["status"] ?? "",
        paymentType: json["payment_type"] ?? "",
        planType: json["plan_type"] ?? "",
        orderType: json["order_type"] ?? "",
        paymentCard: json["payment_card"] ?? "",
        paymentGateway: json["payment_gateway"] ?? "",
        noOfItems: json["no_of_items"] ?? "",
        paidDate: json["paid_date"] ?? "",
        paidAmount: json["paid_amount"] ?? "0.0",
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
        latitudeCustomer: json["latitude_customer"] ?? "0.0",
        longitudeCustomer: json["longitude_customer"] ?? "0.0",
        latitudeResturant: json["latitude_resturant"] ?? "0.0",
        longitudeResturant: json["longitude_resturant"] ?? "0.0",
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
        kitchenManager: json["kitchen_manager"] ?? "",
        sentKmUser: json["sent_km_user"] ?? "",
        deliveryManager: json["delivery_manager"] ?? "",
        staffTip: json["staff_tip"] ?? "",
        driverTip: json["driver_tip"] ?? "",
        doordashDriverTip: json["doordash_driver_tip"] ?? "",
        deliveryNote: json["delivery_note"] ?? "",
        hybridRedeemGiftAmount: json.containsKey("hybrid_redeem_gift_amount") ? json["hybrid_redeem_gift_amount"] ?? "" : "",
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "invoice_number": invoiceNumber,
        "user_id": userId,
        "ref_user_uid": refUserUid,
        "order_date": orderDate,
        "order_time": orderTime,
        "total_cost": totalCost,
        "strip_card_no": stripeCardNo,
        "sales_tax": salesTax,
        "refund_tax": refundTax,
        "refund_staff_tip": refundStaffTip,
        "refund_doordash_driver_tip": refundDriverTip,
        "refund_type": refundType,
        "refund_amount": refundAmount,
        "refund_points": refundPoints,
        "refund_item_ids": refundItemIds,
        "real_cost": realCost,
        "real_staff_tip": realStaffTip,
        "real_subtotal": realSubtotal,
        "real_saletax": realSaleTax,
        "coupon_percentage": couponPercentage,
        "coupon_discount": couponDiscount,
        "membership_discount": discount,
        "delivery_fee": deliveryFee,
        "doordash_delivery_fee": doordashDeliveryFee,
        "customer_name": customerName,
        "phone": phone,
        "email": email,
        "house_no": houseNo,
        "street": street,
        "landmark": landmark,
        "locality": locality,
        "city": city,
        "city_id": cityId,
        "state": state,
        "zipcode": zipcode,
        "pincode": pincode,
        "is_points_redeemed": isPointsRedeemed,
        "no_of_points_redeemed": noOfPointsRedeemed,
        "points_value": pointsValue,
        "total_earn_points": totalEarnPoints,
        "message": message,
        "date_created": dateCreated,
        "refund_date_time": refundDateTime,
        "status": status,
        "payment_type": paymentType,
        "plan_type": planType,
        "order_type": orderType,
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
        "latitude_customer": latitudeCustomer,
        "longitude_customer": longitudeCustomer,
        "latitude_resturant": latitudeResturant,
        "longitude_resturant": longitudeResturant,
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
        "kitchen_manager": kitchenManager,
        "sent_km_user": sentKmUser,
        "delivery_manager": deliveryManager,
        "hybrid_redeem_gift_amount": hybridRedeemGiftAmount,
        "staff_tip": staffTip,
        "driver_tip": driverTip,
        "doordash_driver_tip": doordashDriverTip,
        "delivery_note": deliveryNote,
      };
}

class OrderItem {
  OrderItem({
    this.opId = "",
    this.isDeleted = "",
    this.orderId = "",
    this.itemId = "",
    this.menuId = "",
    this.itemName = "",
    this.itemImageName = "",
    this.sizeId = "",
    this.sizeName = "",
    this.itemSizeId = "",
    this.sizePrice = "",
    this.finalCost = "",
    this.itemQty = "",
    this.itemCost = "",
    this.commonId = "",
    this.specialInstruction = "",
  });

  String opId;
  String isDeleted;
  String orderId;
  String itemId;
  String menuId;
  String itemName;
  String itemImageName;
  String sizeId;
  String sizeName;
  String itemSizeId;
  String sizePrice;
  String finalCost;
  String itemQty;
  String itemCost;
  String commonId;
  String specialInstruction;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        opId: json["op_id"] ?? "",
        isDeleted: json["is_deleted"] ?? "",
        orderId: json["order_id"] ?? "",
        itemId: json["item_id"] ?? "",
        menuId: json["menu_id"] ?? "",
        itemName: json["item_name"] ?? "",
        itemImageName: json["item_image_name"] ?? "",
        sizeId: json["size_id"] ?? "",
        sizeName: json["size_name"] ?? "",
        itemSizeId: json["item_size_id"] ?? "",
        sizePrice: json["size_price"] ?? "",
        finalCost: json["final_cost"] ?? "",
        itemQty: json["item_qty"] ?? "",
        itemCost: json["item_cost"] ?? "",
        commonId: json["common_id"] ?? "",
        specialInstruction: json["special_instruction"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "op_id": opId,
        "is_deleted": isDeleted,
        "order_id": orderId,
        "item_id": itemId,
        "menu_id": menuId,
        "item_name": itemName,
        "item_image_name": itemImageName,
        "size_id": sizeId,
        "size_name": sizeName,
        "item_size_id": itemSizeId,
        "size_price": sizePrice,
        "final_cost": finalCost,
        "item_qty": itemQty,
        "item_cost": itemCost,
        "common_id": commonId,
        "special_instruction": specialInstruction,
      };
}

class OrderAddon {
  String oaId;
  String opId;
  String orderId;
  String itemId;
  String addonName;
  String addonImage;
  String price;
  String quantity;
  String finalCost;
  String commonId;
  String isDeleted;

  OrderAddon({
    this.oaId = "",
    this.opId = "",
    this.orderId = "",
    this.itemId = "",
    this.addonName = "",
    this.addonImage = "",
    this.price = "",
    this.quantity = "",
    this.finalCost = "",
    this.commonId = "",
    this.isDeleted = "",
  });

  OrderAddon copyWith({
    String? oaId,
    String? opId,
    String? orderId,
    String? itemId,
    String? addonName,
    String? addonImage,
    String? price,
    String? quantity,
    String? finalCost,
    String? commonId,
    String? isDeleted,
  }) =>
      OrderAddon(
        oaId: oaId ?? this.oaId,
        opId: opId ?? this.opId,
        orderId: orderId ?? this.orderId,
        itemId: itemId ?? this.itemId,
        addonName: addonName ?? this.addonName,
        addonImage: addonImage ?? this.addonImage,
        price: price ?? this.price,
        quantity: quantity ?? this.quantity,
        finalCost: finalCost ?? this.finalCost,
        commonId: commonId ?? this.commonId,
        isDeleted: isDeleted ?? this.isDeleted,
      );

  factory OrderAddon.fromJson(Map<String, dynamic> json) => OrderAddon(
        oaId: json["oa_id"],
        opId: json.containsKey("op_id") ? json["op_id"] : "",
        orderId: json["order_id"],
        itemId: json["item_id"],
        addonName: json["addon_name"],
        addonImage: json["addon_image"],
        price: json["price"],
        quantity: json["quantity"] ?? "1",
        finalCost: json["final_cost"],
        commonId: json["common_id"],
        isDeleted: json["is_deleted"],
      );

  Map<String, dynamic> toJson() => {
        "oa_id": oaId,
        "op_id": opId,
        "order_id": orderId,
        "item_id": itemId,
        "addon_name": addonName,
        "addon_image": addonImage,
        "price": price,
        "quantity": quantity,
        "final_cost": finalCost,
        "common_id": commonId,
        "is_deleted": isDeleted,
      };
}

class RefundHistory {
  String id;
  String orderId;
  String type;
  String amount;
  JsonData? jsonData;
  String refundDate;

  RefundHistory({
    required this.id,
    required this.orderId,
    required this.type,
    required this.amount,
    this.jsonData,
    required this.refundDate,
  });

  RefundHistory copyWith({
    String? id,
    String? orderId,
    String? type,
    String? amount,
    JsonData? jsonData,
    String? refundDate,
  }) =>
      RefundHistory(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        jsonData: jsonData ?? this.jsonData,
        refundDate: refundDate ?? this.refundDate,
      );

  factory RefundHistory.fromJson(Map<String, dynamic> json) => RefundHistory(
        id: json["id"] ?? "",
        orderId: json["order_id"] ?? "",
        type: json["type"] ?? "",
        amount: json["amount"] ?? "",
        jsonData: json["json_data"] != null ? JsonData.fromJson(jsonDecode(json["json_data"])) : null,
        refundDate: json["refund_date"] ?? "",
      );

  Map<String, dynamic> toJson() => {"id": id, "order_id": orderId, "type": type, "amount": amount, "json_data": jsonData?.toJson(), "refund_date": refundDate};
}

class JsonData {
  String orderId;
  String refundType;
  String refundAmount;
  String refundSelectedItems;
  String paymentType;
  String refundItemIds;
  String refundTax;
  String refundStaffTip;
  String refundPoints;
  String refundTab;
  String refundSource;

  JsonData({
    required this.orderId,
    required this.refundType,
    required this.refundAmount,
    required this.refundSelectedItems,
    required this.paymentType,
    required this.refundItemIds,
    required this.refundTax,
    required this.refundStaffTip,
    required this.refundPoints,
    required this.refundTab,
    required this.refundSource,
  });

  JsonData copyWith({
    String? orderId,
    String? refundType,
    String? refundAmount,
    String? refundSelectedItems,
    String? paymentType,
    String? refundItemIds,
    String? refundTax,
    String? refundStaffTip,
    String? refundPoints,
    String? refundTab,
    String? refundSource,
  }) =>
      JsonData(
        orderId: orderId ?? this.orderId,
        refundType: refundType ?? this.refundType,
        refundAmount: refundAmount ?? this.refundAmount,
        refundSelectedItems: refundSelectedItems ?? this.refundSelectedItems,
        paymentType: paymentType ?? this.paymentType,
        refundItemIds: refundItemIds ?? this.refundItemIds,
        refundTax: refundTax ?? this.refundTax,
        refundStaffTip: refundStaffTip ?? this.refundStaffTip,
        refundPoints: refundPoints ?? this.refundPoints,
        refundTab: refundTab ?? this.refundTab,
        refundSource: refundSource ?? this.refundSource,
      );

  factory JsonData.fromJson(Map<String, dynamic> json) => JsonData(
        orderId: json["order_id"] ?? "",
        refundType: json["refund_type"] ?? "",
        refundAmount: json["refund_amount"] ?? "",
        refundSelectedItems: json["refund_selected_items"] ?? "",
        paymentType: json["payment_type"] ?? "",
        refundItemIds: json["refund_item_ids"] ?? "",
        refundTax: json["refund_tax"].toString() ?? "",
        refundStaffTip: json["refund_staff_tip"].toString() ?? "",
        refundPoints: json["refund_points"].toString() ?? "",
        refundTab: json["refund_tab"] ?? "",
        refundSource: json["refund_source"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "order_id": orderId,
        "refund_type": refundType,
        "refund_amount": refundAmount,
        "refund_selected_items": refundSelectedItems,
        "payment_type": paymentType,
        "refund_item_ids": refundItemIds,
        "refund_tax": refundTax,
        "refund_staff_tip": refundStaffTip,
        "refund_points": refundPoints,
        "refund_tab": refundTab,
        "refund_source": refundSource,
      };
}

class RestaurantInfo {
  String id;
  String branchName;
  String address;
  String phone;
  dynamic email;
  dynamic logo;
  String latitude;
  String longitude;
  dynamic footerText;
  String minimumOrder;
  dynamic comission;
  String scheduleOrder;
  dynamic openingTime;
  dynamic closeingTime;
  dynamic vendorId;
  dynamic createdAt;
  dynamic updatedAt;
  String freeDelivery;
  dynamic rating;
  dynamic coverPhoto;
  String delivery;
  dynamic takeAway;
  dynamic foodSection;
  String tax;
  dynamic zoneId;
  dynamic reviewsSection;
  dynamic active;
  dynamic offDay;
  dynamic gst;
  String selfDeliverySystem;
  String posSystem;
  String minimumShippingCharge;
  String deliveryTime;
  String veg;
  String nonVeg;
  dynamic orderCount;
  dynamic totalOrder;
  dynamic perKmShippingCharge;
  dynamic restaurantModel;
  dynamic maximumShippingCharge;
  dynamic slug;
  String orderSubscriptionActive;
  DateTime dateTime;
  String status;
  String breakTime;
  String allowGiftcard;

  RestaurantInfo({
    required this.id,
    required this.branchName,
    required this.address,
    required this.phone,
    required this.email,
    required this.logo,
    required this.latitude,
    required this.longitude,
    required this.footerText,
    required this.minimumOrder,
    required this.comission,
    required this.scheduleOrder,
    required this.openingTime,
    required this.closeingTime,
    required this.vendorId,
    required this.createdAt,
    required this.updatedAt,
    required this.freeDelivery,
    required this.rating,
    required this.coverPhoto,
    required this.delivery,
    required this.takeAway,
    required this.foodSection,
    required this.tax,
    required this.zoneId,
    required this.reviewsSection,
    required this.active,
    required this.offDay,
    required this.gst,
    required this.selfDeliverySystem,
    required this.posSystem,
    required this.minimumShippingCharge,
    required this.deliveryTime,
    required this.veg,
    required this.nonVeg,
    required this.orderCount,
    required this.totalOrder,
    required this.perKmShippingCharge,
    required this.restaurantModel,
    required this.maximumShippingCharge,
    required this.slug,
    required this.orderSubscriptionActive,
    required this.dateTime,
    required this.status,
    required this.breakTime,
    required this.allowGiftcard,
  });

  RestaurantInfo copyWith({
    String? id,
    String? branchName,
    String? address,
    String? phone,
    dynamic email,
    dynamic logo,
    String? latitude,
    String? longitude,
    dynamic footerText,
    String? minimumOrder,
    dynamic comission,
    String? scheduleOrder,
    dynamic openingTime,
    dynamic closeingTime,
    dynamic vendorId,
    dynamic createdAt,
    dynamic updatedAt,
    String? freeDelivery,
    dynamic rating,
    dynamic coverPhoto,
    String? delivery,
    dynamic takeAway,
    dynamic foodSection,
    String? tax,
    dynamic zoneId,
    dynamic reviewsSection,
    dynamic active,
    dynamic offDay,
    dynamic gst,
    String? selfDeliverySystem,
    String? posSystem,
    String? minimumShippingCharge,
    String? deliveryTime,
    String? veg,
    String? nonVeg,
    dynamic orderCount,
    dynamic totalOrder,
    dynamic perKmShippingCharge,
    dynamic restaurantModel,
    dynamic maximumShippingCharge,
    dynamic slug,
    String? orderSubscriptionActive,
    DateTime? dateTime,
    String? status,
    String? breakTime,
    String? allowGiftcard,
  }) =>
      RestaurantInfo(
        id: id ?? this.id,
        branchName: branchName ?? this.branchName,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        logo: logo ?? this.logo,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        footerText: footerText ?? this.footerText,
        minimumOrder: minimumOrder ?? this.minimumOrder,
        comission: comission ?? this.comission,
        scheduleOrder: scheduleOrder ?? this.scheduleOrder,
        openingTime: openingTime ?? this.openingTime,
        closeingTime: closeingTime ?? this.closeingTime,
        vendorId: vendorId ?? this.vendorId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        freeDelivery: freeDelivery ?? this.freeDelivery,
        rating: rating ?? this.rating,
        coverPhoto: coverPhoto ?? this.coverPhoto,
        delivery: delivery ?? this.delivery,
        takeAway: takeAway ?? this.takeAway,
        foodSection: foodSection ?? this.foodSection,
        tax: tax ?? this.tax,
        zoneId: zoneId ?? this.zoneId,
        reviewsSection: reviewsSection ?? this.reviewsSection,
        active: active ?? this.active,
        offDay: offDay ?? this.offDay,
        gst: gst ?? this.gst,
        selfDeliverySystem: selfDeliverySystem ?? this.selfDeliverySystem,
        posSystem: posSystem ?? this.posSystem,
        minimumShippingCharge: minimumShippingCharge ?? this.minimumShippingCharge,
        deliveryTime: deliveryTime ?? this.deliveryTime,
        veg: veg ?? this.veg,
        nonVeg: nonVeg ?? this.nonVeg,
        orderCount: orderCount ?? this.orderCount,
        totalOrder: totalOrder ?? this.totalOrder,
        perKmShippingCharge: perKmShippingCharge ?? this.perKmShippingCharge,
        restaurantModel: restaurantModel ?? this.restaurantModel,
        maximumShippingCharge: maximumShippingCharge ?? this.maximumShippingCharge,
        slug: slug ?? this.slug,
        orderSubscriptionActive: orderSubscriptionActive ?? this.orderSubscriptionActive,
        dateTime: dateTime ?? this.dateTime,
        status: status ?? this.status,
        breakTime: breakTime ?? this.breakTime,
        allowGiftcard: allowGiftcard ?? this.allowGiftcard,
      );

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) => RestaurantInfo(
        id: json["id"],
        branchName: json["branch_name"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
        logo: json["logo"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        footerText: json["footer_text"],
        minimumOrder: json["minimum_order"],
        comission: json["comission"],
        scheduleOrder: json["schedule_order"],
        openingTime: json["opening_time"],
        closeingTime: json["closeing_time"],
        vendorId: json["vendor_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        freeDelivery: json["free_delivery"],
        rating: json["rating"],
        coverPhoto: json["cover_photo"],
        delivery: json["delivery"],
        takeAway: json["take_away"],
        foodSection: json["food_section"],
        tax: json["tax"],
        zoneId: json["zone_id"],
        reviewsSection: json["reviews_section"],
        active: json["active"],
        offDay: json["off_day"],
        gst: json["gst"],
        selfDeliverySystem: json["self_delivery_system"],
        posSystem: json["pos_system"],
        minimumShippingCharge: json["minimum_shipping_charge"],
        deliveryTime: json["delivery_time"],
        veg: json["veg"],
        nonVeg: json["non_veg"],
        orderCount: json["order_count"],
        totalOrder: json["total_order"],
        perKmShippingCharge: json["per_km_shipping_charge"],
        restaurantModel: json["restaurant_model"],
        maximumShippingCharge: json["maximum_shipping_charge"],
        slug: json["slug"],
        orderSubscriptionActive: json["order_subscription_active"],
        dateTime: DateTime.parse(json["date_time"]),
        status: json["status"],
        breakTime: json["break_time"] ?? "",
        allowGiftcard: json["allow_giftcard"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branch_name": branchName,
        "address": address,
        "phone": phone,
        "email": email,
        "logo": logo,
        "latitude": latitude,
        "longitude": longitude,
        "footer_text": footerText,
        "minimum_order": minimumOrder,
        "comission": comission,
        "schedule_order": scheduleOrder,
        "opening_time": openingTime,
        "closeing_time": closeingTime,
        "vendor_id": vendorId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "free_delivery": freeDelivery,
        "rating": rating,
        "cover_photo": coverPhoto,
        "delivery": delivery,
        "take_away": takeAway,
        "food_section": foodSection,
        "tax": tax,
        "zone_id": zoneId,
        "reviews_section": reviewsSection,
        "active": active,
        "off_day": offDay,
        "gst": gst,
        "self_delivery_system": selfDeliverySystem,
        "pos_system": posSystem,
        "minimum_shipping_charge": minimumShippingCharge,
        "delivery_time": deliveryTime,
        "veg": veg,
        "non_veg": nonVeg,
        "order_count": orderCount,
        "total_order": totalOrder,
        "per_km_shipping_charge": perKmShippingCharge,
        "restaurant_model": restaurantModel,
        "maximum_shipping_charge": maximumShippingCharge,
        "slug": slug,
        "order_subscription_active": orderSubscriptionActive,
        "date_time": dateTime.toIso8601String(),
        "status": status,
        "break_time": breakTime,
        "allow_giftcard": allowGiftcard,
      };
}

// class OrderViewModel {
//   Map<String, String?>? order;
//   List<OrderItem>? orderItems;
//   List<dynamic>? addons;
//   List<dynamic>? offers;
//
//   OrderViewModel({
//     this.order,
//     this.orderItems,
//     this.addons,
//     this.offers,
//   });
//
//   factory OrderViewModel.fromJson(Map<String, dynamic> json) => OrderViewModel(
//         order: Map.from(json["order"]!).map((k, v) => MapEntry<String, String?>(k, v)),
//         orderItems: json["order_items"] == null ? [] : List<OrderItem>.from(json["order_items"]!.map((x) => OrderItem.fromJson(x))),
//         addons: json["addons"] == null ? [] : List<dynamic>.from(json["addons"]!.map((x) => x)),
//         offers: json["offers"] == null ? [] : List<dynamic>.from(json["offers"]!.map((x) => x)),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "order": Map.from(order!).map((k, v) => MapEntry<String, dynamic>(k, v)),
//         "order_items": orderItems == null ? [] : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
//         "addons": addons == null ? [] : List<dynamic>.from(addons!.map((x) => x)),
//         "offers": offers == null ? [] : List<dynamic>.from(offers!.map((x) => x)),
//       };
// }
//
// class OrderItem {
//   OrderItem({
//     this.opId,
//     this.isDeleted,
//     this.orderId,
//     this.itemId,
//     this.menuId,
//     this.itemName,
//     this.itemImageName,
//     this.sizeId,
//     this.sizeName,
//     this.itemSizeId,
//     this.sizePrice,
//     this.finalCost,
//     this.itemQty,
//     this.itemCost,
//     this.commonId,
//   });
//
//   String? opId;
//   String? isDeleted;
//   String? orderId;
//   String? itemId;
//   String? menuId;
//   String? itemName;
//   String? itemImageName;
//   String? sizeId;
//   String? sizeName;
//   String? itemSizeId;
//   String? sizePrice;
//   String? finalCost;
//   String? itemQty;
//   String? itemCost;
//   String? commonId;
//
//   factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
//         opId: json["op_id"],
//         isDeleted: json["is_deleted"],
//         orderId: json["order_id"],
//         itemId: json["item_id"],
//         menuId: json["menu_id"],
//         itemName: json["item_name"],
//         itemImageName: json["item_image_name"],
//         sizeId: json["size_id"],
//         sizeName: json["size_name"],
//         itemSizeId: json["item_size_id"],
//         sizePrice: json["size_price"],
//         finalCost: json["final_cost"],
//         itemQty: json["item_qty"],
//         itemCost: json["item_cost"],
//         commonId: json["common_id"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "op_id": opId,
//         "is_deleted": isDeleted,
//         "order_id": orderId,
//         "item_id": itemId,
//         "menu_id": menuId,
//         "item_name": itemName,
//         "item_image_name": itemImageName,
//         "size_id": sizeId,
//         "size_name": sizeName,
//         "item_size_id": itemSizeId,
//         "size_price": sizePrice,
//         "final_cost": finalCost,
//         "item_qty": itemQty,
//         "item_cost": itemCost,
//         "common_id": commonId,
//       };
// }
