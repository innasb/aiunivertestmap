// domain/use_cases/fetch_and_reverse_geocode_prediction.dart
import 'package:aiuniverstestmap/domain/repositories/prediction_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FetchAndReverseGeocodePrediction {
  final PredictionRepository repository;

  FetchAndReverseGeocodePrediction(this.repository);

  Future<LatLng> call(String query, LatLng currentLocation) async {
    final predictions = await repository.fetchPredictions(
        query, currentLocation.latitude, currentLocation.longitude);

    if (predictions.isNotEmpty) {
      final lat = predictions.first['latitude'];
      final lon = predictions.first['longitude'];
      return LatLng(lat, lon);
    } else {
      throw Exception("No predictions found");
    }
  }
}
