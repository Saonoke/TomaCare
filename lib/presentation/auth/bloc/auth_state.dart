part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {
  final bool isLoading;

  const AuthLoading({required this.isLoading});

  @override
  List<Object> get props => [isLoading];
}

final class AuthSucess extends AuthState {
  final String token;

  const AuthSucess(this.token);

  @override
  List<Object> get props => [token];
}

final class AuthFailed extends AuthState {
  final String errorMessage;

  const AuthFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
