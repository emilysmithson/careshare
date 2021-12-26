import 'package:careshare/profile_manager/domain/errors/profile_manager_exception.dart';
import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class EditAProfile {
  final ProfileRepository repository;

  EditAProfile(this.repository);

  Future<Either<ProfileManagerException, Profile>> call(Profile profile) {
    return repository.editProfile(profile);
  }
}
