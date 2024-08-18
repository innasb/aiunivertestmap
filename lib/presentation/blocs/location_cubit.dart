import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/use_cases/get_current_location.dart';
import '../../domain/use_cases/fetch_route.dart'; // Ensure this file exists
import '../../domain/use_cases/get_place_name_use_case.dart'; // Ensure this file exists

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final FetchRoute fetchRouteUseCase;
  final GetPlaceName getPlaceNameUseCase;

  LocationCubit(
      this.getCurrentLocation,
      this.fetchRouteUseCase,
      this.getPlaceNameUseCase,
      ) : super(LocationInitial());

  Future<void> fetchCurrentLocation() async {
    emit(LocationLoading());
    try {
      final location = await getCurrentLocation();
      emit(LocationLoaded(location));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> fetchRoute(Position start, Position end) async {
    emit(LocationLoading());
    try {
      final route = await fetchRouteUseCase(start, end);
      emit(RouteLoaded(route));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> getPlaceName(Position location) async {
    emit(LocationLoading());
    try {
      final placeName = await getPlaceNameUseCase(location);
      emit(PlaceNameLoaded(placeName));
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }
}
