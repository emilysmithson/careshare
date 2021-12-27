import 'package:dartz/dartz.dart';
import '../errors/profile_manager_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';
import 'package:careshare/global.dart';

class CreateAProfile {
  final ProfileRepository repository;

  CreateAProfile(this.repository);
  Future<Either<ProfileManagerException, String>> call(Profile profile) async {
    Profile profileWithId = profile;
    profile.createdBy = myProfileId;

    return repository.createProfile(profileWithId);
  }
}
