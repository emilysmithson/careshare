import 'package:dartz/dartz.dart';
import '../errors/profile_manager_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';
import 'package:careshare/global.dart';

class CreateProfile {
  final ProfileRepository repository;

  CreateProfile(this.repository);
  Future<Either<ProfileManagerException, String>> call(Profile profile) async {
    Profile profileWithId = profile;
    profile.createdBy = myProfileId;

    return repository.createProfile(profileWithId);
  }
}
