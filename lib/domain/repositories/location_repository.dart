import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class LocationRepository {
  LatLng? getSelectedLocation();
  void saveSelectedLocation(LatLng location);
  Future<Position> getCurrentLocation();

  Future<String?> getPlaceName(double latitude, double longitude);
  Future<Map<String, dynamic>> fetchRoute(LatLng start, LatLng end);
}
