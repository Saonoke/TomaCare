part of 'tasks_bloc.dart';

sealed class TasksEvent extends Equatable {
  const TasksEvent();

  @override
  List<Object> get props => [];
}

final class getTasks extends TasksEvent {
  final String tanggal;
  final List task;

  const getTasks({required this.tanggal, required this.task});

  @override
  List<Object> get props => [tanggal];
}
