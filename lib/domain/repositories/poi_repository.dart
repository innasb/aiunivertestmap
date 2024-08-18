import 'package:aiuniverstestmap/domain/entities/poi.dart';

abstract class POIRepository {
  Future<void> addPOI(POI poi);
  Future<List<POI>> getPOIs();
  Future<List<POI>> searchPOIs(String query);
}
