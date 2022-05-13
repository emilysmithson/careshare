part of 'my_profile_cubit.dart';

abstract class MyProfileState extends Equatable {
  const MyProfileState();

  @override
  List<Object> get props => [];
}

class MyProfileInitial extends MyProfileState {}


// MyProfile
class MyProfileLoading extends MyProfileState {
  const MyProfileLoading();
}

class MyProfileLoaded extends MyProfileState {
  final Profile? myProfile;

  const MyProfileLoaded({
    required this.myProfile,
  });
}

class MyProfileError extends MyProfileState {
  final String message;

  const MyProfileError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyProfileError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

// Profiles
class ProfilesLoading extends MyProfileState {
  const ProfilesLoading();
}

class ProfileListEmpty extends MyProfileState {}


class ProfilesError extends MyProfileState {
  final String message;

  const ProfilesError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfilesError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}


class ProfilesLoaded extends MyProfileState {
  final List<Profile> profileList;

  const ProfilesLoaded({
    required this.profileList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfilesLoaded && listEquals(other.profileList, profileList);
  }

  @override
  int get hashCode => profileList.hashCode;
}


