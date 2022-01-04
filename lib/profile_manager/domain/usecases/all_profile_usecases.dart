import 'package:careshare/profile_manager/domain/errors/profile_manager_exception.dart';
import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/domain/usecases/create_a_profile.dart';
import 'package:careshare/profile_manager/domain/usecases/edit_a_profile.dart';
import 'package:careshare/profile_manager/domain/usecases/remove_a_profile.dart';
import 'package:careshare/profile_manager/domain/usecases/fetch_profiles.dart';
import 'package:careshare/profile_manager/domain/usecases/fetch_a_profile.dart';
import 'package:careshare/profile_manager/domain/usecases/fetch_my_profile.dart';
import 'package:careshare/profile_manager/domain/usecases/update_profile.dart';
import 'package:careshare/profile_manager/external/profile_datasource_impl.dart';

import 'package:careshare/profile_manager/infrastructure/repositories/profile_repository_impl.dart';
import 'package:dartz/dartz.dart';

class AllProfileUseCases {
  static Profile? profile;

  static Future<Either<ProfileManagerException, String>> createProfile(Profile profile) {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final CreateProfile createProfileUseCase = CreateProfile(repository);
    return createProfileUseCase(profile);
  }

  static Future<Either<ProfileManagerException, Profile>> editAProfile(Profile profile) {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final EditAProfile editAProfileUseCase = EditAProfile(repository);
    return editAProfileUseCase(profile);
  }


  static Future<Either<ProfileManagerException, List<Profile>>> fetchProfiles({String? search}) async {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final FetchProfiles fetchProfilesDatasource = FetchProfiles(repository);

    return fetchProfilesDatasource(search: search);
  }

  static Future<Either<ProfileManagerException, Profile>> fetchAProfile(String id) async {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final FetchAProfile fetchAProfileDatasource = FetchAProfile(repository);

    return fetchAProfileDatasource(id);
  }

  static Future<Either<ProfileManagerException, Profile>> fetchMyProfile() async {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final FetchMyProfile fetchMyProfileDatasource = FetchMyProfile(repository);

    return fetchMyProfileDatasource();
  }

  static Future<Either<ProfileManagerException, Profile>> updateProfile(
      Profile profile) async {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final UpdateProfile updateProfileUseCase = UpdateProfile(repository);
    final Either<ProfileManagerException, Profile> response =
        await updateProfileUseCase(profile);
    response.fold((l) => null, (r) => profile = r);
    return response;
  }

  static Future<Either<ProfileManagerException, bool>> removeAProfile(
      String id,
      ) {
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final RemoveAProfile removeAProfileUseCase = RemoveAProfile(repository);
    return removeAProfileUseCase(id);
  }
  
  
}
