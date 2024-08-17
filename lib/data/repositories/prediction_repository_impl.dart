import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/repositories/prediction_repository.dart';

class PredictionRepositoryImpl implements PredictionRepository {
  @override
  Future<List<Map<String, dynamic>>> fetchPredictions(String query, double latitude, double longitude) async {
    final url = 'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Map<String, dynamic>>((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  @override
  Future<String> getPlaceName(double latitude, double longitude) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json&addressdetails=1';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final address = data['address'] as Map<String, dynamic>;
      final placeName = address['road'] ?? address['suburb'] ?? address['city'] ?? address['state'] ?? address['country'] ?? 'Unknown place';
      return placeName;
    } else {
      throw Exception('Failed to load place name');
    }
  }
}
