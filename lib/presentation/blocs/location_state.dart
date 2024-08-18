part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationLoaded extends LocationState {
  final Position location;

  LocationLoaded(this.location);

  @override
  List<Object?> get props => [location];
}

class RouteLoaded extends LocationState {
  final String route;

  RouteLoaded(this.route);

  @override
  List<Object?> get props => [route];
}

class PlaceNameLoaded extends LocationState {
  final String placeName;

  PlaceNameLoaded(this.placeName);

  @override
  List<Object?> get props => [placeName];
}

class LocationError extends LocationState {
  final String message;

   LocationError(this.message);

  @override
  List<Object> get props => [message];
}
