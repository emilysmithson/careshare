import 'package:careshare/profile/domain/models/profile.dart';
import 'package:careshare/profile/errors/profile_exception.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<ProfileException, Profile>> addProfile(Profile profile);
  Future<Either<ProfileException, List<Profile>>> fetchProfiles();
}
