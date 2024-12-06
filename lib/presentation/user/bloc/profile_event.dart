import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String? fullName;
  final String? username;
  final String? email;
  final String? profileImg;
  final XFile? updatedProfileImage;

  const UpdateProfile(
      {this.fullName, this.username, this.email, this.profileImg, this.updatedProfileImage});

  @override
  List<Object?> get props => [fullName, username, email, profileImg];
}

class LoadPersonalMenu extends ProfileEvent {

}

class MyComunityStarted extends ProfileEvent {
  final int userId;

  const MyComunityStarted(this.userId);

  @override
  List<Object> get props => [userId];
}

class ChangePassword extends ProfileEvent {
  final String? oldPassword;
  final String? newPassword;

  const ChangePassword({this.oldPassword, this.newPassword});
  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class CreatePassword extends ProfileEvent {
  final String? password;

  const CreatePassword({this.password});
  @override
  List<Object?> get props => [password];
}
