import 'package:aiuniverstestmap/domain/entities/location.dart';
import 'package:aiuniverstestmap/domain/repositories/route_repository.dart';

class GetRouteUseCase {
  final RouteRepository repository;

  GetRouteUseCase(this.repository);

  Future<List<Location>> call(Location start, Location end) async {
    return await repository.getRoute(start, end);
  }
}