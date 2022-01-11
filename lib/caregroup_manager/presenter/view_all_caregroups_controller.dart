import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/models/caregroup.dart';
import '../domain/usecases/all_caregroup_usecases.dart';
import '../domain/usecases/remove_a_caregroup.dart';
import '../external/caregroup_datasource_impl.dart';
import '../infrastructure/repositories/caregroup_repository_impl.dart';

enum PageStatus {
  loading,
  error,
  success,
}

class ViewAllCaregroupsController {
  final List<Caregroup> caregroupList = [];
  final ValueNotifier<PageStatus> status = ValueNotifier<PageStatus>(PageStatus.loading);

  fetchAllCaregroups() async {
    final response = await AllCaregroupUseCases.fetchAllCaregroups();

    response.fold((l) {
      status.value = PageStatus.error;
      print('##############################');
      print(l.message);
    }, (r) {
      caregroupList.clear();
      caregroupList.addAll(r);
      status.value = PageStatus.success;
    });
  }

  removeACaregroup(String? caregroupId) {
    if (caregroupId == null) {
      return;
    }
    final CaregroupDatasourceImpl datasource = CaregroupDatasourceImpl();
    final CaregroupRepositoryImpl repository = CaregroupRepositoryImpl(datasource);
    final RemoveCaregroup remove = RemoveCaregroup(repository);
    remove(caregroupId);
    status.value = PageStatus.loading;
    fetchAllCaregroups();
  }
}
