import 'package:aiuniverstestmap/presentation/blocs/prediction_state.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:aiuniverstestmap/domain/repositories/prediction_repository.dart'; // Ensure this uses Nominatim API

// part 'prediction_state.dart';
class PredictionCubit extends Cubit<PredictionState> {
  final PredictionRepository _repository;

  PredictionCubit(this._repository) : super(PredictionInitial());

  Future<void> fetchPredictions({
    required String query,
    required double latitude,
    required double longitude,
  }) async {
    try {
      emit(PredictionLoading());
      final predictions = await _repository.fetchPredictions(query, latitude, longitude);
      emit(PredictionLoaded(predictions)); // Pass the predictions list here
    } catch (e) {
      emit(PredictionError(e.toString())); // Pass the error message here
    }
  }
}
