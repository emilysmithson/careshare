import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:careshare/profile_manager/repository/add_carer_in_caregroup_to_profile.dart';
import 'package:careshare/profile_manager/repository/complete_task.dart';
import 'package:careshare/profile_manager/repository/give_kudos.dart';
import 'package:equatable/equatable.dart';
import 'package:careshare/profile_manager/repository/edit_profile_field_repository.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../my_profile/models/profile.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final EditProfileFieldRepository editProfileFieldRepository;
  final GiveKudos giveKudos;
  final AddCarerInCaregroupToProfile addCarerInCaregroupToProfile;
  final CompleteTask completeTask;
  final List<Profile> profileList = [];
  late Profile myProfile;

  ProfileCubit({
    required this.editProfileFieldRepository,
    required this.addCarerInCaregroupToProfile,
    required this.giveKudos,
    required this.completeTask,
  }) : super(ProfileInitial());

  Future fetchMyProfile(String id) async {
    try {
      emit(const ProfileLoading());
      DatabaseReference reference =
          FirebaseDatabase.instance.ref('profiles/$id');
      final response = reference.onValue;

      response.listen((event) async {
        if (event.snapshot.value == null) {
          emit(const ProfileError("profile is null"));
          return;
        } else {
          final data = event.snapshot.value;
          myProfile = Profile.fromJson(data);

          emit(MyProfileLoaded(
            myProfile: myProfile,
          ));
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

  createProfile({
    File? photo,
    String? name,
    String? firstName,
    String? lastName,
    String? email,
    required String id,
  }) async {
    if (photo == null || name == null || email == null) {
      emit(ProfileError(
          'One of the fields for the profile is null:\nphoto: $photo, \nname: $name\nlastName: $lastName\nemail: $email'));
      return;
    }
    emit(const ProfileLoading());

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_photos')
        .child(id + '.jpg');

    await ref.putFile(photo);
    final url = await ref.getDownloadURL();

    myProfile = Profile(
      id: id,
      name: name,
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      email: email,
      kudos: 0,
      photo: url,
      createdDate: DateTime.now(),
      carerInCaregroups: [],
      tandcsAccepted: false,
      showInvitationsOnHomePage: true,
      showOtherCaregropusOnHomePage: true,
    );

    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref('profiles');
      reference.child(myProfile.id).set(myProfile.toJson());
    } catch (error) {
      emit(ProfileError(error.toString()));
    }
    fetchMyProfile(id);
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

          profileList.sort((a, b) => a.name.compareTo(b.name));
          emit(ProfileLoaded(profileList: profileList, myProfile: myProfile));
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

    emit(ProfileLoaded(profileList: profileList, myProfile: myProfile));
  }

  // fetches a list of all the ids of people in your caregroup apart from yourself
  // so that you can notify everyone of something but not recieve the notification yourself.
  List<String> fetchListIdFromCaregroup() {
    final List<String> profileIdList = [];
    for (final Profile profile in profileList) {
      if (profile != myProfile) {
        profileIdList.add(profile.id);
      }
    }
    return profileIdList;
  }
}
