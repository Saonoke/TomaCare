import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tomacare/domain/entities/auth.dart';
// import 'package:tomacare/domain/entities/auth.dart';
import 'package:tomacare/service/auth_service.dart';
import 'package:tomacare/service/save_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();
  final SaveAuth saveService = SaveAuth();
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      final String? token = await saveService.getToken();
      if (token == null) {
        emit(AuthFailed('perlu login'));
      } else {
        emit(AuthSucess(token));
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
        print('Error terjadi: $e');
      }
    });

    on<LoginRequest>((event, emit) async {
      print('start auth bloc');
      try {
        final String? response = await authService.login(
            emailOrUsername: event.emailOrUsername, password: event.password);

        if (response != null) {
          saveService.storeToken(response);
          emit(AuthSucess(response));
        } else {
          emit(AuthFailed("gagal login"));
        }
      } catch (e) {
        print('Error terjadi login: $e');
      }
    });

    on<SignInWithGoogle>((event, emit) async {
      emit(AuthLoading(isLoading: true));
      final GoogleSignIn googleSignIn = GoogleSignIn();
      String? response;
      try {
        final account = await googleSignIn.signIn();
        if (account != null) {
          final GoogleSignInAuthentication auth = await account.authentication;
          final accessToken = auth.accessToken;
          if (accessToken != null){
            response = await authService.googleLogin(googleAccessToken: accessToken);
          }

          if (response != null) {
            saveService.storeToken(response);
            emit(AuthSucess(response));
          } else {
            emit(AuthFailed("gagal login"));
          }
        }
      } catch (e) {
        emit(AuthFailed("gagal login"));
      }
    },);
  }
}
