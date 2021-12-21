import 'package:careshare/profile_manager/domain/errors/profile_exception.dart';
import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/domain/repositories/profile_repository.dart';
import 'package:careshare/profile_manager/infrastructure/datasources/profile_datasouce.dart';
import 'package:dartz/dartz.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);
  Future<Either<ProfileException, Profile>> call(Profile profile) {
    return repository.updateProfile(profile);
  }
}
