part of 'camera_bloc.dart';

sealed class CameraEvent extends Equatable {
  const CameraEvent();

  @override
  List<Object> get props => [];
}

class CameraProcess extends CameraEvent {
  final XFile? image;

  const CameraProcess({required this.image});
  @override
  List<XFile> get props => [image!];
}
