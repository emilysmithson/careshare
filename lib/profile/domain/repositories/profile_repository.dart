import 'dart:io';

import 'package:dartz/dartz.dart';

import '../errors/profile_exception.dart';
import '../models/profile.dart';

abstract class ProfileRepository {
  Future<Either<ProfileException, Profile>> updateProfile(Profile profile);
  Future<Either<ProfileException, List<Profile>>> fetchProfiles();
  Future<Either<ProfileException, Profile>> createProfile();
  Future<Either<ProfileException, bool>> saveProfilePhoto(File photo);
}
