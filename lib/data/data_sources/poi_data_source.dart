// data/datasources/poi_data_source.dart
import 'dart:convert';
import 'package:aiuniverstestmap/domain/entities/poi.dart';
import 'package:http/http.dart' as http;
import 'package:aiuniverstestmap/domain/entities/poi.dart';

class POIDataSource {
  final String _overpassUrl = 'https://overpass-api.de/api/interpreter';

  Future<List<POI>> searchPOIs(String query) async {
    // Construct the Overpass API query
    final queryString = '''
    [out:json];
    area[name="$query"]->.searchArea;
    (
      node["amenity"](area.searchArea);
      way["amenity"](area.searchArea);
      relation["amenity"](area.searchArea);
    );
    out body;
    ''';

    final response = await http.post(
      Uri.parse(_overpassUrl),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'data': queryString},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Parse the OSM data
      final List<POI> pois = [];
      final elements = data['elements'] as List;

      for (var element in elements) {
        if (element['type'] == 'node') {
          pois.add(
            POI(
              name: element['tags']['name'] ?? 'Unknown',
              latitude: element['lat'].toDouble(),
              longitude: element['lon'].toDouble(),
              id: '',

            ),
          );
        }
      }
      return pois;
    } else {
      throw Exception('Failed to load POIs');
    }
  }
}
