// route_state.dart
import 'package:aiuniverstestmap/domain/entities/location.dart';  // Correct import

abstract class RouteState {}

class RouteInitial extends RouteState {}

class RouteLoading extends RouteState {}

class RouteLoaded extends RouteState {
  final List<Location> route;  // Custom Location class
  RouteLoaded(this.route);
}

class RouteError extends RouteState {
  final String message;
  RouteError(this.message);
}
