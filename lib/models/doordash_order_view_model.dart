// To parse this JSON data, do
//
//     final doorDashOrderViewModel = doorDashOrderViewModelFromJson(jsonString);

import 'dart:convert';

DoorDashOrderViewModel doorDashOrderViewModelFromJson(String str) => DoorDashOrderViewModel.fromJson(json.decode(str));

String doorDashOrderViewModelToJson(DoorDashOrderViewModel data) => json.encode(data.toJson());

class DoorDashOrderViewModel {
  final String? status;
  final dynamic eventName;
  final dynamic orderStatus;
  final dynamic deliveryPlateform;
  final String? doordashStatus;
  final String? message;
  final DoordashRecords? doordashRecords;

  DoorDashOrderViewModel({
    this.status,
    this.eventName,
    this.orderStatus,
    this.deliveryPlateform,
    this.doordashStatus,
    this.message,
    this.doordashRecords,
  });

  DoorDashOrderViewModel copyWith({
    String? status,
    dynamic eventName,
    dynamic orderStatus,
    dynamic deliveryPlateform,
    String? doordashStatus,
    String? message,
    DoordashRecords? doordashRecords,
  }) =>
      DoorDashOrderViewModel(
        status: status ?? this.status,
        eventName: eventName ?? this.eventName,
        orderStatus: orderStatus ?? this.orderStatus,
        deliveryPlateform: deliveryPlateform ?? this.deliveryPlateform,
        doordashStatus: doordashStatus ?? this.doordashStatus,
        message: message ?? this.message,
        doordashRecords: doordashRecords ?? this.doordashRecords,
      );

