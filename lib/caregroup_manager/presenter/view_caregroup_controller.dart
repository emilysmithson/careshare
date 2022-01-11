import 'package:careshare/caregroup_manager/domain/models/caregroup.dart';
import 'package:flutter/material.dart';


enum PageStatus {
  loading,
  error,
  success,
}



class ViewCaregroupController {

  final List<Caregroup> caregroupList = [];
  final ValueNotifier<PageStatus> status = ValueNotifier<PageStatus>(PageStatus.loading);

}
