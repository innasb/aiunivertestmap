// lib/domain/usecases/get_place_name_use_case.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class GetPlaceNameUseCase {
  Future<String?> call(double latitude, double longitude) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] as String?;
      } else {
        throw Exception('Failed to fetch place name');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class GetPlaceName {
  Future<String> call(Position location) async {
    // Example implementation; replace with actual logic or API call
    try {
      // Simulate getting place name (you should replace this with real logic)
      await Future.delayed(Duration(seconds: 2));
      return 'Place name for ${location.latitude},${location.longitude}';
    } catch (e) {
      throw Exception('Failed to get place name: $e');
    }
  }
}
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