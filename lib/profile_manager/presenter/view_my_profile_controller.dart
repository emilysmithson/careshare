import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/domain/usecases/all_profile_usecases.dart';
import 'package:flutter/material.dart';


enum PageStatus {
  loading,
  error,
  success,
}

class ViewMyProfileController {

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
}
