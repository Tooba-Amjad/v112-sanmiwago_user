import 'dart:async';
import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:sanmiwago_user/constants/app_colors.dart';
import 'package:sanmiwago_user/constants/controller_instances.dart';
import 'package:sanmiwago_user/models/order_view_model.dart';
import 'package:sanmiwago_user/services/pusher/driver_location_update.dart';
import 'package:sanmiwago_user/services/pusher/pusher_service.dart';
import 'package:sanmiwago_user/views/widgets/simple_appbar.dart';

class DriverOSMMap extends StatelessWidget {
  final OrderViewModel order;
  final String orderId;
  final String invoiceNumber;
  final String driverId;

  const DriverOSMMap({super.key, required this.order, required this.orderId, required this.invoiceNumber, required this.driverId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: simpleAppBar(
        title: "Invoice# $invoiceNumber",
        // title: "Order# $orderId",
        haveBackIcon: true,
        onBackPressed: () => Get.back(closeOverlays: true),
      ),
      body: SimpleOSM(order: order, orderId: orderId, driverId: driverId),
    );
  }
}

class SimpleOSM extends StatefulWidget {
  final OrderViewModel order;
  final String orderId;
  final String driverId;

  const SimpleOSM({super.key, required this.order, required this.orderId, required this.driverId});

  @override
  State<StatefulWidget> createState() => SimpleOSMState();
}

class SimpleOSMState extends State<SimpleOSM> with AutomaticKeepAliveClientMixin {
  late MapController controller;

  StreamSubscription<DriverLocationUpdate>? _driverLocationSub;

  RxDouble remDistanceInKM = 0.0.obs;
  RxDouble remTimeInSec = 0.0.obs;

  String lastMapKey = "";

  bool isEmptyLatLng = true;

  RoadInfo? roadInfo;

