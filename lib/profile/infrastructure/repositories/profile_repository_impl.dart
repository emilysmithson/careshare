import 'package:careshare/profile/errors/profile_exception.dart';
import 'package:careshare/profile/domain/models/profile.dart';
import 'package:careshare/profile/infrastructure/datasources/profile_datasource.dart';
import 'package:careshare/profile/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl(this.datasource);
  @override
  Future<Either<ProfileException, Profile>> addProfile(Profile profile) async {
    try {
      await datasource.addProfile(profile);
    } catch (error) {
      return Left(ProfileException(error.toString()));
    }
    return Right(profile);
  }

  @override
  Future<Either<ProfileException, List<Profile>>> fetchProfiles() async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchProfiles();
    } catch (error) {
      return Left(ProfileException(error.toString()));
    }
    final List<Profile> profileTaskList = [];
    if (response.snapshot.value == null) {
      return Left(ProfileException('no values'));
    } else {
      Map<dynamic, dynamic> returnedList =
          response.snapshot.value as Map<dynamic, dynamic>;
      print(returnedList);

      returnedList.forEach(
        (key, value) {
          profileTaskList.add(Profile.fromJson(value));
        },
      );
    }
    return Right(profileTaskList);
  }
}
