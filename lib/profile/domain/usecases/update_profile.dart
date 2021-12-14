import 'package:careshare/profile/domain/errors/profile_exception.dart';
import 'package:careshare/profile/domain/models/profile.dart';
import 'package:careshare/profile/domain/repositories/profile_repository.dart';
import 'package:careshare/profile/infra/datasources/profile_datasouce.dart';
import 'package:dartz/dartz.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);
  Future<Either<ProfileException, Profile>> call(Profile profile) {
    return repository.updateProfile(profile);
  }
}
