import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tomacare/domain/entities/task.dart';
import 'package:tomacare/service/task_service.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TaskService taskService = TaskService();
  TasksBloc() : super(TasksInitial()) {
    on<updateTask>((event, emit) async {
      print("haaaaaaaaaaaaaaaaaaaaaaaaaa");
      try {
        emit(TasksLoading());
        final Task response = await taskService.updatePost(
            task: event.task, plantId: event.plantId);
        emit(TasksSuccess(task: response));
      } catch (e) {
        print(e);
        emit(TasksFailed(message: 'error'));
      }
    });
  }
}
