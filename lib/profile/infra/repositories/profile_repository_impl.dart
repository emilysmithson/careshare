import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/profile_exception.dart';
import '../../domain/models/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_datasouce.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl(this.datasource);
  @override
  Future<Either<ProfileException, Profile>> createProfile() async {
    Profile response;
    try {
      response = await datasource.createProfile();
    } catch (error) {
      return Left(ProfileException(error.toString()));
    }
    return Right(response);
  }

  @override
  Future<Either<ProfileException, List<Profile>>> fetchProfiles() async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchProfiles();
    } catch (error) {
      return Left(ProfileException(error.toString()));
    }
    final List<Profile> profileList = [];
    if (response.snapshot.value == null) {
      return Left(ProfileException('no values'));
    } else {
      Map<dynamic, dynamic> returnedList =
          response.snapshot.value as Map<dynamic, dynamic>;

      returnedList.forEach(
        (key, value) {
          profileList.add(Profile.fromJson(key, value));
        },
      );
    }
    return Right(profileList);
  }

  @override
  Future<Either<ProfileException, Profile>> updateProfile(
      Profile profile) async {
    try {
      datasource.updateProfile(profile);
    } catch (error) {
      return Left(ProfileException(error.toString()));
    }
    return Right(profile);
  }

  @override
  Future<Either<ProfileException, bool>> saveProfilePhoto(File photo) {
    // TODO: implement saveProfilePhoto
    throw UnimplementedError();
  }
}