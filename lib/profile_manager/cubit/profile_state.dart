part of 'profile_cubit.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileListEmpty extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class ProfileLoaded extends ProfileState {
  final List<Profile> profileList;
  // final Profile? myProfile;

  const ProfileLoaded({
    required this.profileList,
    // required this.myProfile,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfileLoaded && listEquals(other.profileList, profileList);
  }

  @override
  int get hashCode => profileList.hashCode;
}
