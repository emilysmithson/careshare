import 'package:dartz/dartz.dart';

import '../errors/caregroup_manager_exception.dart';
import '../models/caregroup.dart';
import '../repositories/caregroup_repository.dart';

class FetchACaregroup {
  final CaregroupRepository repository;

  FetchACaregroup(this.repository);
  Future<Either<CaregroupManagerException, Caregroup>> call(id) {
    return repository.fetchACaregroup(id);
  }
}
