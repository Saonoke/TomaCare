part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {
  const AuthEvent();

  List<Object> get props => [];
}

class LoginRequest extends AuthEvent {
  final String emailOrUsername;
  final String password;

  const LoginRequest(this.emailOrUsername, this.password);

  @override
  List<Object> get props => [emailOrUsername, password];
}
