import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/profile_manager_exception.dart';
import '../../domain/models/profile.dart';

abstract class ProfileDatasource {
  Future updateProfile(Profile profile);
  Future<DatabaseEvent> fetchProfiles({String? search});
  Future<String> createProfile(Profile profile);
  Future<Either<ProfileManagerException, bool>> saveProfilePhoto(File photo);
  Future<DatabaseEvent> fetchAProfile(String id);
  Future<DatabaseEvent> fetchMyProfile();
  Future removeAProfile(String profileId);
  Future editProfile(Profile profile);
}
