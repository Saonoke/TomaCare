import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/domain/entities/task.dart';
import 'package:tomacare/presentation/auth/bloc/auth_bloc.dart';
import 'package:tomacare/service/Plant_service.dart';
import 'package:tomacare/service/save_auth.dart';
import 'package:tomacare/utils/exceptions/unathorized_exception.dart';

part 'plants_event.dart';
part 'plants_state.dart';

class PlantsBloc extends Bloc<PlantsEvent, PlantsState> {
  final PlantService plantService = PlantService();
  PlantsBloc() : super(PlantsInitial()) {
    on<PlantsRequest>((event, emit) async {
      emit(PlantsLoading());
      await Future.delayed(Duration(seconds: 3));
      try {
        final List<Plant> response = await plantService.getPlants();
        final String? token = await SaveAuth().getToken();
        final String username = JwtDecoder.decode(token!)['username'];
        final Map<String, dynamic> status =
            await plantService.getStatusCount(plants: response);

        emit(PlantsSuccess(
            plants: response, status: status, username: username));
      } on UnathorizedException {
        // emit(AuthFailed('harus login'));
        print('unathorized');
      } catch (e) {
        emit(PlantsFailed(message: 'error cok'));
      }
    });

    on<PlantRequestById>((event, emit) async {
      emit(PlantsLoading());

      try {
        final Plant plant = await plantService.getPlant(id: event.id);

        emit(PlantsSuccess(plants: [plant]));
      } catch (e) {
        emit(PlantsFailed(message: 'error cok dancok'));
      }
    });

    on<PlantsCreate>((event, emit) async {
      try {
        emit(PlantsLoading());
        await Future.delayed(Duration(seconds: 3));
        final Plant plant = await plantService.createPlant(plant: event.plant);

        emit(PlantsMessage(message: 'berhasil ditambah', plant: plant));
      } catch (e) {
        emit(PlantsFailed(message: 'error cokk'));
      }
    });
  }
}
