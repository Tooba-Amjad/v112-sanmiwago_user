// To parse this JSON data, do
//
//     final addressFromLatLng = addressFromLatLngFromJson(jsonString);

import 'dart:convert';

AddressFromLatLng addressFromLatLngFromJson(String str) => AddressFromLatLng.fromJson(json.decode(str));

String addressFromLatLngToJson(AddressFromLatLng data) => json.encode(data.toJson());

class AddressFromLatLng {
  String placeId;
  String licence;
  String osmType;
  String osmId;
  String lat;
  String lon;
  String displayName;
  Address address;
  List<String> boundingbox;

  AddressFromLatLng({
    this.placeId = "",
    this.licence = "",
    this.osmType = "",
    this.osmId = "",
    this.lat = "",
    this.lon = "",
    this.displayName = "",
    required this.address,
    this.boundingbox = const [],
  });

  AddressFromLatLng copyWith({
    String? placeId,
    String? licence,
    String? osmType,
    String? osmId,
    String? lat,
    String? lon,
    String? displayName,
    Address? address,
    List<String>? boundingbox,
  }) =>
      AddressFromLatLng(
        placeId: placeId ?? this.placeId,
        licence: licence ?? this.licence,
        osmType: osmType ?? this.osmType,
        osmId: osmId ?? this.osmId,
        lat: lat ?? this.lat,
        lon: lon ?? this.lon,
        displayName: displayName ?? this.displayName,
        address: address ?? this.address,
        boundingbox: boundingbox ?? this.boundingbox,
      );

  factory AddressFromLatLng.fromJson(Map<String, dynamic> json) => AddressFromLatLng(
        placeId: json["place_id"].toString() ?? "",
        licence: json["licence"] ?? "",
        osmType: json["osm_type"] ?? "",
        osmId: json["osm_id"].toString() ?? "",
        lat: json["lat"] ?? "",
        lon: json["lon"] ?? "",
        displayName: json["display_name"],
        address: json["address"] != null ? Address.fromJson(json["address"]) : Address(),
        boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmType,
        "osm_id": osmId,
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "address": address.toJson(),
        "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
      };
}

class Address {
  String houseNumber;
  String building;
  String neighbourhood;

  String road;
  String suburb;
  String city;
  String state;
  String postcode;
  String country;
  String countryCode;

  Address({
    this.houseNumber = "",
    this.building = "",
    this.neighbourhood = "",
    this.road = "",
    this.suburb = "",
    this.city = "",
    this.state = "",
    this.postcode = "",
    this.country = "",
    this.countryCode = "",
  });

  Address copyWith({
    String? houseNumber,
    String? building,
    String? neighbourhood,
    String? road,
    String? suburb,
    String? city,
    String? state,
    String? postcode,
    String? country,
    String? countryCode,
  }) =>
      Address(
        houseNumber: houseNumber ?? this.houseNumber,
        building: building ?? this.building,
        neighbourhood: neighbourhood ?? this.neighbourhood,
        road: road ?? this.road,
        suburb: suburb ?? this.suburb,
        city: city ?? this.city,
        state: state ?? this.state,
        postcode: postcode ?? this.postcode,
        country: country ?? this.country,
        countryCode: countryCode ?? this.countryCode,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        houseNumber: json["house_number"] ?? "",
        building: json["building"] ?? "",
        neighbourhood: json["neighbourhood"] ?? "",
        road: json["road"] ?? "",
        suburb: json["suburb"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        postcode: json["postcode"] ?? "",
        country: json["country"] ?? "",
        countryCode: json["country_code"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "house_number": houseNumber,
        "road": road,
        "building": building,
        "neighbourhood": neighbourhood,
        "suburb": suburb,
        "city": city,
        "state": state,
        "postcode": postcode,
        "country": country,
        "country_code": countryCode,
      };
}
