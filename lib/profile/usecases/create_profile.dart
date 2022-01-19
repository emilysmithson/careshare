import 'package:careshare/profile/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class CreateProfile {
  call({
    required String name,
    required String nickName,
    required String email,
  }) {
    Profile profile = Profile(
        id: FirebaseAuth.instance.currentUser!.uid,
        name: name,
        email: email,
        nickName: nickName);
    try {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref('profiles_test');

      reference.child(profile.id!).set(profile.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }
}
