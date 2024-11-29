part of 'camera_bloc.dart';

sealed class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

final class CameraInitial extends CameraState {}

final class CameraLoading extends CameraState {}

final class CameraTaken extends CameraState {
  final XFile? file;
  final String predictedClass;
  final double percentage;
  final Information information;

  const CameraTaken(
      {required this.file,
      required this.predictedClass,
      required this.percentage,
      required this.information});
  @override
  List<Object> get props => [file!.path, predictedClass, percentage];
}

final class CameraFailed extends CameraState {
  final String message;

  const CameraFailed({required this.message});
  @override
  List<Object> get props => [message];
}
