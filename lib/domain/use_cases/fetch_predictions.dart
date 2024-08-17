// lib/domain/use_cases/fetch_predictions.dart
import '../repositories/prediction_repository.dart';

class FetchPredictions {
  final PredictionRepository repository;

  FetchPredictions(this.repository);

  Future<List<Map<String, dynamic>>> call(String query, double latitude, double longitude) {
    return repository.fetchPredictions(query, latitude, longitude);
  }
}
