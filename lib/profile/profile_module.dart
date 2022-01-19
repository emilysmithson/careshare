import 'package:careshare/profile/external/profile_datasource_impl.dart';
import 'package:careshare/profile/infrastructure/repositories/profile_repository_impl.dart';
import 'package:careshare/profile/usecases/create_profile.dart';
import 'package:careshare/profile/usecases/fetch_profiles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'domain/models/profile.dart';

class ProfileModule {
  final List<Profile> profileList = [];

  createProfile() {
    final datasource = ProfileDatasourceImpl();
    final repository = ProfileRepositoryImpl(datasource);
    final useCase = CreateProfile(repository);
    useCase(
      email: 'emily_foulkes@hotmail.com',
      name: 'Emily Foulkes',
      nickName: 'Emily',
    );
  }

  fetchProfiles() async {
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
        print(returnedList);

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
