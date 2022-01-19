import 'package:careshare/profile/models/profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class FetchProfiles {
  final List<Profile> profileList = [];
  call() async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('profiles_test');
    final response = reference.onValue;
    response.listen((event) {
      final List<Profile> _profileList = [];
      if (event.snapshot.value == null) {
        if (kDebugMode) {
          print('empty list');
        }
        return;
      } else {
        Map<dynamic, dynamic> returnedList =
            event.snapshot.value as Map<dynamic, dynamic>;

        returnedList.forEach(
          (key, value) {
            _profileList.add(Profile.fromJson(value));
          },
        );
        profileList.clear();
        profileList.addAll(_profileList);
      }
    });
  }

  String? getNickName(String id) {
    return profileList.firstWhere((element) => element.id == id).nickName;
  }
}
