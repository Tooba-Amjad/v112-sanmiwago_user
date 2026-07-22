import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/location/address_from_lat_lng_model.dart';
import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  MapController controllerOld = MapController(initPosition: GeoPoint(latitude: 0, longitude: 0));
  late PickerMapController controller = PickerMapController(
    initMapWithUserPosition: UserTrackingOption(enableTracking: false),
    // initPosition: GeoPoint(latitude: 40.7171683, longitude: -73.9973813),
  );

  GeoPoint? selectedLocation;

  @override
  void initState() {
    super.initState();
    controller.isMapMovingNotifier.addListener(() {
      log("my isMoving");
    });

    controller.listenerRegionIsChanging.addListener(() {
      log("my listenerRegionIsChanging");
      getPosition();
    });
  }

  getPosition() async {
    selectedLocation = await controller.selectAdvancedPositionPicker();
    log("selectedLocation lat: ${selectedLocation?.latitude} and lng: ${selectedLocation?.longitude}");
  }

  getCurrentPosition() async {
    // GeoPoint currentLocation = await controller.;
    // log("currentLocation lat: ${currentLocation?.latitude} and lng: ${currentLocation?.longitude}");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: 'Location Picker',
        haveBackIcon: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomPickerLocation(
              controller: controller,
              showDefaultMarkerPickWidget: true,
              topWidgetPicker: Padding(
                padding: const EdgeInsets.only(top: 56, left: 8, right: 8),
              ),
              // bottomWidgetPicker: Positioned(
              //   bottom: 12,
              //   right: 8,
              //   child: FloatingActionButton(
              //     onPressed: () async {
              //       GeoPoint p = await controller.selectAdvancedPositionPicker();
              //       log("picked location is: ${p.latitude} ${p.longitude}");
              //       // if (!context.mounted) return;
              //       // Navigator.pop(context, p);
              //     },
              //     child: const Icon(Icons.arrow_forward),
              //   ),
              // ),
              pickerConfig: const CustomPickerLocationConfig(
                zoomOption: ZoomOption(
                  initZoom: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              GeoPoint p = await controller.selectAdvancedPositionPicker();

              showCircularLoading();
              AddressFromLatLng address = await locationController.getAddressFromLatLng(p.latitude, p.longitude);
              print("Address: ${address.toJson()}");

              checkoutController.addressController.text = address.address.road; // + street
              checkoutController.buildingNameController.text = address.address.building;
              checkoutController.cityController.text = address.address.city.replaceAll("City of ", "").trim();
              checkoutController.stateController.text = address.address.state;
              checkoutController.zipController.text = address.address.postcode;
              checkoutController.neighborhoodController.text = address.address.neighbourhood.isNotEmpty ? address.address.neighbourhood : address.address.suburb;
              checkoutController.houseController.text = address.address.houseNumber;

              checkoutController.addressLat = p.latitude;
              checkoutController.addressLng = p.longitude;

              dismissLoading();

              Get.back();

              // // Get the picked location coordinates
              // if (selectedLocation != null) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: MyText(text: 'Selected Location: ${selectedLocation!.latitude}, ${selectedLocation!.longitude}'),
              //     ),
              //   );
              // }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Set the background color
              foregroundColor: Colors.white, // Set the text color
            ),
            child: MyText(
              text: 'Pick',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              paddingRight: 20,
              paddingLeft: 20,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.my_location),
      //   onPressed: () async {
      //     // Move map to user's current location
      //     // await controller.currentLocation();
      //     // GeoPoint? userLocation = await controller.myLocation();
      //     // controller.moveTo(userLocation);
      //     // setState(() {
      //     //   selectedLocation = userLocation;
      //     //   markerNotifier.value = selectedLocation;
      //     // });
      //   },
      // ),
    );
  }
}
