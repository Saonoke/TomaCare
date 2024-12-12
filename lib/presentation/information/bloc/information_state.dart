part of 'information_bloc.dart';

sealed class InformationState extends Equatable {
  const InformationState();

  @override
  List<Object> get props => [];
}

final class InformationInitial extends InformationState {}

final class InformationLoading extends InformationState {}

final class InformationSuccess extends InformationState {
  final List<Information> informations;

  const InformationSuccess({required this.informations});

  @override
  List<Object> get props => [informations];
}

final class InformationFailed extends InformationState {
  final String message;

  const InformationFailed({required this.message});

  @override
  List<Object> get props => [message];
}
