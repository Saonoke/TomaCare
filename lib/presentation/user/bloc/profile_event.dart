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
  const UpdateProfile(
      {this.fullName, this.username, this.email, this.profileImg});

  @override
  List<Object?> get props => [fullName, username, email, profileImg];
}
