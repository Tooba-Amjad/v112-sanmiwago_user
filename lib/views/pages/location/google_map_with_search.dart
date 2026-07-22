import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:gymaniac_admin/provider/location_provider.dart';
// import 'package:gymaniac_admin/utils/dialog.dart';
// import 'package:gymaniac_admin/utils/snack_bar.dart';
// import 'package:gymaniac_admin/widgets/my_text.dart';
import 'package:http/http.dart' as http;
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';

import '../../../models/location/address_from_lat_lng_model.dart';
import '../../../utils/snack_bar.dart';
import '../../widgets/my_text.dart';

const String proxyUrl = 'https://us-central1-gym-app-kw.cloudfunctions.net/api/proxy'; // Your Proxy URL
const String apiKey = 'AIzaSyC2bJK3FU4zj2g352f2hMOq8vGcCoyvBDQ'; // Use your actual Google API key

class LocationPickerModifiedWithSearch extends StatefulWidget {
  const LocationPickerModifiedWithSearch({super.key});

  @override
  State<LocationPickerModifiedWithSearch> createState() => LocationPickerModifiedWithSearchState();
}

class LocationPickerModifiedWithSearchState extends State<LocationPickerModifiedWithSearch> {
  late GoogleMapController _mapController;
  final FloatingSearchBarController _searchBarController = FloatingSearchBarController();

  final List<Marker> _markers = <Marker>[];
  bool fetchingLocation = false;

  String selectedAddress = "";
  LatLng? selectedLatLng;

