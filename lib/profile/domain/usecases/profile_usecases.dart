import 'package:careshare/profile/domain/errors/profile_exception.dart';
import 'package:careshare/profile/domain/models/profile.dart';
import 'package:careshare/profile/domain/usecases/create_profile.dart';
import 'package:careshare/profile/domain/usecases/fetch_profiles.dart';
import 'package:careshare/profile/domain/usecases/update_profile.dart';
import 'package:careshare/profile/external/datsources/profile_datasource_impl.dart';

import 'package:careshare/profile/infra/repositories/profile_repository_impl.dart';
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

  static Future<Either<ProfileException, List<Profile>>> fetchProfiles() async {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final FetchProfiles fetchProfilesDatasource = FetchProfiles(repository);

    return fetchProfilesDatasource();
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

  static Future<Either<ProfileException, Profile>> fetchMyProfile(
      BuildContext context) async {
    final response = await fetchProfiles();
    response.fold((l) => null, (r) async {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        FirebaseAuth.instance.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const App(),
          ),
        );
      }
      final Profile? myProfile =
          r.firstWhere((element) => element.authId == uid);
      if (myProfile != null) {
        profile = myProfile;
        return profile;
      }
      final profileResponse = await createProfile();
      profileResponse
          .fold((l) => Left(ProfileException('failed to create profile')), (r) {
        profile = r;
        return profile;
      });
    });
    return Left(ProfileException('no profile'));
  }
}
