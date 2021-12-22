import 'package:dartz/dartz.dart';

import '../errors/profile_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';

class FetchAProfile {
  final ProfileRepository repository;

  FetchAProfile(this.repository);
  Future<Either<ProfileException, Profile>> call(id) {
    return repository.fetchAProfile(id);
  }
}
