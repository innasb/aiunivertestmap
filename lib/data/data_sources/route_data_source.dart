// lib/data/datasources/route_data_source.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aiuniverstestmap/domain/entities/location.dart';

class RouteDataSource {
  Future<List<Location>> getRoute(Location start, Location destination) async {
    final url = 'http://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?geometries=geojson';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'] as List;

      return route.map((point) => Location(
        latitude: point[1],
        longitude: point[0],
      )).toList();
    } else {
      throw Exception('Failed to load route');
    }
  }
}
