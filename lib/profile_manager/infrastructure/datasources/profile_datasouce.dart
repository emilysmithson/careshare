import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/profile_exception.dart';
import '../../domain/models/profile.dart';

abstract class ProfileDatasource {
  Future updateProfile(Profile profile);
  Future<DatabaseEvent> fetchProfiles();
  Future<Profile> createProfile();
  Future<Either<ProfileException, bool>> saveProfilePhoto(File photo);
  Future<DatabaseEvent> fetchAProfile(String id);
}
