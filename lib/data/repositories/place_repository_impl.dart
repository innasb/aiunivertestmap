import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aiuniverstestmap/domain/repositories/place_repository.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  @override
  Future<String?> getPlaceName(double latitude, double longitude) async {
    final url = 'https://nominatim.openstreetmap.org/reverse?lat=$latitude&lon=$longitude&format=json';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['display_name'] as String?;
      }
    } catch (e) {
      // Handle errors as needed
    }
    return null;
  }
}
