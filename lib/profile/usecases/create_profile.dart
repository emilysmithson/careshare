import 'package:careshare/profile/domain/models/profile.dart';
import 'package:careshare/profile/errors/profile_exception.dart';
import 'package:careshare/profile/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateProfile {
  final ProfileRepository repository;
  CreateProfile(this.repository);
  Future<Either<ProfileException, Profile>> call({
    required String name,
    required String nickName,
    required String email,
  }) {
    Profile profile = Profile(
        // id: DateTime.now().millisecondsSinceEpoch.toString(),
        id: FirebaseAuth.instance.currentUser!.uid,
        name: name,
        email: email,
        nickName: nickName);
    return repository.addProfile(profile);
  }
}
