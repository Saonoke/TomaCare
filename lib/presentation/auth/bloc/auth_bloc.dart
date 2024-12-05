import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tomacare/domain/entities/auth.dart';
// import 'package:tomacare/domain/entities/auth.dart';
import 'package:tomacare/service/auth_service.dart';
import 'package:tomacare/service/save_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();
  final SaveAuth saveService = SaveAuth();
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      try {
        final String? token = await saveService.getToken();

        if (token == null) {
          print('null');
          emit(AuthFailed('perlu login'));
        } else {
          emit(AuthSucess(token));
        }
      } catch (e) {
        print(e.toString());
        emit(AuthFailed(e.toString()));
      }
    });

    on<Logout>((event, emit) async {
      saveService.deleteToken();
      emit(AuthFailed('logout'));
    });

    on<Register>((event, emit) async {
      print('start register');

      try {
        final Map<String, dynamic> response = await authService.register(
            email: event.email,
            fullname: event.fullname,
            username: event.username,
            password: event.password);

        add(LoginRequest(response['username'], response['password']));
      } catch (e) {
        emit(AuthFailed('gagal membuat user'));
      }
    });

    on<LoginRequest>((event, emit) async {
      emit(AuthLoading(isLoading: true));
      try {
        final Map<String, dynamic> response = await authService.login(
            emailOrUsername: event.emailOrUsername, password: event.password);
        saveService.storeToken(response);
        emit(AuthSucess(response['access_token']));
      } catch (e) {
        emit(AuthFailed("gagal login"));
      }
    });
  }
}
