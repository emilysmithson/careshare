import 'package:careshare/caregroup_manager/domain/models/caregroup.dart';
import 'package:careshare/caregroup_manager/domain/usecases/all_caregroup_usecases.dart';
import 'package:flutter/material.dart';


enum PageStatus {
  loading,
  error,
  success,
}

class ViewMyCaregroupController {

  final List<Caregroup> caregroupList = [];
  final ValueNotifier<PageStatus> status = ValueNotifier<PageStatus>(PageStatus.loading);

  fetchCaregroups() async {
    final response = await AllCaregroupUseCases.fetchCaregroups();

    response.fold((l) {
      status.value = PageStatus.error;
    }, (r) {
      caregroupList.clear();
      caregroupList.addAll(r);
      status.value = PageStatus.success;
    });
  }
}
