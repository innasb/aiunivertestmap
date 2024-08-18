// domain/usecases/search_pois.dart
import 'package:aiuniverstestmap/domain/repositories/poi_repository.dart';

import '../entities/poi.dart';

class SearchPOIs {
  final POIRepository repository;

  SearchPOIs(this.repository);

  Future<List<POI>> call(String query) async {
    return await repository.searchPOIs(query);
  }
}