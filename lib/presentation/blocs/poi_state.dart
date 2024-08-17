import 'package:aiuniverstestmap/domain/entities/poi.dart';
import 'package:equatable/equatable.dart';

abstract class POIState extends Equatable {
  @override
  List<Object> get props => [];
}

class POILoading extends POIState {}

class POILoaded extends POIState {
  final List<POI> poiList;
  POILoaded({required this.poiList});

  @override
  List<Object> get props => [poiList];
}

class POIError extends POIState {
  final String message;
  POIError({required this.message});

  @override
  List<Object> get props => [message];
}
