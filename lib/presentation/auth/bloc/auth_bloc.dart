import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
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
      try {
        final String? token = await saveService.getToken();

        if (token == null) {
          emit(AuthFailed('perlu login'));
        } else {
          emit(AuthSucess(token));
        }
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<Logout>((event, emit) async {
      emit(AuthLoading(isLoading: true));
      try {
        final String? token = await saveService.getToken();

        final res = await authService.logout(token!);
        if (res['success']) {
          saveService.deleteToken();
          emit(AuthFailed('logout'));
        }
        emit(AuthFailed("Gagal Logout!"));
      } catch (e) {
        emit(AuthFailed(e.toString()));
      }
    });

    on<Register>((event, emit) async {
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

    on<SignInWithGoogle>(
      (event, emit) async {
        emit(AuthLoading(isLoading: true));
        final GoogleSignIn googleSignIn = GoogleSignIn();

        try {
          final account = await googleSignIn.signIn();
          if (account != null) {
            final GoogleSignInAuthentication auth =
                await account.authentication;
            final accessToken = auth.accessToken;
            if (accessToken != null) {
              final response =
                  await authService.googleLogin(googleAccessToken: accessToken);
              saveService.storeToken(response);
              emit(AuthSucess(response['access_token']));
            } else {
              emit(AuthFailed("gagal login"));
            }
          }
        } catch (e) {
          emit(AuthFailed("gagal login"));
        }
      },
    );
  }
}
