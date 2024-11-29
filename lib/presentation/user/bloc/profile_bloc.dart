import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/domain/entities/user.dart';
import 'package:tomacare/service/user_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService userService = UserService();

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await userService.fetchUser();
        emit(ProfileLoaded(user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfile>((event, emit) async {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;

        final updatedUser = User(
          fullName: event.fullName ?? currentState.user["fullName"],
          username: event.username ?? currentState.user["username"],
          email: event.email ?? currentState.user["email"],
          profileImg: event.profileImg ?? currentState.user["profileImg"],
        );
        print(updatedUser);
        try {
          await userService.updateUser(updatedUser);
          add(LoadProfile());
        } catch (e) {
          emit(ProfileError(e.toString()));
        }
      }
    });
  }
}
