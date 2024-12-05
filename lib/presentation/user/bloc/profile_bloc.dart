import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tomacare/domain/entities/user.dart';
import 'package:tomacare/service/user_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserService userService = UserService();

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadPersonalMenu>((event, emit) async {
      emit(PersonalMenuLoading());
      try {
        final user = await userService.fetchUser();
        emit(PersonalMenuLoaded(user));
      } catch (e) {
        emit(PersonalMenuError(e.toString()));
      }
    });

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
        try {
          await userService.updateUser(updatedUser, event.updatedProfileImage);
          add(LoadProfile());
        } catch (e) {
          emit(ProfileError(e.toString()));
        }
      }
    });

    on<ChangePassword>((event, emit) async {
      emit(PasswordLoading());
      try {
        final res = await userService.changePassword(event.newPassword, event.oldPassword);
        emit(PasswordSuccess());
      } catch (e) {
        emit(PasswordError(e.toString()));
      }
    });

    on<CreatePassword>((event, emit) async {
      emit(PasswordLoading());
      try {
        await userService.createPassword(event.password);
        emit(PasswordSuccess());
      } catch (e) {
        emit(PasswordError(e.toString()));
      }
    });
  }
}
