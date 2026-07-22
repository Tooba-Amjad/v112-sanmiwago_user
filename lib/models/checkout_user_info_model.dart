// To parse this JSON data, do
//
//     final userInfoForCheckout = userInfoForCheckoutFromJson(jsonString);

import 'dart:convert';

CheckoutUserInfo checkoutUserInfoFromJson(String str) => CheckoutUserInfo.fromJson(json.decode(str));

String checkoutUserInfoToJson(CheckoutUserInfo data) => json.encode(data.toJson());

class CheckoutUserInfo {
  final String status;
  final String address;
  final String completeAddress;
  final String building;
  final String house;
  final String neighborhood;
  final String city;
  final String state;
  final String zipcode;
  final String latitudeCustomer;
  final String longitudeCustomer;
  final String phoneNumber;
  final String name;
  final String email;

  CheckoutUserInfo({
    this.status = "",
    this.address = "",
    this.completeAddress = "",
    this.building = "",
    this.house = "",
    this.neighborhood = "",
    this.city = "",
    this.state = "",
    this.zipcode = "",
    this.latitudeCustomer = "",
    this.longitudeCustomer = "",
    this.phoneNumber = "",
    this.name = "",
    this.email = "",
  });

  CheckoutUserInfo copyWith({
    String? status,
    String? address,
    String? completeAddress,
    String? building,
    String? house,
    String? neighborhood,
    String? city,
    String? state,
    String? zipcode,
    String? latitudeCustomer,
    String? longitudeCustomer,
    String? phoneNumber,
    String? name,
    String? email,
  }) =>
      CheckoutUserInfo(
        status: status ?? this.status,
        address: address ?? this.address,
        completeAddress: completeAddress ?? this.completeAddress,
        building: building ?? this.building,
        house: house ?? this.house,
        neighborhood: neighborhood ?? this.neighborhood,
        city: city ?? this.city,
        state: state ?? this.state,
        zipcode: zipcode ?? this.zipcode,
        latitudeCustomer: latitudeCustomer ?? this.latitudeCustomer,
        longitudeCustomer: longitudeCustomer ?? this.longitudeCustomer,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        name: name ?? this.name,
        email: email ?? this.email,
      );

  factory CheckoutUserInfo.fromJson(Map<String, dynamic> json) => CheckoutUserInfo(
    status: json["status"] ?? "",
    address: json["address"] ?? "",
    completeAddress: json["complete_address"] ?? "",
    building: json["building"] ?? "",
    house: json["house_no"] ?? "",
    neighborhood: json["landmark"] ?? "",
    city: json["city"] ?? "",
    state: json["state"] ?? "",
    zipcode: json["zipcode"] ?? "",
    latitudeCustomer: (json["latitude_customer"] ?? "").toString(),
    longitudeCustomer: (json["longitude_customer"] ?? "").toString(),
    phoneNumber: json["phone_number"] ?? "",
    name: json["name"] ?? "",
    email: json["email"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "address": address,
    "complete_address": completeAddress,
    "building": building,
    "house": house,
    "neighborhood": neighborhood,
    "city": city,
    "state": state,
    "zipcode": zipcode,
    "latitude_customer": latitudeCustomer,
    "longitude_customer": longitudeCustomer,
    "phone_number": phoneNumber,
    "name": name,
    "email": email,
  };
}
