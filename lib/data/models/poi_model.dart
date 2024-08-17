import 'package:google_maps_flutter/google_maps_flutter.dart';

class POIModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  POIModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory POIModel.fromMap(Map<String, dynamic> map) {
    return POIModel(
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
    return 'POIModel(id: $id, name: $name, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is POIModel &&
        other.id == id &&
        other.name == name &&
        other.latitude == latitude &&
        other.longitude == longitude;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ latitude.hashCode ^ longitude.hashCode;
  }

  POIModel toEntity() {
    return POIModel(
      id: id,
      name: name,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
