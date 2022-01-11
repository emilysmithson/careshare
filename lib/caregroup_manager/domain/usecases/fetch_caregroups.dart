import 'package:dartz/dartz.dart';

import '../errors/caregroup_manager_exception.dart';
import '../models/caregroup.dart';
import '../repositories/caregroup_repository.dart';

class FetchAllCaregroups {
  final CaregroupRepository repository;

  FetchAllCaregroups(this.repository);
  Future<Either<CaregroupManagerException, List<Caregroup>>> call() {
    return repository.fetchAllCaregroups();
  }
}
