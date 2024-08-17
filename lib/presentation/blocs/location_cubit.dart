import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/use_cases/get_current_location.dart';

part 'location_state.dart'; // Ensure this file is part of the same library

class LocationCubit extends Cubit<LocationState> {
  final GetCurrentLocation getCurrentLocation;

  LocationCubit(this.getCurrentLocation) : super(LocationInitial());

  Future<void> fetchCurrentLocation() async {
    emit(LocationLoading());
    try {
      final position = await getCurrentLocation();
      emit(LocationLoaded(position));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
