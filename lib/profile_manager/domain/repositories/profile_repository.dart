import 'dart:io';

import 'package:dartz/dartz.dart';

import '../errors/profile_manager_exception.dart';
import '../models/profile.dart';

abstract class ProfileRepository {
  Future<Either<ProfileManagerException, Profile>> updateProfile(Profile profile);
  Future<Either<ProfileManagerException, Profile>> editProfile(Profile profile);
  Future<Either<ProfileManagerException, List<Profile>>> fetchProfiles({String? search});
  Future<Either<ProfileManagerException, Profile>> fetchAProfile(String id);
  Future<Either<ProfileManagerException, Profile>> fetchMyProfile();
  Future<Either<ProfileManagerException, String>> createProfile(Profile profile);
  Future<Either<ProfileManagerException, bool>> saveProfilePhoto(File photo);
  Future<Either<ProfileManagerException, bool>> removeAProfile(String profileId);


}
