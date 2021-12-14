import 'package:dartz/dartz.dart';

import '../errors/profile_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';

class FetchProfiles {
  final ProfileRepository repository;

  FetchProfiles(this.repository);
  Future<Either<ProfileException, List<Profile>>> call() {
    return repository.fetchProfiles();
  }
}
