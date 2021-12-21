import 'package:careshare/profile_manager/domain/errors/profile_exception.dart';
import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/domain/usecases/create_profile.dart';
import 'package:careshare/profile_manager/domain/usecases/fetch_profiles.dart';
import 'package:careshare/profile_manager/domain/usecases/update_profile.dart';
import 'package:careshare/profile_manager/external/datsources/profile_datasource_impl.dart';

import 'package:careshare/profile_manager/infrastructure/repositories/profile_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class ProfileUsecases {
  static Profile? profile;
  static Future<Either<ProfileException, Profile>> createProfile() async {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final CreateProfile createProfileDatasource = CreateProfile(repository);
    final Either<ProfileException, Profile> response =
        await createProfileDatasource();
    response.fold((l) => null, (r) => profile = r);
    return response;
  }

  static Future<Either<ProfileException, List<Profile>>> fetchProfiles({String? search}) async {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final FetchProfiles fetchProfilesDatasource = FetchProfiles(repository);

    return fetchProfilesDatasource(search: search);
  }

  static Future<Either<ProfileException, Profile>> updateProfile(
      Profile profile) async {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final UpdateProfile updateProfileUseCase = UpdateProfile(repository);
    final Either<ProfileException, Profile> response =
        await updateProfileUseCase(profile);
    response.fold((l) => null, (r) => profile = r);
    return response;
  }

}
