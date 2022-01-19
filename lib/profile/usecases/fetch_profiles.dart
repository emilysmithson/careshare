import 'package:careshare/profile/domain/models/profile.dart';
import 'package:careshare/profile/errors/profile_exception.dart';
import 'package:careshare/profile/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class FetchProfiles {
  final ProfileRepository repository;

  FetchProfiles(this.repository);
  Future<Either<ProfileException, List<Profile>>> call() {
    return repository.fetchProfiles();
  }
}
