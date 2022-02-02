import 'package:bloc/bloc.dart';
import 'package:careshare/profile_manager/models/fetch_photo_url.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:careshare/profile_manager/repository/edit_profile_field_repository.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final EditProfileFieldRepository editProfileFieldRepository;

  ProfileCubit({
    required this.editProfileFieldRepository,
  }) : super(ProfileInitial());

  createProfile({
    required String name,
    String? firstName,
    String? lastName,
    required String email,
    required String id,
  }) {
    Profile profile = Profile(
      id: id,
      name: name,
      firstName: firstName ?? "",
      lastName: lastName ?? "",
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
      emit(const ProfileLoading());
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
            (key, value) async {
              Profile profile = Profile.fromJson(value);

              if (profile.photo != null) {
                profile.photoURL = await fetchPhotoUrl(profile.photo!);
              }

              profileList.add(profile);
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

  String? getPhoto(String id) {
    String? photoURL;
    try {
      photoURL = profileList.firstWhere((element) => element.id == id).photoURL;
    } catch (e) {
      return 'no name found';
    }
    return photoURL;
  }

  Profile fetchMyProfile() {
    print('UID: ${FirebaseAuth.instance.currentUser!.uid}');
    return profileList.firstWhere(
        (element) => element.id == FirebaseAuth.instance.currentUser!.uid);
  }

  editProfile(
      {required Profile profile,
      required ProfileField profileField,
      required dynamic newValue}) {
    emit(const ProfileLoading());

    editProfileFieldRepository(
        profile: profile, profileField: profileField, newValue: newValue);
  }
}
