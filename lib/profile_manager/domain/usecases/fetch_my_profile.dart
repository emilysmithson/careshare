import 'package:dartz/dartz.dart';

import '../errors/profile_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';

class FetchMyProfile {
  final ProfileRepository repository;

  FetchMyProfile(this.repository);
  Future<Either<ProfileException, Profile>> call() {

      Future<Either<ProfileException, Profile>> myProfile = repository.fetchMyProfile();
    return myProfile;

  }
}
