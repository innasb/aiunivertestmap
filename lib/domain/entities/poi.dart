import 'package:google_maps_flutter/google_maps_flutter.dart';

class POI {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  POI({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  })  : assert(latitude >= -90.0 && latitude <= 90.0, 'Latitude must be between -90 and 90'),
        assert(longitude >= -180.0 && longitude <= 180.0, 'Longitude must be between -180 and 180');

  factory POI.fromMap(Map<String, dynamic> map) {
    if (map['id'] == null || map['name'] == null || map['latitude'] == null || map['longitude'] == null) {
      throw ArgumentError('Invalid map: missing required fields');
    }

    return POI(
      id: map['id'] as String,
      name: map['name'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

  @override
  String toString() {
    return 'POI(id: $id, name: $name, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is POI &&
        other.id == id &&
        other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
  }
}
