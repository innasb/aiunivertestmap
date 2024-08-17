import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aiuniverstestmap/domain/repositories/location_repository.dart';

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

  Future<LatLng> getCurrentLocationAsLatLng() async {
    final position = await getCurrentLocation();
    return LatLng(position.latitude, position.longitude);
  }
}
