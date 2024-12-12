part of 'information_bloc.dart';

sealed class InformationEvent extends Equatable {
  const InformationEvent();

  @override
  List<Object> get props => [];
}

final class getInformation extends InformationEvent {}

final class getInformationId extends InformationEvent {
  final int id;

  const getInformationId({required this.id});
}
