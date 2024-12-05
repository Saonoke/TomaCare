part of 'plants_bloc.dart';

sealed class PlantsState extends Equatable {
  const PlantsState();

  @override
  List<Object> get props => [];
}

final class PlantsInitial extends PlantsState {}

final class PlantsLoading extends PlantsState {
  const PlantsLoading();

  @override
  List<Object> get props => [];
}

final class PlantsSuccess extends PlantsState {
  final List<Plant> plants;
  final List<Task>? tasks;

  const PlantsSuccess({required this.plants, this.tasks});

  @override
  List<Object> get props => [plants];
}

final class PlantsFailed extends PlantsState {
  final String message;

  const PlantsFailed({required this.message});

  @override
  List<Object> get props => [message];
}

final class PlantsMessage extends PlantsState {
  final String message;
  final Plant plant;
  const PlantsMessage({required this.message, required this.plant});

  @override
  List<Object> get props => [message];
}
