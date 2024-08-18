import 'package:aiuniverstestmap/domain/entities/location.dart';
import 'package:aiuniverstestmap/domain/use_cases/get_route.dart';
import 'package:aiuniverstestmap/presentation/blocs/route_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteCubit extends Cubit<RouteState> {
  final GetRouteUseCase getRoute;

  RouteCubit(this.getRoute) : super(RouteInitial());

  Future<void> fetchRoute(Location start, Location destination) async {
    emit(RouteLoading());
    try {
      // Here, the route should be of type List<Location> (from your custom Location class)
      final List<Location> route = await getRoute(start, destination);
      emit(RouteLoaded(route));
    } catch (e) {
      emit(RouteError(e.toString()));
    }
  }
}
