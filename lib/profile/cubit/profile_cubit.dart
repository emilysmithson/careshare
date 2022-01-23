import 'package:bloc/bloc.dart';
import 'package:careshare/profile/models/profile.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  createProfile({
    required String name,
    required String email,
    required String id,
  }) {
    Profile profile = Profile(
      id: id,
      name: name,
      email: email,
    );
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

  final List<Profile> profileList = [];
  Future fetchProfiles() async {
    try {
      emit(ProfileLoading());
      DatabaseReference reference =
          FirebaseDatabase.instance.ref('profiles_test');
      final response = reference.onValue;
      response.listen((event) {
        if (event.snapshot.value == null) {
          if (kDebugMode) {
            print('empty list');
          }
          return;
        } else {
          Map<dynamic, dynamic> returnedList =
              event.snapshot.value as Map<dynamic, dynamic>;
          profileList.clear();
          returnedList.forEach(
            (key, value) {
              profileList.add(Profile.fromJson(value));
            },
          );
          emit(ProfileLoaded(profileList));
        }
      });
    } catch (error) {
      emit(
        ProfileError(
          error.toString(),
        ),
      );
    }
  }

  clearList() {
    profileList.clear();
  }

  String? getName(String id) {
    String? name;
    try {
      name = profileList.firstWhere((element) => element.id == id).name;
    } catch (e) {
      return 'no name found';
    }
    return name;
  }

  Profile fetchMyProfile() {
    return profileList.firstWhere(
        (element) => element.id == FirebaseAuth.instance.currentUser!.uid);
  }
}
