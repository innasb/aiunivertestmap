abstract class PredictionRepository {
  Future<List<Map<String, dynamic>>> fetchPredictions(String query, double latitude, double longitude);
  Future<String?> getPlaceName(double latitude, double longitude);
}
