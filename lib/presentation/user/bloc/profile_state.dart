import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> user;
  final String? message;
  const ProfileLoaded(this.user, {this.message});
}

class ProfileLoading extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);
}

final class PasswordLoading extends ProfileState {}

final class PasswordSuccess extends ProfileState {}

final class PasswordError extends ProfileState {
  final String error;
  const PasswordError(this.error);
}

final class PersonalMenuLoading extends ProfileState {}

final class PersonalMenuError extends ProfileState {
    final String error;
  const PersonalMenuError(this.error);
}

final class PersonalMenuLoaded extends ProfileState {
  final Map<String, dynamic> user;

  const PersonalMenuLoaded(this.user);
}
