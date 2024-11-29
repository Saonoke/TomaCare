import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tomacare/domain/entities/information.dart';
import 'package:tomacare/service/cloudinary.dart';
import 'package:tomacare/service/information_service.dart';
import 'package:tomacare/service/machine_learning_service.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final MachineLearningService machineLearningService =
      MachineLearningService();
  final InformationService informationService = InformationService();
  final Cloudinary cloudinary = Cloudinary();
  CameraBloc() : super(CameraInitial()) {
    on<CameraProcess>((event, emit) async {
      emit(CameraLoading());
      try {
        final Map<String, dynamic> result =
            await machineLearningService.machineLearningProcess(event.image);
        if (result['percentage'] == 0.0) {
          emit(CameraFailed(message: result['predicted_class']));
        } else {
          final Information information = await informationService
              .getInformation(result['predicted_index']);

          emit(CameraTaken(
              file: event.image,
              predictedClass: result['predicted_class'],
              percentage: result['percentage'],
              information: information));
        }
      } catch (e) {
        emit(CameraFailed(message: e.toString()));
      }
    });
  }
}
