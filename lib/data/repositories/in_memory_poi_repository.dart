import 'package:aiuniverstestmap/domain/entities/poi.dart';
import 'package:aiuniverstestmap/domain/repositories/poi_repository.dart';

// class InMemoryPOIRepository implements POIRepository {
//   final List<POI> _poiList = [];
//
//   @override
//   Future<void> addPOI(POI poi) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     _poiList.add(poi);
//   }
//
//   @override
//   Future<List<POI>> getPOIs() async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return List.unmodifiable(_poiList);
//   }
// }
