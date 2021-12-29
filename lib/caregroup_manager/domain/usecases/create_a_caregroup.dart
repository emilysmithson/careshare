import 'package:dartz/dartz.dart';
import '../errors/caregroup_manager_exception.dart';
import '../models/caregroup.dart';
import '../repositories/caregroup_repository.dart';
import 'package:careshare/global.dart';

class CreateACaregroup {
  final CaregroupRepository repository;

  CreateACaregroup(this.repository);
  Future<Either<CaregroupManagerException, String>> call(Caregroup caregroup) async {
    Caregroup caregroupWithId = caregroup;
    caregroup.createdBy = myProfileId;

    return repository.createCaregroup(caregroupWithId);
  }
}