  factory DoorDashOrderViewModel.fromJson(Map<String, dynamic> json) => DoorDashOrderViewModel(
        status: json["status"],
        eventName: json["event_name"],
        orderStatus: json["order_status"],
        deliveryPlateform: json["delivery_plateform"],
        doordashStatus: json["doordash_status"],
        message: json["message"],
        doordashRecords: json["doordash_records"] == null ? null : DoordashRecords.fromJson(json["doordash_records"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "event_name": eventName,
        "order_status": orderStatus,
        "delivery_plateform": deliveryPlateform,
        "doordash_status": doordashStatus,
        "message": message,
        "doordash_records": doordashRecords?.toJson(),
      };
}

class DoordashRecords {
  final String? id;
  final String? orderId;
  final String? deliveryStatus;
  final String? deliveryFee;
  final DateTime? createdTime;
  final DateTime? updatedAt;
  final String? trackingUrl;
  final dynamic trackingUrlNew;
  final DateTime? pickupTimeEstimated;
  final dynamic pickupTimeActual;
  final DateTime? dropoffTimeEstimated;
  final dynamic dropoffTimeActual;
  final String? supportReference;
  final String? actionIfUndeliverable;
  final String? contactlessDropoff;
  final String? dropoffCashOnDelivery;
  final dynamic dasherId;
  final dynamic dasherName;
  final dynamic dasherPhoneNumber;
  final dynamic dasherLocationLat;
  final dynamic dasherLocationLng;
  final dynamic dasherVehicleMake;
  final dynamic dasherVehicleModel;
  final dynamic eventName;
  final dynamic dasherDropoffPhoneNumber;
  final dynamic dasherPickupPhoneNumber;
  final dynamic webhookResponse;
  final dynamic returnTimeEstimated;
  final dynamic batchId;
  final dynamic cancellationReason;

  DoordashRecords({
    this.id,
    this.orderId,
    this.deliveryStatus,
    this.deliveryFee,
    this.createdTime,
    this.updatedAt,
    this.trackingUrl,
    this.trackingUrlNew,
    this.pickupTimeEstimated,
    this.pickupTimeActual,
    this.dropoffTimeEstimated,
    this.dropoffTimeActual,
    this.supportReference,
    this.actionIfUndeliverable,
    this.contactlessDropoff,
    this.dropoffCashOnDelivery,
    this.dasherId,
    this.dasherName,
    this.dasherPhoneNumber,
    this.dasherLocationLat,
    this.dasherLocationLng,
    this.dasherVehicleMake,
    this.dasherVehicleModel,
    this.eventName,
    this.dasherDropoffPhoneNumber,
    this.dasherPickupPhoneNumber,
    this.webhookResponse,
    this.returnTimeEstimated,
    this.batchId,
    this.cancellationReason,
  });

  DoordashRecords copyWith({
    String? id,
    String? orderId,
    String? deliveryStatus,
    String? deliveryFee,
    DateTime? createdTime,
    DateTime? updatedAt,
    String? trackingUrl,
    dynamic trackingUrlNew,
    DateTime? pickupTimeEstimated,
    dynamic pickupTimeActual,
    DateTime? dropoffTimeEstimated,
    dynamic dropoffTimeActual,
    String? supportReference,
    String? actionIfUndeliverable,
    String? contactlessDropoff,
    String? dropoffCashOnDelivery,
    dynamic dasherId,
    dynamic dasherName,
    dynamic dasherPhoneNumber,
    dynamic dasherLocationLat,
    dynamic dasherLocationLng,
    dynamic dasherVehicleMake,
    dynamic dasherVehicleModel,
    dynamic eventName,
    dynamic dasherDropoffPhoneNumber,
    dynamic dasherPickupPhoneNumber,
    dynamic webhookResponse,
    dynamic returnTimeEstimated,
    dynamic batchId,
    dynamic cancellationReason,
  }) =>
      DoordashRecords(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        deliveryStatus: deliveryStatus ?? this.deliveryStatus,
        deliveryFee: deliveryFee ?? this.deliveryFee,
        createdTime: createdTime ?? this.createdTime,
        updatedAt: updatedAt ?? this.updatedAt,
        trackingUrl: trackingUrl ?? this.trackingUrl,
        trackingUrlNew: trackingUrlNew ?? this.trackingUrlNew,
        pickupTimeEstimated: pickupTimeEstimated ?? this.pickupTimeEstimated,
        pickupTimeActual: pickupTimeActual ?? this.pickupTimeActual,
        dropoffTimeEstimated: dropoffTimeEstimated ?? this.dropoffTimeEstimated,
        dropoffTimeActual: dropoffTimeActual ?? this.dropoffTimeActual,
        supportReference: supportReference ?? this.supportReference,
        actionIfUndeliverable: actionIfUndeliverable ?? this.actionIfUndeliverable,
        contactlessDropoff: contactlessDropoff ?? this.contactlessDropoff,
        dropoffCashOnDelivery: dropoffCashOnDelivery ?? this.dropoffCashOnDelivery,
        dasherId: dasherId ?? this.dasherId,
        dasherName: dasherName ?? this.dasherName,
        dasherPhoneNumber: dasherPhoneNumber ?? this.dasherPhoneNumber,
        dasherLocationLat: dasherLocationLat ?? this.dasherLocationLat,
        dasherLocationLng: dasherLocationLng ?? this.dasherLocationLng,
        dasherVehicleMake: dasherVehicleMake ?? this.dasherVehicleMake,
        dasherVehicleModel: dasherVehicleModel ?? this.dasherVehicleModel,
        eventName: eventName ?? this.eventName,
        dasherDropoffPhoneNumber: dasherDropoffPhoneNumber ?? this.dasherDropoffPhoneNumber,
        dasherPickupPhoneNumber: dasherPickupPhoneNumber ?? this.dasherPickupPhoneNumber,
        webhookResponse: webhookResponse ?? this.webhookResponse,
        returnTimeEstimated: returnTimeEstimated ?? this.returnTimeEstimated,
        batchId: batchId ?? this.batchId,
        cancellationReason: cancellationReason ?? this.cancellationReason,
      );

  factory DoordashRecords.fromJson(Map<String, dynamic> json) => DoordashRecords(
        id: json["id"],
        orderId: json["order_id"],
        deliveryStatus: json["delivery_status"],
        deliveryFee: json["delivery_fee"],
        createdTime: json["created_time"] == null ? null : DateTime.parse(json["created_time"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        trackingUrl: json["tracking_url"],
        trackingUrlNew: json["tracking_url_new"],
        pickupTimeEstimated: json["pickup_time_estimated"] == null ? null : DateTime.parse(json["pickup_time_estimated"]),
        pickupTimeActual: json["pickup_time_actual"],
        dropoffTimeEstimated: json["dropoff_time_estimated"] == null ? null : DateTime.parse(json["dropoff_time_estimated"]),
        dropoffTimeActual: json["dropoff_time_actual"],
        supportReference: json["support_reference"],
        actionIfUndeliverable: json["action_if_undeliverable"],
        contactlessDropoff: json["contactless_dropoff"],
        dropoffCashOnDelivery: json["dropoff_cash_on_delivery"],
        dasherId: json["dasher_id"],
        dasherName: json["dasher_name"],
        dasherPhoneNumber: json["dasher_phone_number"],
        dasherLocationLat: json["dasher_location_lat"],
        dasherLocationLng: json["dasher_location_lng"],
        dasherVehicleMake: json["dasher_vehicle_make"],
        dasherVehicleModel: json["dasher_vehicle_model"],
        eventName: json["event_name"],
        dasherDropoffPhoneNumber: json["dasher_dropoff_phone_number"],
        dasherPickupPhoneNumber: json["dasher_pickup_phone_number"],
        webhookResponse: json["webhook_response"],
        returnTimeEstimated: json["return_time_estimated"],
        batchId: json["batch_id"],
        cancellationReason: json["cancellation_reason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "delivery_status": deliveryStatus,
        "delivery_fee": deliveryFee,
        "created_time": createdTime?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "tracking_url": trackingUrl,
        "tracking_url_new": trackingUrlNew,
        "pickup_time_estimated": pickupTimeEstimated?.toIso8601String(),
        "pickup_time_actual": pickupTimeActual,
        "dropoff_time_estimated": dropoffTimeEstimated?.toIso8601String(),
        "dropoff_time_actual": dropoffTimeActual,
        "support_reference": supportReference,
        "action_if_undeliverable": actionIfUndeliverable,
        "contactless_dropoff": contactlessDropoff,
        "dropoff_cash_on_delivery": dropoffCashOnDelivery,
        "dasher_id": dasherId,
        "dasher_name": dasherName,
        "dasher_phone_number": dasherPhoneNumber,
        "dasher_location_lat": dasherLocationLat,
        "dasher_location_lng": dasherLocationLng,
        "dasher_vehicle_make": dasherVehicleMake,
        "dasher_vehicle_model": dasherVehicleModel,
        "event_name": eventName,
        "dasher_dropoff_phone_number": dasherDropoffPhoneNumber,
        "dasher_pickup_phone_number": dasherPickupPhoneNumber,
        "webhook_response": webhookResponse,
        "return_time_estimated": returnTimeEstimated,
        "batch_id": batchId,
        "cancellation_reason": cancellationReason,
      };
}
