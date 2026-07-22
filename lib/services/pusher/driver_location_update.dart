/// Payload from Pusher `driver-location-update` on `driver-live-tracking-{order_id}`.
class DriverLocationUpdate {
  final String orderId;
  final String driverId;
  final double lat;
  final double lon;

  const DriverLocationUpdate({
    required this.orderId,
    required this.driverId,
    required this.lat,
    required this.lon,
  });
}
