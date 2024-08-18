import 'package:geolocator/geolocator.dart';

class FetchRoute {
  Future<String> call(Position start, Position end) async {
    // Example implementation; replace with actual logic or API call
    try {
      // Simulate fetching route (you should replace this with real logic)
      await Future.delayed(Duration(seconds: 2));
      return 'Route from ${start.latitude},${start.longitude} to ${end.latitude},${end.longitude}';
    } catch (e) {
      throw Exception('Failed to fetch route: $e');
    }
  }
}
