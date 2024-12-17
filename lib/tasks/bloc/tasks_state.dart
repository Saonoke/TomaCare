part of 'tasks_bloc.dart';

sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object> get props => [];
}

final class TasksInitial extends TasksState {}

final class TasksLoading extends TasksState {}

final class TasksSuccess extends TasksState {
  final Task task;

  const TasksSuccess({required this.task});

  @override
  List<Object> get props => [task];
}

final class TasksFailed extends TasksState {
  final String message;

  const TasksFailed({required this.message});
}
