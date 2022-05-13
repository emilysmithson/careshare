part of 'all_profiles_cubit.dart';

abstract class AllProfilesState extends Equatable {
  const AllProfilesState();

  @override
  List<Object> get props => [];
}

class AllProfilesInitial extends AllProfilesState {}


// AllProfiles
class AllProfilesLoading extends AllProfilesState {
  const AllProfilesLoading();
}

class AllProfilesError extends AllProfilesState {
  final String message;

  const AllProfilesError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AllProfilesError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

// Profiles

class ProfileListEmpty extends AllProfilesState {}


class ProfilesError extends AllProfilesState {
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


class AllProfilesLoaded extends AllProfilesState {
  final List<Profile> profileList;

  const AllProfilesLoaded({
    required this.profileList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AllProfilesLoaded && listEquals(other.profileList, profileList);
  }

  @override
  int get hashCode => profileList.hashCode;
}


