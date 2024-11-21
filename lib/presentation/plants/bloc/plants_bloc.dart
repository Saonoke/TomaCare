import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tomacare/domain/entities/plant.dart';
import 'package:tomacare/service/Plant_service.dart';

part 'plants_event.dart';
part 'plants_state.dart';

class PlantsBloc extends Bloc<PlantsEvent, PlantsState> {
  final PlantService plantService = PlantService();
  PlantsBloc() : super(PlantsInitial()) {
    on<PlantsRequest>((event, emit) async {
      emit(PlantsLoading());
      try {
        print('fetchingg .... ');
        final List<Plant> response = await plantService.getPlants();
        print(response);
        emit(PlantsSuccess(plants: response));
      } catch (e) {
        print(e);
        emit(PlantsFailed(message: 'error cok'));
      }
    });

    on<PlantRequestById>((event, emit) async {
      emit(PlantsLoading());
      try {
        final Plant plant = await plantService.getPlant(id: event.id);

        if (state is PlantsSuccess) {
          final currentState = state as PlantsSuccess;
          emit(PlantsSuccess(plants: currentState.plants, plant: plant));
        }
      } catch (e) {
        emit(PlantsFailed(message: 'error cok dancok'));
      }
    });

    on<PlantsCreate>((event, emit) async {
      try {
        final Plant plant = await plantService.createPlant(plant: event.plant);

        emit(PlantsMessage(message: 'berhasil ditambah', plant: plant));
      } catch (e) {
        emit(PlantsFailed(message: 'error cokk'));
      }
    });
  }
}
