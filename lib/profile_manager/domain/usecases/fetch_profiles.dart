import 'package:dartz/dartz.dart';

import '../errors/profile_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';


class FetchProfiles {
  final ProfileRepository repository;

  FetchProfiles(this.repository);
  Future<Either<ProfileException, List<Profile>>> call({String? search}) {
    return repository.fetchProfiles(search: search);
  }
}
