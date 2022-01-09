import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/caregroup_manager_exception.dart';
import '../../domain/models/caregroup.dart';

abstract class CaregroupDatasource {
  Future updateCaregroup(Caregroup caregroup);
  Future<DatabaseEvent> fetchAllCaregroups();
  Future<String> createCaregroup(Caregroup caregroup);
  Future<Either<CaregroupManagerException, bool>> saveCaregroupPhoto(File photo);
  Future<DatabaseEvent> fetchACaregroup(String id);
  Future removeACaregroup(String caregroupId);
  Future editCaregroup(Caregroup caregroup);
}
