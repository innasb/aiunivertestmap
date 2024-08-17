import 'package:aiuniverstestmap/domain/entities/poi.dart'; // Ensure correct path
import 'package:aiuniverstestmap/domain/repositories/poi_repository.dart'; // Ensure correct path

class GetPOIs {
  final POIRepository repository;

  GetPOIs(this.repository);

  Future<List<POI>> call() async {
    return await repository.getPOIs();
  }
}
