import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../domain/errors/profile_manager_exception.dart';
import '../domain/models/profile.dart';
import '../infrastructure/datasources/profile_datasouce.dart';

class ProfileDatasourceImpl implements ProfileDatasource {

  @override
  Future<String> createProfile(Profile profile) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("profiles");
    final String newkey = reference.push().key as String;
    reference.child(newkey).set(profile.toJson());

    return newkey;
  }

  @override
  Future editProfile(Profile profile) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("profiles/${profile.id}");

    await reference.set(profile.toJson());
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
  Future<DatabaseEvent> fetchMyProfile() async {

    String? authId = FirebaseAuth.instance.currentUser?.uid;
    print('fetchMyProfile: authId: $authId');
    Query query = FirebaseDatabase.instance.ref("profiles") .orderByChild("auth_id").equalTo(authId).limitToFirst(1);

    final response = await query.once();
    return response;
  }


  @override
  Future removeAProfile(String profileId) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("profiles/$profileId");
    reference.remove();
  }

  @override
  Future<Either<ProfileManagerException, bool>> saveProfilePhoto(File photo) {
    // TODO: implement saveProfilePhoto
    throw UnimplementedError();
  }
}
