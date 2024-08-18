// data/repositories/route_repository_impl.dart
import 'package:aiuniverstestmap/data/data_sources/route_data_source.dart';
import 'package:aiuniverstestmap/domain/entities/location.dart';
import 'package:aiuniverstestmap/domain/repositories/route_repository.dart';

class RouteRepositoryImpl implements RouteRepository {
  final RouteDataSource dataSource;

  RouteRepositoryImpl(this.dataSource);

  @override
  Future<List<Location>> getRoute(Location start, Location destination) {
    return dataSource.getRoute(start, destination);
  }
}
