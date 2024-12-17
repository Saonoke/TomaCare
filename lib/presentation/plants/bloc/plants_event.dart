part of 'plants_bloc.dart';

sealed class PlantsEvent extends Equatable {
  const PlantsEvent();

  @override
  List<Object> get props => [];
}

class PlantsRequest extends PlantsEvent {}

class PlantsCreate extends PlantsEvent {
  final Plant plant;

  const PlantsCreate({required this.plant});

  @override
  List<Object> get props => [plant];
}

class PlantRequestById extends PlantsEvent {
  final int id;

  const PlantRequestById({required this.id});

  @override
  List<Object> get props => [id];
}

class PlantEdit extends PlantsEvent {
  final int id;
  final String title;

  const PlantEdit({required this.id, required this.title});

  @override
  List<Object> get props => [id, title];
}

class PlantDelete extends PlantsEvent {
  final int id;

  const PlantDelete({required this.id});

  @override
  List<Object> get props => [id];
}
