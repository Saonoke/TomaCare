part of 'information_bloc.dart';

sealed class InformationState extends Equatable {
  const InformationState();
  
  @override
  List<Object> get props => [];
}

final class InformationInitial extends InformationState {}
