
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/profile_exception.dart';
import '../../domain/models/profile.dart';
import '../../infrastructure/datasources/profile_datasouce.dart';

class ProfileDatasourceImpl implements ProfileDatasource {
  @override
  Future<Profile> createProfile() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("profiles");

    String? authId = FirebaseAuth.instance.currentUser?.uid;
    Profile newProfile = Profile(authId: authId);
    final String newkey = reference.push().key as String;
    reference.child(newkey).set(newProfile.toJson());
    return Profile(
      id: newkey,
      authId: authId != null ? authId : "",
    );
  }

  // FirebaseFirestore.instance
  //     .collection('users')
  //     .where('age', isGreaterThan: 20)
  //     .get()
  //     .then(...);

  @override
  Future<DatabaseEvent> fetchProfiles({String? search}) async {
    DatabaseReference reference;
    if (search == null) {
      reference = FirebaseDatabase.instance.ref("profiles");
    }
    else {
      reference = FirebaseDatabase.instance.ref("profiles/"+search);
    }
    final response = await reference.once();

    return response;
  }

  @override
  Future updateProfile(Profile profile) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("profiles/${profile.id}");

    await reference.set(profile.toJson());
  }

  @override
  Future<DatabaseEvent> fetchAProfile(String id) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("profiles/${id}");

    final response = await reference.once();
    return response;
  }

  @override
  Future<Either<ProfileException, bool>> saveProfilePhoto(File photo) {
    // TODO: implement saveProfilePhoto
    throw UnimplementedError();
  }
}
