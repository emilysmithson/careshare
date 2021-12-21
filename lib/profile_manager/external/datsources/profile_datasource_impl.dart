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
    String? authId = FirebaseAuth.instance.currentUser?.uid;
    Profile newProfile = Profile(authId: authId);
    DatabaseReference reference = FirebaseDatabase.instance.ref("profiles");
    final String newkey = reference.push().key as String;
    reference.child(newkey).set(newProfile.toJson());
    return Profile(
      profileId: newkey,
    );
  }

  @override
  Future<DatabaseEvent> fetchProfiles() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("profiles");
    final response = await reference.once();

    return response;
  }

  @override
  Future updateProfile(Profile profile) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("profiles/${profile.profileId}");

    await reference.set(profile.toJson());
  }

  @override
  Future<Either<ProfileException, bool>> saveProfilePhoto(File photo) {
    // TODO: implement saveProfilePhoto
    throw UnimplementedError();
  }

  @override
  Future<DatabaseEvent> fetchAProfile(String id) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("profiles/${id}");

    final response = await reference.once();
    return response;
  }
}
