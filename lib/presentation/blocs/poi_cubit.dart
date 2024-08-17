import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:aiuniverstestmap/domain/entities/poi.dart';
import 'package:aiuniverstestmap/domain/repositories/poi_repository.dart';
import 'poi_state.dart';

class POICubit extends Cubit<POIState> {
  final POIRepository _poiRepository;

  POICubit(this._poiRepository) : super(POILoading()) {
    _loadPOIs();
  }

  Future<void> _loadPOIs() async {
    try {
      final pois = await _poiRepository.getPOIs();
      emit(POILoaded(poiList: pois));
    } catch (e) {
      emit(POIError(message: 'Failed to load POIs: ${e.toString()}'));
    }
  }

  Future<void> addPOI(POI poi) async {
    try {
      emit(POILoading());
      await _poiRepository.addPOI(poi);
      _loadPOIs(); // Reload POIs after adding a new one
    } catch (e) {
      emit(POIError(message: 'Failed to add POI: ${e.toString()}'));
    }
  }
}
