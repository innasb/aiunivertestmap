import 'package:aiuniverstestmap/domain/entities/location.dart';

abstract class RouteRepository {
  Future<List<Location>> getRoute(Location start, Location destination);
}