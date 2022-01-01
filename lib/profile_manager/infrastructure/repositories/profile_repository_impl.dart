import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/profile_manager_exception.dart';
import '../../domain/models/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_datasouce.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl(this.datasource);

  @override
  Future<Either<ProfileManagerException, String>> createProfile(Profile profile) async {
    String response;
    try {
      response = await datasource.createProfile(profile);
    } catch (error) {
      return Left(ProfileManagerException(error.toString()));
    }
    return Right(response);
  }

  @override
  Future<Either<ProfileManagerException, Profile>> editProfile(Profile profile) async {
    try {
      datasource.editProfile(profile);
    } catch (error) {
      return Left(ProfileManagerException(error.toString()));
    }
    return Right(profile);
  }

  
  @override
  Future<Either<ProfileManagerException, List<Profile>>> fetchProfiles({String? search}) async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchProfiles(search: search);
    } catch (error) {
      return Left(ProfileManagerException(error.toString()));
    }
    final List<Profile> profileList = [];
    if (response.snapshot.value == null) {
      return Left(ProfileManagerException('no values'));
    } else {

      // print(response.snapshot.value);

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
  Future<Either<ProfileManagerException, Profile>> updateProfile(
      Profile profile) async {
    try {
      datasource.updateProfile(profile);
    } catch (error) {
      return Left(ProfileManagerException(error.toString()));
    }
    return Right(profile);
  }

  @override
  Future<Either<ProfileManagerException, bool>> saveProfilePhoto(File photo) {
    // TODO: implement saveProfilePhoto
    throw UnimplementedError();
  }

  @override
  Future<Either<ProfileManagerException, Profile>> fetchAProfile(String id) async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchAProfile(id);
    } catch (error) {
      return Left(ProfileManagerException(error.toString()));
    }

    if (response.snapshot.value == null) {
      return Left(ProfileManagerException('no value'));
    } else {
      return Right(Profile.fromJson(response.snapshot.key, response.snapshot.value));
    }

  }


  @override
  Future<Either<ProfileManagerException, Profile>> fetchMyProfile() async {

    DatabaseEvent response;
    try {
      response = await datasource.fetchMyProfile();
    } catch (error) {
      return Left(ProfileManagerException(error.toString()));
    }

    if (response.snapshot.value == null) {
      return Left(ProfileManagerException('no value'));
    } else {

      var rawProfile = response.snapshot.children.first;

      return Right(Profile.fromJson(rawProfile.key, rawProfile.value));
    }

  }

  @override
  Future<Either<ProfileManagerException, bool>> removeAProfile(String profileId) async {
    try {
      datasource.removeAProfile(profileId);
    } catch (error) {
      return Left(ProfileManagerException(error.toString()));
    }
    return const Right(true);
  }

  @override
  Future<Either<ProfileManagerException, List<Profile>>> fetchSomeProfiles(String search) {
    // TODO: implement fetchSomeProfiles
    throw UnimplementedError();
  }
}