  static const String userRep = "User";
  static const String driverRep = "Driver";
  static const String deliveryRep = "DeliveryLocation";
  static const String restaurantRep = "RestaurantLocation";
  Queue roadsQueue = Queue();

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
    );

    getDriverLocationAndUpdateMap(performSimpleFetch: true);
  }

  setMyAndDeliveryLocation() async {
    deliveryLocation = GeoPoint(
      latitude: double.tryParse(widget.order.order.latitudeCustomer) ?? 0.0,
      longitude: double.tryParse(widget.order.order.longitudeCustomer) ?? 0.0,
    );
    restaurantLocation = GeoPoint(
      latitude: double.tryParse(widget.order.order.latitudeResturant) ?? 0.0,
      longitude: double.tryParse(widget.order.order.longitudeResturant) ?? 0.0,
    );
  }

  Future<void> _startDriverLocationListening() async {
    await _driverLocationSub?.cancel();
    await PusherService.instance.ensureDriverTrackingSubscribed(widget.orderId);

    _driverLocationSub = PusherService.instance.driverLocationStream.listen((update) {
      if (!mounted) return;
      if (update.orderId.isNotEmpty && update.orderId != widget.orderId) return;
      unawaited(_applyDriverLocation(update.lat, update.lon));
    });
  }

  getDriverLocationAndUpdateMap({bool performSimpleFetch = false}) {
    locationController.getDriverLocation(orderId: widget.orderId, driverId: widget.driverId).then((geoPoint) async {
      if (!mounted) return;
      var (lat, lng) = geoPoint;
      await _applyDriverLocation(lat, lng, performSimpleFetch: performSimpleFetch);
    });
  }

  Future<void> _applyDriverLocation(double lat, double lng, {bool performSimpleFetch = false}) async {
    if (!mounted) return;
    if (lat == 0.0 && lng == 0.0) return;

    driverLocation = GeoPoint(latitude: lat, longitude: lng);

    if (!performSimpleFetch) {
      controller.setStaticPosition([driverLocation], driverRep);
      controller.setMarkerOfStaticPoint(id: driverRep, markerIcon: myDriverIcon);
      log("queue: before is: $roadsQueue with length: ${roadsQueue.length}");
      await drawRoad();
      log("queue: after is: $roadsQueue with length: ${roadsQueue.length}");
      if (roadsQueue.length > 1) {
        try {
          await controller.removeRoad(roadKey: roadsQueue.removeFirst());
        } catch (e) {
          log("error in removing road: $e");
        }
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> drawRoad() async {
    log("driverLocation: $driverLocation");
    log("deliveryLocation: $deliveryLocation");
    try {
      roadInfo = await controller.drawRoad(
        driverLocation,
        deliveryLocation,
        roadType: RoadType.car,
        roadOption: RoadOption(roadWidth: 10, roadColor: Colors.black, zoomInto: roadInfo == null ? true : false),
      );

      if (roadInfo != null && roadInfo?.key != null && (roadInfo?.route.isNotEmpty ?? false)) {
        remDistanceInKM.value = roadInfo?.distance ?? 0.0;
        remTimeInSec.value = roadInfo?.duration ?? 0.0;
        roadsQueue.addLast(roadInfo?.key ?? "");
      }
    } catch (e) {
      log("error in drawing road: $e");
    }

    log("roadInfo.key ${roadInfo?.key} ");
    log("roadInfo.key ${roadInfo?.distance} ");
    log("roadInfo.key ${roadInfo?.duration} ");
    log("roadInfo.instructions.length ${roadInfo?.instructions.length}");
    log("roadInfo.route.length ${roadInfo?.route.length}");
  }

  @override
  void dispose() {
    unawaited(_driverLocationSub?.cancel());
    _driverLocationSub = null;
    unawaited(PusherService.instance.stopDriverTracking());
    try {
      controller.dispose();
    } catch (e) {
      log("error in dispose: $e");
    }
    super.dispose();
  }

  GeoPoint driverLocation = GeoPoint(latitude: 30.117046, longitude: 72.466365);
  GeoPoint userLocation = GeoPoint(latitude: 30.117046, longitude: 72.466365);
  GeoPoint deliveryLocation = GeoPoint(latitude: 30.117046, longitude: 72.466365);
  GeoPoint restaurantLocation = GeoPoint(latitude: 30.117046, longitude: 72.466365);

  /* ! Driver Location icon ! */
  var myDriverIcon = const MarkerIcon(icon: Icon(Icons.car_crash_outlined, color: Colors.black, size: 48));

  /* ! User Location icon ! */
  var myUserIcon = const MarkerIcon(icon: Icon(Icons.location_history_rounded, color: Colors.red, size: 48));

  /* ! Delivery Location icon ! */
  var deliveryLocationIcon = const MarkerIcon(icon: Icon(Icons.location_city_rounded, color: Colors.yellow, size: 48));

  /* !  Restaurant Location icon ! */
  var restaurantLocationIcon = const MarkerIcon(icon: Icon(Icons.restaurant, color: AppColors.kLogoBasedColor, size: 48));

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return locationController.isLoadingDriverLocation.value
          ? const Center(
              child: SizedBox(height: 35, width: 35, child: CircularProgressIndicator(color: AppColors.kLogoBasedColor)),
            )
          : OSMFlutter(
              controller: controller,
              onMapIsReady: (bool isReady) async {
                log("map is ready called with: $isReady");
                setMyAndDeliveryLocation();

                /* + Initial driver location (one-shot API) + */
                await getDriverLocationAndUpdateMap();

                controller.moveTo(driverLocation);

                /* + Live updates via Pusher driver-live-tracking-{orderId} + */
                await _startDriverLocationListening();
              },
              osmOption: OSMOption(
                userTrackingOption: const UserTrackingOption(enableTracking: false, unFollowUser: false),
                showContributorBadgeForOSM: true,
                showZoomController: true,
                showDefaultInfoWindow: true,
                enableRotationByGesture: true,
                staticPoints: [
                  StaticPositionGeoPoint(userRep, myUserIcon, [userLocation]),
                  StaticPositionGeoPoint(deliveryRep, deliveryLocationIcon, [deliveryLocation]),
                  StaticPositionGeoPoint(restaurantRep, restaurantLocationIcon, [restaurantLocation]),
                ],
                zoomOption: const ZoomOption(initZoom: 25, minZoomLevel: 3, maxZoomLevel: 19, stepZoom: 1.0),
                userLocationMarker: UserLocationMaker(
                  personMarker: const MarkerIcon(icon: Icon(Icons.location_history_rounded, color: Colors.red, size: 48)),
                  directionArrowMarker: const MarkerIcon(icon: Icon(Icons.double_arrow, size: 48)),
                ),
                roadConfiguration: const RoadOption(roadColor: Colors.yellowAccent),
              ),
            );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
