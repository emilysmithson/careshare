import 'package:dartz/dartz.dart';

import '../errors/profile_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';

class FetchAllProfiles {
  final ProfileRepository repository;

  FetchAllProfiles(this.repository);
  Future<Either<ProfileException, List<Profile>>> call() {
    return repository.fetchProfiles();
  }
}

class FetchAProfile {
  final ProfileRepository repository;

  FetchAProfile(this.repository);
  Future<Either<ProfileException, Profile>> call(String id) {
    return repository.fetchAProfile(id);
  }
}