  void _onPlaceSelected(String description, LatLng position) {
    log("in on place selected _onPlaceSelected");
    selectedAddress = description;
    selectedLatLng = position;

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(description),
          position: position,
          infoWindow: InfoWindow(title: description),
        ),
      );
    });

    _mapController.animateCamera(CameraUpdate.newLatLng(position));
    _searchBarController.close();
  }

  Future<List<Map<String, dynamic>>> _fetchPlaceSuggestions(String query) async {
    final response = await http.get(
      Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$apiKey&language=en_us&sessiontoken=123456'),
      // Uri.parse('$proxyUrl?path=place/autocomplete/json&input=$query&key=$apiKey&language=en_us&sessiontoken=123456'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['predictions'] as List)
          .map((item) => {
                'description': item['description'],
                'placeId': item['place_id'],
              })
          .toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<LatLng> _getPlaceLatLng(String placeId) async {
    log("in get place lat lng _getPlaceLatLng");
    final response = await http.get(
      Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey'),
      // Uri.parse('$proxyUrl?path=place/details/json&place_id=$placeId&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("data from places details api is: $data");
      final location = data['result']['geometry']['location'];
      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Failed to load place details');
    }
  }

  List placeList = [];

  Future<void> _confirmLocation() async {
    if (selectedLatLng == null) {
      showScaffoldMsg(context: context, msg: "Please search or drop a pin to select a location");
    }
    log("in confirm location _confirmLocation");
    showCircularLoading();

    print('Picked Location: ${locationController.pickedLocation}');
    print('Picked Location selectedLatLng: $selectedLatLng');

    // locationProvider.newLocationLatLng = locationProvider.pickedLocation;
    locationController.newLocationLatLng = selectedLatLng;
    locationController.pickedLocation = selectedLatLng;
    AddressFromLatLng address =
        await locationController.getAddressFromLatLng(locationController.pickedLocation?.latitude ?? 0.0, locationController.pickedLocation?.longitude ?? 0.0);
    print("Address: ${address.toJson()}");
    //
    checkoutController.addressController.text = address.address.road; // + street
    checkoutController.buildingNameController.text = address.address.building;
    checkoutController.cityController.text = address.address.city.replaceAll("City of ", "").trim();
    checkoutController.stateController.text = address.address.state;
    checkoutController.zipController.text = address.address.postcode;
    checkoutController.neighborhoodController.text = address.address.neighbourhood.isNotEmpty ? address.address.neighbourhood : address.address.suburb;
    checkoutController.houseController.text = address.address.houseNumber;

    checkoutController.addressLat = locationController.pickedLocation?.latitude ?? 0.0;
    checkoutController.addressLng = locationController.pickedLocation?.longitude ?? 0.0;

    dismissLoading(); // for loading popup
    // Navigator.of(context).pop(); // for loading popup
    // context.pop();
    Get.back();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            padding: const EdgeInsets.only(bottom: 0, top: 0, right: 0, left: 0),
            compassEnabled: true,
            myLocationButtonEnabled: false,
            mapToolbarEnabled: false,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            mapType: MapType.normal,
            markers: Set<Marker>.of(_markers),
            initialCameraPosition: CameraPosition(
              zoom: 18.0,
              // target: LatLng(29.31167367328158, 47.481767314966085),
              // target: LatLng(locationProvider.currentLatitude ?? 29.31167367328158, locationProvider.currentLongitude ?? 47.481767314966085),
              target: LatLng(
                checkoutController.addressLat != 0.0 ? checkoutController.addressLat : (locationController.currentLatitude ?? 29.31167367328158),
                checkoutController.addressLng != 0.0 ? checkoutController.addressLng : (locationController.currentLongitude ?? 47.481767314966085),
              ),
            ),
            // markers: Set<Marker>.of(_markers),
            // onCameraMove: locationProvider.onCameraMove,
            onTap: (latLng) {
              selectedAddress = "";
              selectedLatLng = null;
              _onPlaceSelected("", latLng);
            },
            onMapCreated: (controller) {
              _mapController = controller;

              WidgetsBinding.instance.addPostFrameCallback((time) {
                if ((checkoutController.addressLat != 0.0 && checkoutController.addressLng != 0.0) ||
                    (locationController.currentLatitude != 0.0 && locationController.currentLongitude != 0.0)) {
                  WidgetsBinding.instance.addPostFrameCallback((time) {
                    _onPlaceSelected(
                      checkoutController.addressController.text.trim(),
                      LatLng(
                        checkoutController.addressLat != 0.0 ? checkoutController.addressLat : (locationController.currentLatitude ?? 29.31167367328158),
                        checkoutController.addressLng != 0.0 ? checkoutController.addressLng : (locationController.currentLongitude ?? 47.481767314966085),
                      ),
                    );
                  });
                }
              });

              // WidgetsBinding.instance.addPostFrameCallback((_) async {
              // controller.animateCamera(
              //   // CameraUpdate.newLatLng(LatLng(position?.latitude ?? 29.31167367328158, position?.longitude ?? 47.481767314966085)),
              //   // CameraUpdate.newLatLng(LatLng(locationProvider.currentLatitude ?? 29.31167367328158, locationProvider.currentLongitude ?? 47.481767314966085)),
              //   CameraUpdate.newLatLng(
              //     LatLng(
              //       authProvider.latitudeController.text.isNotEmpty
              //           ? (double.tryParse(authProvider.latitudeController.text) ?? 0.0)
              //           : (locationProvider.currentLatitude ?? 29.31167367328158),
              //       authProvider.longitudeController.text.isNotEmpty
              //           ? (double.tryParse(authProvider.longitudeController.text) ?? 0.0)
              //           : (locationProvider.currentLongitude ?? 47.481767314966085),
              //     ),
              //   ),
              // );
              /* */
              // _markers.add(Marker(
              //   markerId: const MarkerId("locationMarker"),
              //   position: LatLng(locationProvider.currentLatitude ?? 29.31167367328158, locationProvider.currentLongitude ?? 47.481767314966085),
              //   icon: BitmapDescriptor.bytes(
              //     await getBytesFromAsset(Assets.imagesLocationIndicator, 70),
              //   ),
              //   infoWindow: const InfoWindow(title: "Location"),
              // ));
              // });
            },
          ),
          // Consumer<LocationProvider>(
          //   builder: (context, provider, child) {
          //     return StreamBuilder(
          //       stream: Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high)),
          //       builder: (BuildContext context, AsyncSnapshot<Position> snapshot) {
          //         if (snapshot.connectionState == ConnectionState.waiting) {
          //           return const Center(
          //             child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
          //           );
          //         } else if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
          //           if (snapshot.hasError) {
          //             return const Text('Error');
          //           } else if (snapshot.hasData) {
          //             final position = snapshot.data;
          //             log("position: $position");
          //             return GoogleMap(
          //               padding: const EdgeInsets.only(bottom: 0, top: 0, right: 0, left: 0),
          //               compassEnabled: true,
          //               myLocationButtonEnabled: true,
          //               mapToolbarEnabled: false,
          //               zoomControlsEnabled: true,
          //               zoomGesturesEnabled: true,
          //               myLocationEnabled: true,
          //               mapType: MapType.normal,
          //               initialCameraPosition: CameraPosition(
          //                 zoom: 14.0,
          //                 target: LatLng(position?.latitude ?? 30.118600, position?.longitude ?? 72.466104),
          //               ),
          //               // markers: Set<Marker>.of(_markers),
          //               onCameraMove: provider.onCameraMove,
          //               onMapCreated: (controller) {
          //                 // _mapController = controller;
          //                 WidgetsBinding.instance.addPostFrameCallback((_) async {
          //                   controller.animateCamera(
          //                     // CameraUpdate.newLatLng(LatLng(position?.latitude ?? 29.31167367328158, position?.longitude ?? 47.481767314966085)),
          //                     CameraUpdate.newLatLng(LatLng(provider.currentLatitude ?? 29.31167367328158, provider.currentLongitude ?? 47.481767314966085)),
          //                   );
          //                   // _markers.add(Marker(
          //                   //   markerId: const MarkerId("locationMarker"),
          //                   //   position: LatLng(locationProvider.currentLatitude ?? 29.31167367328158, locationProvider.currentLongitude ?? 47.481767314966085),
          //                   //   icon: BitmapDescriptor.bytes(
          //                   //     await getBytesFromAsset(Assets.imagesLocationIndicator, 70),
          //                   //   ),
          //                   //   infoWindow: const InfoWindow(title: "Location"),
          //                   // ));
          //                 });
          //               },
          //             );
          //           } else {
          //             return Container();
          //           }
          //         } else {
          //           log("in last else of ConnectionState.done and: ${snapshot.connectionState}");
          //           return Container();
          //         }
          //       },
          //     );
          //   },
          // ),
          /* */
          // GoogleMap(
          //   onMapCreated: (controller) => _mapController = controller,
          //   initialCameraPosition: CameraPosition(
          //     target: LatLng(locationProvider.currentLatitude ?? 29.31167367328158, locationProvider.currentLongitude ?? 47.481767314966085), // Initial position
          //     zoom: 12,
          //   ),
          //   markers: Set<Marker>.of(_markers),
          // ),
          /* */

          // Barrier to block map gestures when interacting with the search bar or its list
          // if (_searchBarController.isOpen || fetchingLocation)
          //   const ModalBarrier(
          //     color: Colors.transparent,
          //     dismissible: false,
          //   ),

          Positioned(
            bottom: 100,
            right: 10,
            child: GestureDetector(
              onTap: () async {
                try {
                  Position pos = await locationController.determinePosition(context);
                  _onPlaceSelected("My Location", LatLng(pos.latitude, pos.longitude));
                } catch (e) {
                  log("error in my location is: $e");
                }
              },
              child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.my_location,
                    size: 26,
                  )),
            ),
          ),

          Positioned(
            top: 10,
            right: 10,
            left: 10,
            child: SizedBox(
              height: placeList.isNotEmpty ? 350 : 80,
              child: FloatingSearchBar(
                debounceDelay: const Duration(milliseconds: 300),
                controller: _searchBarController,
                hint: 'Search places...',
                scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                transitionDuration: const Duration(milliseconds: 800),
                transitionCurve: Curves.easeInOut,
                physics: const BouncingScrollPhysics(),
                onQueryChanged: (query) {
                  // Get search suggestions
                  setState(() {
                    fetchingLocation = true;
                  });
                  _fetchPlaceSuggestions(query).then((places) {
                    // _searchBarController.refresh();
                    fetchingLocation = false;
                    setState(() {
                      placeList = places; // Update the list of suggestions
                    });
                  });
                },
                builder: (context, transition) {
                  if (fetchingLocation) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.kLogoBasedColor));
                  }

                  return Material(
                    color: Colors.white,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    child: placeList.isNotEmpty
                        ? PointerInterceptor(
                            child: _buildSuggestionsList(),
                          )
                        : _buildSuggestionsList(),
                  );

                  // return Container(
                  //   color: Colors.white,
                  //   height: MediaQuery.of(context).size.height * .3,
                  //   child: ListView(
                  //     padding: const EdgeInsets.all(10),
                  //     children: [
                  //       // ListView for place suggestions
                  //       for (final suggestion in placeList)
                  //         ListTile(
                  //           title: Text(suggestion['description']),
                  //           onTap: () async {
                  //             final latLng = await _getPlaceLatLng(suggestion['placeId']);
                  //             _onPlaceSelected(suggestion['description'], latLng);
                  //           },
                  //         ),
                  //     ],
                  //   ),
                  // );
                },
              ),
            ),
          ),
          // const Center(
          //   child: Icon(
          //     Icons.location_pin,
          //     size: 50,
          //     color: Colors.red,
          //   ),
          // ),
          Positioned(
            bottom: 20,
            left: 20,
            child: PointerInterceptor(
              child: MouseRegion(
                cursor: SystemMouseCursors.click, // Change the cursor type here,
                child: GestureDetector(
                  onTap: _confirmLocation,
                  child: Container(
                    // width: 240,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: "Pick Location",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          paddingRight: 10,
                          // paddingLeft: 20,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                          weight: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(), // Ensure smooth scrolling
      itemCount: placeList.length,
      itemBuilder: (context, index) {
        final suggestion = placeList[index];
        return ListTile(
          title: Text(suggestion['description']),
          onTap: () async {
            showCircularLoading();
            final latLng = await _getPlaceLatLng(suggestion['placeId']);
            dismissLoading();
            _onPlaceSelected(suggestion['description'], latLng);
          },
        );
      },
    );
  }
}
