import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/models/profile.dart';
import '../domain/usecases/all_profile_usecases.dart';
import '../domain/usecases/remove_a_profile.dart';
import '../external/profile_datasource_impl.dart';
import '../infrastructure/repositories/profile_repository_impl.dart';

enum PageStatus {
  loading,
  error,
  success,
}

class ViewAllProfilesController {
  final List<Profile> profileList = [];
  final ValueNotifier<PageStatus> status = ValueNotifier<PageStatus>(PageStatus.loading);

  fetchProfiles() async {
    final response = await AllProfileUseCases.fetchProfiles();

    response.fold((l) {
      status.value = PageStatus.error;
    }, (r) {
      profileList.clear();
      profileList.addAll(r);
      status.value = PageStatus.success;
    });
  }

  removeAProfile(String? profileId) {
    if (profileId == null) {
      return;
    }
    final ProfileDatasourceImpl datasource = ProfileDatasourceImpl();
    final ProfileRepositoryImpl repository = ProfileRepositoryImpl(datasource);
    final RemoveAProfile remove = RemoveAProfile(repository);
    remove(profileId);
    status.value = PageStatus.loading;
    fetchProfiles();
  }
}
