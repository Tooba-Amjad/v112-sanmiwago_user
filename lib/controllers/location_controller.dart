import 'dart:convert';
import 'dart:developer';

// import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sanmiwago_user/constants/app_constants.dart';
import 'package:sanmiwago_user/models/location/address_from_lat_lng_model.dart';
import 'package:sanmiwago_user/models/location/google_address_from_lat_lng_model.dart';
import 'package:sanmiwago_user/services/app_exceptions.dart';

import '../constants/api_constants.dart';
import '../services/base_client.dart';
import '../utils/snack_bar.dart';

class LocationController extends GetxController {
  static LocationController instance = Get.find<LocationController>();
  RxBool isLoadingDriverLocation = true.obs;
  RxDouble driverLat = 0.0.obs;
  RxDouble driverLng = 0.0.obs;

  LatLng? newLocationLatLng;
  double? currentLatitude;
  double? currentLongitude;

  LatLng? pickedLocation;

  AddressFromLatLng pickedAddress = AddressFromLatLng(address: Address());

  Future<(double, double)> getDriverLocation({required String orderId, required String driverId}) async {
    // isLoadingDriverLocation.value = true;
    double lat = 0.0;
    double lng = 0.0;
    try {
      var response = await BaseClient().post(ApiConstants.baseUrl, ApiConstants.driverLocationEndpoint, {"driver_id": driverId, "order_id": orderId});
      // .catchError(handleError);
      if (response == null) return (lat, lng);

      log("After getting data response in getDriverLocation \n $response");
      // log(" \n  Response data in getDriverLocation  \n ${response['data']}");

      String result = response.containsKey("responce")
          ? response["responce"].containsKey("status")
                ? response["responce"]["status"]
                : ""
          : "error";
      log("result: $result");
      if (result == "success") {
        lat = double.tryParse(response["responce"]["lat"] ?? "0.0") ?? 0.0;
        lng = double.tryParse(response["responce"]["lon"] ?? "0.0") ?? 0.0;

        // log("fetched lat: $lat");
        // log("fetched lng: $lng");
        // showMsg(msg: "Lat: $lat &&&& Lng: $lng");

        isLoadingDriverLocation.value = false;
        return (lat, lng);
      } else {
        // isLoadingDriverLocation.value = false;
        showMsg(msg: response["responce"]["message"] ?? "Something wrong. Please make sure you have a stable internet connection");
        return (lat, lng);
      }
    } on ApiNotRespondingException catch (e) {
      // isLoadingDriverLocation.value = false;
      log("Error in getting driver's location: $e");
      showMsg(msg: "Make sure you have a good internet connection");
      // showMsg(msg: "Something wrong please try again");
      return (lat, lng);
    } catch (e) {
      // isLoadingDriverLocation.value = false;
      log("Error in getting driver's location: $e");
      showMsg(msg: "Error in getting driver's location: $e");
      // showMsg(msg: "Something wrong please try again");
      return (lat, lng);
    }
  }

  Future<AddressFromLatLng> getAddressFromLatLng(double lat, double lon) async {
    const String apiKey = 'pk.5eaec12a226b69e085c112c626d6bdd5'; // Replace with your LocationIQ API key
    final String url = 'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=18&addressdetails=1';
    // 'https://us1.locationiq.com/v1/reverse.php?key=$apiKey&lat=$lat&lon=$lon&format=json';

    // try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the JSON response
      var data = json.decode(response.body);
      log("response: $data");
      AddressFromLatLng address = AddressFromLatLng.fromJson(data); // Full address string
      return address;
    } else {
      showMsg(msg: "Failed to fetch address");
      return AddressFromLatLng(address: Address());
      // return "Failed to fetch address";
    }
    // } catch (e) {
    //   showMsg(msg: "Error: $e");
    //   return AddressFromLatLng(address: Address());
    // }
  }

  Future<List<AddressResult>> getAddressFromLatLngGMap(double lat, double lon) async {
    final String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lon&key=${AppConstants.apiKey}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
          return (data['results'] as List).map((result) => AddressResult.fromJson(result)).toList();
        } else {
          showMsg(msg: "No address found");
          return [];
        }
      } else {
        showMsg(msg: "Failed to fetch address");
        return [];
      }
    } catch (e) {
      showMsg(msg: "Error: $e");
      return [];
    }
  }

  Future<AddressResult> fetchPlaceDetails(String placeId) async {
    final String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${AppConstants.apiKey}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          // log("data in fetchPlaceDetails $data");
          return AddressResult.fromJson(data['result']);
        } else {
          throw Exception('Failed to fetch place details: ${data['status']}');
        }
      } else {
        throw Exception('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching place details: $e');
    }
  }

  clearPickedLocation() {
    pickedAddress = AddressFromLatLng(address: Address());
  }

  Future<Position> determinePosition(BuildContext context, {bool showLoading = true}) async {
    bool serviceEnabled;
    LocationPermission permission;
    if (showLoading) showCircularLoading();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      log("Location services are disabled. !serviceEnabled");
      if (showLoading) dismissLoading();
      showScaffoldMsg(context: context, isSuccess: false, msg: "Location is disabled. Please enable it to continue.");
      Future.delayed(const Duration(seconds: 3), () async {
        await Geolocator.openLocationSettings();
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (showLoading) dismissLoading();
        log("Location services are denied. permission == LocationPermission.denied");
        showScaffoldMsg(context: context, msg: "Location permission is not granted. Please grant it to continue.");
        Future.delayed(const Duration(seconds: 3), () async {
          await Geolocator.openAppSettings();
        });

        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (showLoading) dismissLoading();
      log("Location services are deniedForever. permission == LocationPermission.deniedForever");
      showScaffoldMsg(context: context, msg: "Location permission is not granted. Please grant it to continue.");
      Future.delayed(const Duration(seconds: 3), () async {
        await Geolocator.openAppSettings();
      });
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    Position pos = await Geolocator.getCurrentPosition(
      // locationSettings: const LocationSettings(
      //   accuracy: LocationAccuracy.best,
      // ),
    );
    currentLatitude = pos.latitude;
    currentLongitude = pos.longitude;
    if (showLoading) dismissLoading();
    return pos;
  }

  // Future<Position> determinePosition(BuildContext context) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     log("Location services are disabled. !serviceEnabled");
  //     showScaffoldMsg(
  //       context: context,
  //       isSuccess: false,
  //       msg: "Location is disabled. Please enable it to continue.",
  //     );
  //     Future.delayed(const Duration(seconds: 3), () async {
  //       await Geolocator.openLocationSettings();
  //     });
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       log("Location services are denied. permission == LocationPermission.denied");
  //       showScaffoldMsg(context: context, msg: "Location permission is not granted. Please grant it to continue.");
  //       Future.delayed(
  //         const Duration(seconds: 3),
  //         () async {
  //           await Geolocator.openAppSettings();
  //         },
  //       );
  //
  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     log("Location services are deniedForever. permission == LocationPermission.deniedForever");
  //     showScaffoldMsg(context: context, msg: "Location permission is not granted. Please grant it to continue.");
  //     Future.delayed(const Duration(seconds: 3), () async {
  //       await Geolocator.openAppSettings();
  //     });
  //     return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //
  //   return await Geolocator.getCurrentPosition();
  // }
}
