import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar_2/material_floating_search_bar_2.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/app_constants.dart';

import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/location/google_address_from_lat_lng_model.dart';
import 'package:sanmiwago_user/utils/helpers.dart';

import 'package:sanmiwago_user/utils/snack_bar.dart';
import 'package:sanmiwago_user/views/widgets/my_dialog.dart';

import 'package:sanmiwago_user/views/widgets/my_text.dart';
import 'package:sanmiwago_user/views/widgets/my_text_field.dart';

class CheckoutDeliveryMapAddressSectionWidget extends StatefulWidget {
  const CheckoutDeliveryMapAddressSectionWidget({super.key});

  @override
  State<CheckoutDeliveryMapAddressSectionWidget> createState() => _CheckoutDeliveryMapAddressSectionWidgetState();
}

class _CheckoutDeliveryMapAddressSectionWidgetState extends State<CheckoutDeliveryMapAddressSectionWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Tells Flutter to preserve state

  late GoogleMapController _mapController;
  final FloatingSearchBarController _searchBarController = FloatingSearchBarController();

  final List<Marker> _markers = <Marker>[];
  RxBool fetchingLocation = false.obs;

  String selectedAddress = "";
  String selectedAddressToShow = "";
  LatLng? selectedLatLng;

  RxList<Map<String, dynamic>> placeList = RxList<Map<String, dynamic>>.from([]);

  AddressResult? afterNullAddress;

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
    log("Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${AppConstants.apiKey}&language=en_us'");
    // final String url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=${AppConstants.apiKey}&language=en_us';
    // final String encodedUrl = encodeReservedCharacters(url);
    // log("encodedUrl: $encodedUrl");

    String baseUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json";
    Map<String, String> queryParams = {
      "input": query,
      "key": AppConstants.apiKey,
      "language": "en_us",
    };

    String encodedUrl = encodeUrl(baseUrl, queryParams);
    log("encodedUrl: $encodedUrl");

    final response = await http.get(
      Uri.parse(encodedUrl),
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
      Uri.parse('https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=${AppConstants.apiKey}'),
      // Uri.parse('$proxyUrl?path=place/details/json&place_id=$placeId&key=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      log("data from places details api is: $data");
      final location = data['result']['geometry']['location'];
      log("location from places details api is: $location");
      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Failed to load place details');
    }
  }

  getAddressFromLatLng(LatLng latLng) async {
    List<AddressResult> addresses = await locationController.getAddressFromLatLngGMap(latLng.latitude, latLng.longitude);
    if (addresses.isNotEmpty) {
      AddressResult address = addresses.first;
      afterNullAddress = addresses.first;
      return address;
    } else {
      return null;
    }
  }

  Future<void> _confirmLocation(AddressResult? address) async {
    if (selectedLatLng == null) {
      showScaffoldMsg(context: context, msg: "Please search or drop a pin to select a location");
    }
    log("in confirm location _confirmLocation");
    // showCircularLoading();

    print('Picked Location: ${locationController.pickedLocation}');
    print('Picked Location selectedLatLng: $selectedLatLng');

    // locationProvider.newLocationLatLng = locationProvider.pickedLocation;
    locationController.newLocationLatLng = selectedLatLng;
    locationController.pickedLocation = selectedLatLng;
    // AddressFromLatLng address = await locationController.getAddressFromLatLng(locationController.pickedLocation?.latitude ?? 0.0, locationController.pickedLocation?.longitude ?? 0.0);

    if (address == null) {
      address = getAddressFromLatLng(LatLng(locationController.pickedLocation?.latitude ?? 0.0, locationController.pickedLocation?.longitude ?? 0.0));

      // List<AddressResult> addresses =
      //     await locationController.getAddressFromLatLngGMap(locationController.pickedLocation?.latitude ?? 0.0, locationController.pickedLocation?.longitude ?? 0.0);
      // print("Addresses length: ${addresses.length}");

      if (address == null) {
        dismissLoading();
        showMsg(msg: "Could not fetch an address for this. Please try another closer place.");
        await Future.delayed(Duration(seconds: 3));
        return;
      }
    }
    //
    checkoutController.fullAddressController.text = address.formattedAddress;
    checkoutController.addressController.text = address.street;
    checkoutController.buildingNameController.text = address.building;
    checkoutController.cityController.text = address.city;
    checkoutController.stateController.text = address.state;
    checkoutController.zipController.text = address.zipCode;
    checkoutController.neighborhoodController.text = address.neighborhood;
    checkoutController.houseController.text = address.houseNumber;

    checkoutController.addressLat = locationController.pickedLocation?.latitude ?? 0.0;
    checkoutController.addressLng = locationController.pickedLocation?.longitude ?? 0.0;

    // dismissLoading(); // for loading popup
    // Navigator.of(context).pop(); // for loading popup
    // context.pop();
    // Get.back();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /* + Map opening button - Commented on 20-Dec-2024 + */

        // Row(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     MyButton(
        //       width: 180,
        //       height: 50,
        //       text: "Pick location",
        //       textColor: AppColors.kWhiteColor,
        //       fontSize: 14,
        //       color: AppColors.kRedColor,
        //       icon: Icons.map_outlined,
        //       onPressed: () async {
        //         try {
        //           Position pos = await locationController.determinePosition(context);
        //           locationController.currentLatitude = pos.latitude;
        //           locationController.currentLongitude = pos.longitude;
        //         } catch (e) {
        //           log("error in fetching location: ");
        //         }
        //         navigate(type: PageType.to, page: LocationPickerModifiedWithSearch());
        //         // navigate(type: PageType.to, page: LocationPickerScreen());
        //       },
        //     ),
        //   ],
        // ),

        SizedBox(
          height: 350,
          child: Stack(
            children: <Widget>[
              GoogleMap(
                gestureRecognizers: Set()..add(Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),
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
                    checkoutController.addressLat != 0.0 ? checkoutController.addressLat : (locationController.currentLatitude ?? 40.7175425),
                    checkoutController.addressLng != 0.0 ? checkoutController.addressLng : (locationController.currentLongitude ?? -73.9956312),
                  ),
                ),
                // markers: Set<Marker>.of(_markers),
                // onCameraMove: locationProvider.onCameraMove,
                onTap: (latLng) async {
                  /* + commented for the time being because currently the map movement on touch is not working + */
                  // selectedAddress = "";
                  // selectedLatLng = null;
                  _onPlaceSelected("My Location", latLng);
                  showCircularLoading();
                  // List<AddressResult> addresses = locationController.getAddressFromLatLngGMap(latLng.latitude, latLng.longitude);
                  // await _confirmLocation(null);
                  final AddressResult? address = await getAddressFromLatLng(latLng);
                  dismissLoading();
                  if (address != null) {
                    showMyAddressConfirmationDialog(context, address, latLng, null);
                  }
                },
                onMapCreated: (controller) async {
                  _mapController = controller;

                  await checkoutController.getUserInfoAndAddressForCheckout();

                  WidgetsBinding.instance.addPostFrameCallback((time) {
                    if ((checkoutController.addressLat != 0.0 && checkoutController.addressLng != 0.0) ||
                        (locationController.currentLatitude != 0.0 && locationController.currentLongitude != 0.0)) {
                      WidgetsBinding.instance.addPostFrameCallback((time) async {
                        _onPlaceSelected(
                          checkoutController.addressController.text.trim(),
                          LatLng(
                            checkoutController.addressLat != 0.0 ? checkoutController.addressLat : (locationController.currentLatitude ?? 40.7175425),
                            checkoutController.addressLng != 0.0 ? checkoutController.addressLng : (locationController.currentLongitude ?? -73.9956312),
                          ),
                        );
                        /* + Let's make sure to handle the use case when the fetched address is empty and current location is not + */
                        if ((checkoutController.addressLat == 0.0 && checkoutController.addressLng == 0.0) &&
                            (locationController.currentLatitude != 0.0 && locationController.currentLongitude != 0.0)) {
                          // await _confirmLocation(null);
                          final LatLng latLng = LatLng(locationController.currentLatitude ?? 0.0, locationController.currentLongitude ?? 0.0);
                          final AddressResult? address = await getAddressFromLatLng(latLng);
                          dismissLoading();
                          if (address != null) {
                            showMyAddressConfirmationDialog(context, address, latLng, null);
                          }
                        }
                      });
                    }
                  });
                },
              ),
              Positioned(
                bottom: 100,
                right: 10,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      Position pos = await locationController.determinePosition(context);
                      _onPlaceSelected("My Location", LatLng(pos.latitude, pos.longitude));
                      showCircularLoading();
                      // await _confirmLocation(null);
                      final LatLng latLng = LatLng(pos.latitude, pos.longitude);
                      final AddressResult? address = await getAddressFromLatLng(latLng);
                      dismissLoading();
                      if (address != null) {
                        showMyAddressConfirmationDialog(context, address, latLng, null);
                      }
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
              // Positioned(
              //   top: 10,
              //   right: 10,
              //   left: 10,
              //   child:
              Obx(() {
                return SizedBox(
                  height: placeList.isNotEmpty ? 350 : 80,
                  child: FloatingSearchBar(
                    contextMenuBuilder: (context, editableTextState) {
                      // Build a custom context menu with clipboard options
                      return AdaptiveTextSelectionToolbar.editableText(
                        editableTextState: editableTextState,
                      );
                    },
                    debounceDelay: const Duration(milliseconds: 300),
                    controller: _searchBarController,
                    automaticallyImplyBackButton: false,
                    hint: 'Search places...',
                    scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
                    transitionDuration: const Duration(milliseconds: 800),
                    transitionCurve: Curves.easeInOut,
                    physics: const BouncingScrollPhysics(),
                    onQueryChanged: (query) {
                      // Get search suggestions
                      // setState(() {
                      fetchingLocation.value = true;
                      // });
                      _fetchPlaceSuggestions(query).then((places) {
                        // _searchBarController.refresh();
                        fetchingLocation.value = false;
                        // setState(() {
                        placeList.value = places; // Update the list of suggestions
                        // });
                      });
                    },
                    builder: (context, transition) {
                      return Obx(() {
                        if (fetchingLocation.value) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.kWhiteColor,
                              strokeWidth: 1.2,
                            ),
                          );
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
                      });
                    },
                  ),
                );
              }),
              // ),
            ],
          ),
        ),
        // Obx(() {
        //   return
        MyText(
          text: "Selected Full Address",
          fontSize: 15,
          fontWeight: FontWeight.bold,
          paddingLeft: 15,
          paddingTop: 15,
          paddingBottom: 5,
        ),

        // }),
        /* */
        // Obx(() {
        //   return
        MyTextField(
          hint: "Selected Full Address",
          isReadOnly: true,
          maxLines: 3,
          // disableErrorText: true,
          controller: checkoutController.fullAddressController,
          keyboardType: TextInputType.streetAddress,
          autoFillHints: const [
            AutofillHints.fullStreetAddress,
            AutofillHints.postalAddress,
          ],
          validator: (String? value) {
            // if (value?.isEmpty == true) {
            //   return "House No. is required or please enter a nearby one";
            // }
            return null;
          },
        ),
        // }),

        //+ Suite/Apt/Building
        const MyText(
          text: "Suite No./Apt No./Floor",
          fontSize: 15,
          fontWeight: FontWeight.bold,
          paddingLeft: 15,
          paddingTop: 10,
          paddingBottom: 5,
        ),
        MyTextField(
          hint: "123, 1st floor",
          // disableErrorText: true,
          controller: checkoutController.suiteAptController,
          keyboardType: TextInputType.streetAddress,
          autoFillHints: const [
            AutofillHints.fullStreetAddress,
            AutofillHints.postalAddress,
          ],
          validator: (String? value) {
            // if (value?.isEmpty == true) {
            //   return "Suite/Apt/Building is required or please enter a nearby one";
            // }
            return null;
          },
        ),

        /* + Building Name + */
        const MyText(
          text: "Company/Building Name",
          fontSize: 15,
          fontWeight: FontWeight.bold,
          paddingLeft: 15,
          paddingTop: 10,
          paddingBottom: 5,
        ),
        MyTextField(
          hint: "ABC Building",
          // disableErrorText: true,
          controller: checkoutController.buildingNameController,
          keyboardType: TextInputType.streetAddress,
          autoFillHints: const [
            AutofillHints.fullStreetAddress,
            AutofillHints.postalAddress,
          ],
          validator: (String? value) {
            // if (value?.isEmpty == true) {
            //   return "Building Name is required";
            // }
            return null;
          },
        ),

        // /* + House No + */
        // const MyText(
        //   text: "House No.",
        //   fontSize: 15,
        //   fontWeight: FontWeight.bold,
        //   paddingLeft: 15,
        //   paddingTop: 10,
        //   paddingBottom: 5,
        // ),
        // MyTextField(
        //   hint: "House No.",
        //   // disableErrorText: true,
        //   controller: checkoutController.houseController,
        //   keyboardType: TextInputType.streetAddress,
        //   autoFillHints: const [
        //     AutofillHints.fullStreetAddress,
        //     AutofillHints.postalAddress,
        //   ],
        //   validator: (String? value) {
        //     if (value?.isEmpty == true) {
        //       return "House No. is required or please enter a nearby one";
        //     }
        //     return null;
        //   },
        // ),
        //
        // /* + Building Name + */
        // const MyText(
        //   text: "Building Name",
        //   fontSize: 15,
        //   fontWeight: FontWeight.bold,
        //   paddingLeft: 15,
        //   paddingTop: 10,
        //   paddingBottom: 5,
        // ),
        // MyTextField(
        //   hint: "Building Name",
        //   // disableErrorText: true,
        //   controller: checkoutController.buildingNameController,
        //   keyboardType: TextInputType.streetAddress,
        //   autoFillHints: const [
        //     AutofillHints.fullStreetAddress,
        //     AutofillHints.postalAddress,
        //   ],
        //   validator: (String? value) {
        //     // if (value?.isEmpty == true) {
        //     //   return "Building Name is required";
        //     // }
        //     return null;
        //   },
        // ),
        //
        // /* + Street + */
        // const MyText(
        //   text: "Street Name",
        //   fontSize: 15,
        //   fontWeight: FontWeight.bold,
        //   paddingLeft: 15,
        //   paddingTop: 10,
        //   paddingBottom: 5,
        // ),
        // MyTextField(
        //   hint: "Street Name",
        //   // disableErrorText: true,
        //   isReadOnly: true,
        //   controller: checkoutController.addressController,
        //   keyboardType: TextInputType.streetAddress,
        //   autoFillHints: const [
        //     AutofillHints.fullStreetAddress,
        //     AutofillHints.postalAddress,
        //   ],
        //   validator: (String? value) {
        //     if (value?.isEmpty == true) {
        //       return "Street Name is required";
        //     }
        //     return null;
        //   },
        // ),
        //
        // /* + Neighborhood */
        // const MyText(
        //   text: "Neighborhood",
        //   fontSize: 15,
        //   fontWeight: FontWeight.bold,
        //   paddingLeft: 15,
        //   paddingTop: 10,
        //   paddingBottom: 5,
        // ),
        // MyTextField(
        //   hint: "Neighborhood",
        //   // disableErrorText: true,
        //   isReadOnly: true,
        //   controller: checkoutController.neighborhoodController,
        //   keyboardType: TextInputType.streetAddress,
        //   autoFillHints: const [
        //     AutofillHints.fullStreetAddress,
        //     AutofillHints.postalAddress,
        //   ],
        //   validator: (String? value) {
        //     if (value?.isEmpty == true) {
        //       return "Neighborhood is required";
        //     }
        //     return null;
        //   },
        // ),
        //
        // /* + City + */
        // const MyText(
        //   text: "City",
        //   fontSize: 15,
        //   fontWeight: FontWeight.bold,
        //   paddingLeft: 15,
        //   paddingTop: 10,
        //   paddingBottom: 5,
        // ),
        // MyTextField(
        //   hint: "City",
        //   // disableErrorText: true,
        //   isReadOnly: true,
        //   controller: checkoutController.cityController,
        //   keyboardType: TextInputType.streetAddress,
        //   autoFillHints: const [AutofillHints.addressCity],
        //   validator: (String? value) {
        //     if (value?.isEmpty == true) {
        //       return "City is required";
        //     }
        //     return null;
        //   },
        // ),
        //
        // /* + State + */
        // const MyText(
        //   text: "State",
        //   fontSize: 15,
        //   fontWeight: FontWeight.bold,
        //   paddingLeft: 15,
        //   paddingTop: 10,
        //   paddingBottom: 5,
        // ),
        // MyTextField(
        //   hint: "State",
        //   // disableErrorText: true,
        //   isReadOnly: true,
        //   controller: checkoutController.stateController,
        //   keyboardType: TextInputType.streetAddress,
        //   autoFillHints: const [AutofillHints.addressCity],
        //   validator: (String? value) {
        //     if (value?.isEmpty == true) {
        //       return "State is required";
        //     }
        //     return null;
        //   },
        // ),

        /* + Commented house, street, neighborhood, state, city fields but their data is being assigned and sent + */

        // //+ State Dropdown
        // Obx(() {
        //   if (apiController.isLoadingStates.value || checkoutController.states.isEmpty) {
        //     return showInlineLoading();
        //   }
        //   return MyDropDownTextField(
        //     isForEdit: true,
        //     initialValue: checkoutController.selectedState.value.isNotEmpty ? checkoutController.selectedState.value : null,
        //     listItem: checkoutController.states.map((element) => element.name).toList(),
        //     hintText: "Select State",
        //     onChange: (value) {
        //       infoLog("selected State: $value");
        //       checkoutController.selectedState.value = value ?? "";
        //     },
        //     validator: (value) {
        //       if (checkoutController.selectedState.value.isEmpty) {
        //         return "Please select a value";
        //       }
        //       return null;
        //     },
        //   );
        // }),

        //+ Zipcode

        /* */

        // const MyText(
        //   text: "Zipcode",
        //   fontSize: 15,
        //   fontWeight: FontWeight.bold,
        //   paddingLeft: 15,
        //   paddingTop: 10,
        //   paddingBottom: 5,
        // ),
        // MyTextField(
        //   hint: "Zipcode",
        //   // disableErrorText: true,
        //   isReadOnly: true,
        //   inputFormatters: [
        //     LengthLimitingTextInputFormatter(5),
        //   ],
        //   controller: checkoutController.zipController,
        //   textInputAction: TextInputAction.done,
        //   keyboardType: TextInputType.number,
        //   autoFillHints: const [
        //     AutofillHints.postalCode,
        //   ],
        //   validator: (String? value) {
        //     if (value?.isEmpty == true) {
        //       return "Zipcode is required";
        //     } else if ((value?.trim().length ?? 0) != 5) {
        //       return "Please enter your 5 digit zipcode";
        //     } else if (int.tryParse(value?.trim() ?? "") == null) {
        //       return "Please enter a valid 5 digit zipcode";
        //     }
        //     return null;
        //   },
        // ),

        /* */

        /* + Distance + */
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 0),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  return RichText(
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: "Distance: ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: checkoutController.deliveryFeeInfo.value.distance,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        /* + Delivery fee + */
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  return RichText(
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    text: TextSpan(
                      text: "Delivery Fee (Varies by distance): ",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: !checkoutController.isOrderDeliverable.value && checkoutController.deliveryFeeInfo.value.isOutOfBound
                              ? checkoutController.deliveryFeeInfo.value.isOutOfBoundMessage
                              : "\$${checkoutController.deliveryFeeInfo.value.doordashDeliveryFee}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 16,
                            color: !checkoutController.isOrderDeliverable.value && checkoutController.deliveryFeeInfo.value.isOutOfBound
                                ? AppColors.kRedColor
                                : AppColors.kBlackColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),

        /* + Delivery Notes + */
        const MyText(
          text: "Delivery Note",
          fontSize: 15,
          fontWeight: FontWeight.bold,
          paddingLeft: 15,
          paddingTop: 10,
          paddingBottom: 5,
        ),
        MyTextField(
          // isExpands: true,
          maxLines: 5,
          hint: "Delivery Note",
          // disableErrorText: true,
          controller: checkoutController.deliverNoteController,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.multiline,
          validator: (String? value) {
            return null;
          },
        ),
        const SizedBox(height: 20),
      ],
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
            hideKeyboard(context);
            showCircularLoading();
            final latLng = await _getPlaceLatLng(suggestion['placeId']);
            // selectedAddressToShow = suggestion['description'];
            log("suggestion['description']: ${suggestion['description']}");
            final AddressResult address = await locationController.fetchPlaceDetails(suggestion['placeId']);
            dismissLoading();

            showMyAddressConfirmationDialog(context, address, latLng, suggestion);
          },
        );
      },
    );
  }

  showMyAddressConfirmationDialog(BuildContext context, AddressResult address, LatLng latLng, suggestion) {
    log("inside showMyAddressConfirmationDialog");
    showMyAnimatedDialog(
      context: context,
      child: MyNewConfirmDialog(
        title: "Confirm Address?",
        msg: "Do you want to use this address?\n${address.formattedAddress}",
        rightButtonText: "Proceed",
        leftButtonText: "Modify",
        rightButtonWidth: 120,
        leftButtonWidth: 120,
        yesOnPressed: () async {
          showCircularLoading();
          checkoutController.fullAddressController.text = address.formattedAddress;
          log("formattedAddress: ${address.formattedAddress}");
          selectedLatLng = latLng;
          await _confirmLocation(address);
          await apiController.getDistanceAndDeliveryFeeForCheckout(shouldDismissLoading: true);
          // dismissLoading();
          _onPlaceSelected(suggestion?['description'] ?? "My Location", latLng);
        },
        noOnPressed: () {
          _searchBarController.close();
          if (checkoutController.addressLat != 0.0 && checkoutController.addressLng != 0.0) {
            selectedLatLng = LatLng(checkoutController.addressLat, checkoutController.addressLng);
            _onPlaceSelected(suggestion?['description'] ?? "My Location", selectedLatLng!);
          }
        },
      ),
    );
  }
}
