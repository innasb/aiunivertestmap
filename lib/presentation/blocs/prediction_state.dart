import 'package:equatable/equatable.dart';

abstract class PredictionState extends Equatable {
  const PredictionState();

  @override
  List<Object> get props => [];
}

class PredictionInitial extends PredictionState {}

class PredictionLoading extends PredictionState {}

class PredictionLoaded extends PredictionState {
  final List<Map<String, dynamic>> predictions;

  const PredictionLoaded(this.predictions);

  @override
  List<Object> get props => [predictions];
}

class PredictionError extends PredictionState {
  final String message;

  const PredictionError(this.message);

  @override
  List<Object> get props => [message];
}
