import 'package:aiuniverstestmap/domain/entities/poi.dart'; // Ensure correct path
import 'package:aiuniverstestmap/domain/repositories/poi_repository.dart'; // Ensure correct path

class AddPOI {
  final POIRepository repository;

  AddPOI(this.repository);

  Future<void> call(POI poi) async {
    await repository.addPOI(poi);
  }
}
