import 'package:dartz/dartz.dart';

import '../errors/profile_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';

class CreateProfile {
  final ProfileRepository repository;

  CreateProfile(this.repository);
  Future<Either<ProfileException, Profile>> call() {
    return repository.createProfile();
  }
}
