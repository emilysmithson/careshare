import 'package:careshare/caregroup_manager/domain/errors/caregroup_manager_exception.dart';
import 'package:careshare/caregroup_manager/domain/models/caregroup.dart';
import 'package:careshare/caregroup_manager/domain/repositories/caregroup_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateCaregroup {
  final CaregroupRepository repository;

  UpdateCaregroup(this.repository);
  Future<Either<CaregroupManagerException, Caregroup>> call(Caregroup caregroup) {
    return repository.updateCaregroup(caregroup);
  }
}
