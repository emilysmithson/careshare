import 'package:careshare/profile/external/profile_datasource_impl.dart';
import 'package:careshare/profile/infrastructure/repositories/profile_repository_impl.dart';
import 'package:careshare/profile/usecases/create_profile.dart';
import 'package:careshare/profile/usecases/fetch_profiles.dart';
import 'package:flutter/foundation.dart';

import 'domain/models/profile.dart';

class ProfileModule {
  final List<Profile> profileList = [];

  createProfile() {
    final datasource = ProfileDatasourceImpl();
    final repository = ProfileRepositoryImpl(datasource);
    final useCase = CreateProfile(repository);
    useCase(
      email: 'emily_foulkes@hotmail.com',
      name: 'Emily Foulkes',
      nickName: 'Emily',
    );
  }

  fetchProfiles() async {
    final datasource = ProfileDatasourceImpl();
    final repository = ProfileRepositoryImpl(datasource);
    final useCase = FetchProfiles(repository);
    final result = await useCase();
    result.fold((l) {
      if (kDebugMode) {
        print(l.message);
      }
    }, (r) {
      profileList.clear();
      profileList.addAll(r);
    });
  }

  String? getNickName(String id) {
    return profileList.firstWhere((element) => element.id == id).nickName;
  }
}
