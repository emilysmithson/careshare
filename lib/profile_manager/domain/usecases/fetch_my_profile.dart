import 'package:dartz/dartz.dart';

import '../errors/profile_manager_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';

class FetchMyProfile {
  final ProfileRepository repository;

  FetchMyProfile(this.repository);
  Future<Either<ProfileManagerException, Profile>> call() {

      Future<Either<ProfileManagerException, Profile>> myProfile = repository.fetchMyProfile();
    return myProfile;

  }
}
