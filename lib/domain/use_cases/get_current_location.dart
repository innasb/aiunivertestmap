import 'package:aiuniverstestmap/domain/repositories/location_repository.dart';
import 'package:geolocator/geolocator.dart';

class GetCurrentLocation {
  final LocationRepository repository;

  GetCurrentLocation(this.repository);

  Future<Position> call() async {
    return await repository.getCurrentLocation();
  }
}
