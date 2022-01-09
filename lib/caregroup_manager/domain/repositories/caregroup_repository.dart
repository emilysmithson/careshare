import 'dart:io';

import 'package:dartz/dartz.dart';

import '../errors/caregroup_manager_exception.dart';
import '../models/caregroup.dart';

abstract class CaregroupRepository {
  Future<Either<CaregroupManagerException, Caregroup>> updateCaregroup(Caregroup caregroup);
  Future<Either<CaregroupManagerException, Caregroup>> editCaregroup(Caregroup caregroup);
  Future<Either<CaregroupManagerException, List<Caregroup>>> fetchAllCaregroups();
  Future<Either<CaregroupManagerException, Caregroup>> fetchACaregroup(String id);
  Future<Either<CaregroupManagerException, String>> createCaregroup(Caregroup caregroup);
  Future<Either<CaregroupManagerException, bool>> saveCaregroupPhoto(File photo);
  Future<Either<CaregroupManagerException, bool>> removeACaregroup(String caregroupId);


}
