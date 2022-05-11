part of 'my_profile_cubit.dart';

abstract class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List<Object> get props => [];
}

class MyProfileInitial extends MyProfileState {}

class MyProfileLoading extends MyProfileState {}

class MyProfileError extends MyProfileState {
  final String message;

  const MyProfileError({required this.message});
}

class MyProfileLoaded extends MyProfileState {
  final Profile myProfile;

  const MyProfileLoaded({required this.myProfile});
}
