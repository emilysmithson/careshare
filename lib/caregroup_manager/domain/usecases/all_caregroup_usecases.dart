import 'package:careshare/caregroup_manager/domain/errors/caregroup_manager_exception.dart';
import 'package:careshare/caregroup_manager/domain/models/caregroup.dart';
import 'package:careshare/caregroup_manager/domain/usecases/create_a_caregroup.dart';
import 'package:careshare/caregroup_manager/domain/usecases/edit_a_caregroup.dart';
import 'package:careshare/caregroup_manager/domain/usecases/remove_a_caregroup.dart';
import 'package:careshare/caregroup_manager/domain/usecases/fetch_caregroups.dart';
import 'package:careshare/caregroup_manager/domain/usecases/fetch_a_caregroup.dart';
import 'package:careshare/caregroup_manager/domain/usecases/update_caregroup.dart';
import 'package:careshare/caregroup_manager/external/caregroup_datasource_impl.dart';

import 'package:careshare/caregroup_manager/infrastructure/repositories/caregroup_repository_impl.dart';
import 'package:dartz/dartz.dart';


class AllCaregroupUseCases {
  static Caregroup? caregroup;

  static Future<Either<CaregroupManagerException, String>> createACaregroup(Caregroup caregroup) {
    final CaregroupDatasourceImpl datasource = CaregroupDatasourceImpl();
    final CaregroupRepositoryImpl repository = CaregroupRepositoryImpl(datasource);
    final CreateACaregroup createACaregroupUseCase = CreateACaregroup(repository);
    return createACaregroupUseCase(caregroup);
  }

  static Future<Either<CaregroupManagerException, Caregroup>> editACaregroup(Caregroup caregroup) {
    final CaregroupDatasourceImpl datasource = CaregroupDatasourceImpl();
    final CaregroupRepositoryImpl repository = CaregroupRepositoryImpl(datasource);
    final EditACaregroup editACaregroupUseCase = EditACaregroup(repository);
    return editACaregroupUseCase(caregroup);
  }


  static Future<Either<CaregroupManagerException, List<Caregroup>>> fetchAllCaregroups() async {
    final CaregroupDatasourceImpl datasource = CaregroupDatasourceImpl();
    final CaregroupRepositoryImpl repository = CaregroupRepositoryImpl(datasource);
    final FetchAllCaregroups fetchAllCaregroupsDatasource = FetchAllCaregroups(repository);

    return fetchAllCaregroupsDatasource();
  }

  static Future<Either<CaregroupManagerException, Caregroup>> fetchACaregroup(String id) async {
    final CaregroupDatasourceImpl datasource = CaregroupDatasourceImpl();
    final CaregroupRepositoryImpl repository = CaregroupRepositoryImpl(datasource);
    final FetchACaregroup fetchACaregroupDatasource = FetchACaregroup(repository);

    return fetchACaregroupDatasource(id);
  }

  static Future<Either<CaregroupManagerException, Caregroup>> updateCaregroup(
      Caregroup caregroup) async {
    final CaregroupDatasourceImpl datasource = CaregroupDatasourceImpl();
    final CaregroupRepositoryImpl repository = CaregroupRepositoryImpl(datasource);
    final UpdateCaregroup updateCaregroupUseCase = UpdateCaregroup(repository);
    final Either<CaregroupManagerException, Caregroup> response =
        await updateCaregroupUseCase(caregroup);
    response.fold((l) => null, (r) => caregroup = r);
    return response;
  }

  static Future<Either<CaregroupManagerException, bool>> removeCaregroup(
      String id,
      ) {
    final CaregroupDatasourceImpl datasource = CaregroupDatasourceImpl();
    final CaregroupRepositoryImpl repository = CaregroupRepositoryImpl(datasource);
    final RemoveCaregroup removeACaregroupUseCase = RemoveCaregroup(repository);
    return removeACaregroupUseCase(id);
  }
  
  
}
