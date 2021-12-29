import 'package:dartz/dartz.dart';

import '../errors/caregroup_manager_exception.dart';
import '../models/caregroup.dart';
import '../repositories/caregroup_repository.dart';

class FetchCaregroups {
  final CaregroupRepository repository;

  FetchCaregroups(this.repository);
  Future<Either<CaregroupManagerException, List<Caregroup>>> call({String? search}) {
    return repository.fetchCaregroups(search: search);
  }
}
