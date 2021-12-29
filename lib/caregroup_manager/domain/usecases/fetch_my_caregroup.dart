import 'package:dartz/dartz.dart';

import '../errors/caregroup_manager_exception.dart';
import '../models/caregroup.dart';
import '../repositories/caregroup_repository.dart';

class FetchMyCaregroup {
  final CaregroupRepository repository;

  FetchMyCaregroup(this.repository);
  Future<Either<CaregroupManagerException, Caregroup>> call() {

      Future<Either<CaregroupManagerException, Caregroup>> myCaregroup = repository.fetchMyCaregroup();
    return myCaregroup;

  }
}
