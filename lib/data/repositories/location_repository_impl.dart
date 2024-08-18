import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aiuniverstestmap/domain/repositories/location_repository.dart';
import 'package:http/http.dart' as http;


class LocationRepositoryImpl implements LocationRepository {
  LatLng? _selectedLocation;

  @override
  LatLng? getSelectedLocation() => _selectedLocation;

  @override
  void saveSelectedLocation(LatLng location) {
    _selectedLocation = location;
  }

  @override
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Future<LatLng> getCurrentLocationAsLatLng() async {
    final position = await getCurrentLocation();
    return LatLng(position.latitude, position.longitude);
  }

  @override
  Future<String?> getPlaceName(double latitude, double longitude) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] as String?;
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching place name: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchRoute(LatLng start, LatLng end) async {
    final url = 'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?geometries=geojson';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'] as List;
      final duration = data['routes'][0]['duration']; // Duration in seconds

      final points = route.map((point) => LatLng(point[1], point[0])).toList();

      return {
        'points': points,
        'duration': duration, // Duration in seconds
      };
    } else {
      throw Exception('Failed to load route');
    }
  }
}
