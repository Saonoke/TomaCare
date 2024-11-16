import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
// import 'package:tomacare/domain/entities/auth.dart';
import 'package:tomacare/service/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService = AuthService();
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequest>((event, emit) async {
      print('start auth bloc');
      final String? response = await authService.login(
          emailOrUsername: event.emailOrUsername, password: event.password);
      print(response);
      if (response != null) {
        emit(AuthSucess(response));
      } else {
        emit(AuthFailed("gaggal login"));
      }
    });
  }
}
