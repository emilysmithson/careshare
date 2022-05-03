import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:careshare/profile_manager/models/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:careshare/profile_manager/repository/edit_profile_field_repository.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final EditProfileFieldRepository editProfileFieldRepository;
  final List<Profile> profileList = [];
  late Profile myProfile;

  ProfileCubit({
    required this.editProfileFieldRepository,
  }) : super(ProfileInitial());

  createProfile({
    required File photo,
    required String name,
    String? firstName,
    String? lastName,
    required String email,
    required String id,
    // required List<String> careeInCaregroups,
    // required List<String> carerInCaregroups,

  }) async {
    emit(const ProfileLoading());
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_photos')
        .child(id + '.jpg');

    await ref.putFile(photo);
    final url = await ref.getDownloadURL();

    Profile profile = Profile(
      id: id,
      name: name,
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      email: email,
      kudos: 0,
      photo: url,
      // careeInCaregroups: careeInCaregroups,
      // carerInCaregroups: carerInCaregroups,

    );
    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref('profiles');

      reference.child(profile.id!).set(profile.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    emit(ProfileLoaded(profileList: profileList));
  }

  Future fetchProfiles() async {
    try {
      emit(const ProfileLoading());
      DatabaseReference reference = FirebaseDatabase.instance.ref('profiles');
      final response = reference.onValue;

      response.listen((event) async {
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

              profileList.add(profile);
            },
          );

          myProfile = profileList.firstWhere((element) =>
              element.id == FirebaseAuth.instance.currentUser!.uid);

          profileList.sort((a, b) => a.name.compareTo(b.name));
          emit(ProfileLoaded(profileList: profileList));
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
    String? photo;
    try {
      photo = profileList.firstWhere((element) => element.id == id).photo;
    } catch (e) {
      return "https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/nuccia.jpeg?alt=media&token=f9e4cc37-d756-4af5-85e2-18db5b08e897";
    }
    return photo;
  }

  editProfile(
      {required Profile profile,
      required ProfileField profileField,
      required dynamic newValue}) {
    emit(const ProfileLoading());

    editProfileFieldRepository(
        profile: profile, profileField: profileField, newValue: newValue);
  }

  addKudos(String id) {
    Profile profile = profileList.firstWhere((element) => element.id == id);

    int newKudos = profile.kudos + 1;

    editProfile(
        newValue: newKudos, profile: profile, profileField: ProfileField.kudos);
  }

  // fetches a list of all the ids of people in your caregroup apart from yourself
  // so that you can notify everyone of something but not recieve the notification yourself.
  List<String> fetchListIdFromCaregroup() {
    final List<String> profileIdList = [];
    for (final Profile profile in profileList) {
      if (profile != myProfile) {
        if (profile.id != null) {
          profileIdList.add(profile.id!);
        }
      }
    }
    return profileIdList;
  }
}
