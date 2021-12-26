import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../errors/profile_manager_exception.dart';
import '../models/profile.dart';
import '../repositories/profile_repository.dart';

class CreateAProfile {
  final ProfileRepository repository;

  CreateAProfile(this.repository);
  Future<Either<ProfileManagerException, String>> call(Profile profile) async {
    Profile profileWithId = profile;
    String? id = FirebaseAuth.instance.currentUser?.uid;

    if (id != null) {
      profileWithId.createdBy = id;
    }

    return repository.createProfile(profileWithId);
  }
}
