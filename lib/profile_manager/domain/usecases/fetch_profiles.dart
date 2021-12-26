import 'package:dartz/dartz.dart';

import '../errors/profile_manager_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';

class FetchProfiles {
  final ProfileRepository repository;

  FetchProfiles(this.repository);
  Future<Either<ProfileManagerException, List<Profile>>> call({String? search}) {
    return repository.fetchProfiles(search: search);
  }
}
