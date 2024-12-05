part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class LoginRequest extends AuthEvent {
  final String emailOrUsername;
  final String password;

  const LoginRequest(this.emailOrUsername, this.password);

  @override
  List<Object> get props => [emailOrUsername, password];
}

class Logout extends AuthEvent {
  const Logout();
}

class Register extends AuthEvent {
  final String email;
  final String fullname;
  final String username;
  final String password;

  const Register(this.email, this.fullname, this.username, this.password);

  @override
  List<Object> get props => [email, password, fullname, username];
}

class SignInWithGoogle extends AuthEvent {

}