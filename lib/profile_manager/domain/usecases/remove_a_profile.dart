import 'package:careshare/profile_manager/domain/errors/profile_manager_exception.dart';
import 'package:careshare/profile_manager/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class RemoveAProfile {
  final ProfileRepository repository;

  RemoveAProfile(this.repository);

  Future<Either<ProfileManagerException, bool>> call(String profileId) {
    return repository.removeAProfile(profileId);
  }
}
