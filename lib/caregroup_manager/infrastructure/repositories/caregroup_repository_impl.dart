import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/caregroup_manager_exception.dart';
import '../../domain/models/caregroup.dart';
import '../../domain/repositories/caregroup_repository.dart';
import '../datasources/caregroup_datasouce.dart';

class CaregroupRepositoryImpl implements CaregroupRepository {
  final CaregroupDatasource datasource;

  CaregroupRepositoryImpl(this.datasource);

  @override
  Future<Either<CaregroupManagerException, String>> createCaregroup(Caregroup caregroup) async {
    String response;
    try {
      response = await datasource.createCaregroup(caregroup);
    } catch (error) {
      return Left(CaregroupManagerException(error.toString()));
    }
    return Right(response);
  }

  @override
  Future<Either<CaregroupManagerException, Caregroup>> editCaregroup(Caregroup caregroup) async {
    try {
      datasource.editCaregroup(caregroup);
    } catch (error) {
      return Left(CaregroupManagerException(error.toString()));
    }
    return Right(caregroup);
  }

  
  @override
  Future<Either<CaregroupManagerException, List<Caregroup>>> fetchCaregroups({String? search}) async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchCaregroups(search: search);
    } catch (error) {
      return Left(CaregroupManagerException(error.toString()));
    }
    final List<Caregroup> caregroupList = [];
    if (response.snapshot.value == null) {
      return Left(CaregroupManagerException('no values'));
    } else {

      // print(response.snapshot.value);

      Map<dynamic, dynamic> returnedList =
          response.snapshot.value as Map<dynamic, dynamic>;

      returnedList.forEach(
        (key, value) {
          caregroupList.add(Caregroup.fromJson(key, value));
        },
      );
    }
    return Right(caregroupList);
  }

  @override
  Future<Either<CaregroupManagerException, Caregroup>> updateCaregroup(
      Caregroup caregroup) async {
    try {
      datasource.updateCaregroup(caregroup);
    } catch (error) {
      return Left(CaregroupManagerException(error.toString()));
    }
    return Right(caregroup);
  }

  @override
  Future<Either<CaregroupManagerException, bool>> saveCaregroupPhoto(File photo) {
    // TODO: implement saveCaregroupPhoto
    throw UnimplementedError();
  }

  @override
  Future<Either<CaregroupManagerException, Caregroup>> fetchACaregroup(String id) async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchACaregroup(id);
    } catch (error) {
      return Left(CaregroupManagerException(error.toString()));
    }

    if (response.snapshot.value == null) {
      return Left(CaregroupManagerException('no value'));
    } else {
      return Right(Caregroup.fromJson(response.snapshot.key, response.snapshot.value));
    }

  }


  @override
  Future<Either<CaregroupManagerException, Caregroup>> fetchMyCaregroup() async {

    DatabaseEvent response;
    try {
      response = await datasource.fetchMyCaregroup();
    } catch (error) {
      return Left(CaregroupManagerException(error.toString()));
    }

    if (response.snapshot.value == null) {
      return Left(CaregroupManagerException('no value'));
    } else {

      var rawCaregroup = response.snapshot.children.first;

      return Right(Caregroup.fromJson(rawCaregroup.key, rawCaregroup.value));
    }

  }

  @override
  Future<Either<CaregroupManagerException, bool>> removeACaregroup(String caregroupId) async {
    try {
      datasource.removeACaregroup(caregroupId);
    } catch (error) {
      return Left(CaregroupManagerException(error.toString()));
    }
    return const Right(true);
  }

}
