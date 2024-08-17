// lib/domain/usecases/get_place_name_use_case.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

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
