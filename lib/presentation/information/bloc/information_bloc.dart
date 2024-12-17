import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tomacare/domain/entities/information.dart';
import 'package:tomacare/service/information_service.dart';

part 'information_event.dart';
part 'information_state.dart';

class InformationBloc extends Bloc<InformationEvent, InformationState> {
  InformationBloc() : super(InformationInitial()) {
    final InformationService informationService = InformationService();
    on<getInformationId>((event, emit) async {
      emit(InformationLoading());

      try {
        final Information response =
            await informationService.getInformation(event.id);
        emit(InformationSuccess(informations: [response]));
      } catch (e) {
        emit(InformationFailed(message: 'error'));
      }
    });

    on<getInformation>((event, emit) async {
      emit(InformationLoading());
      await Future.delayed(Duration(seconds: 3));
      try {
        final List<Information> response =
            await informationService.getInformationAll();
        emit(InformationSuccess(informations: response));
      } catch (e) {
        emit(InformationFailed(message: e.toString()));
      }
    });
  }
}
