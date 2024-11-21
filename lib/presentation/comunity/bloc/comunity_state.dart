part of 'comunity_bloc.dart';

sealed class ComunityState extends Equatable {
  const ComunityState();

  @override
  List<Object> get props => [];
}

final class ComunityInitial extends ComunityState {}

class ComunityLoading extends ComunityState {}

class ComunityLoaded extends ComunityState {
  final List<Map<String, dynamic>> posts;

  const ComunityLoaded(this.posts);
}

class ComunityPostLoaded extends ComunityState {
  final Map<String, dynamic> post;

  const ComunityPostLoaded(this.post);
}

class ComunityError extends ComunityState {
  final String message;

  const ComunityError(this.message);
}

class ComunityReactionSuccess extends ComunityState {}

class ComunityReactionFailed extends ComunityState {}