import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/models/profile_type.dart';

import 'package:careshare/profile_manager/repository/add_role_in_caregroup_to_profile.dart';
import 'package:careshare/profile_manager/repository/complete_task.dart';
import 'package:careshare/profile_manager/repository/give_kudos.dart';
import 'package:careshare/profile_manager/repository/update_last_login.dart';
import 'package:equatable/equatable.dart';
import 'package:careshare/profile_manager/repository/edit_profile_field_repository.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';


part 'my_profile_state.dart';

class MyProfileCubit extends Cubit<MyProfileState> {
  final EditProfileFieldRepository editProfileFieldRepository;
  final UpdateLastLogin updateLastAccess;
  final GiveKudos giveKudos;
  final AddRoleInCaregroupToProfile addRoleInCaregroupToProfile;
  final CompleteTask completeTask;
  late Profile myProfile;

  MyProfileCubit({
    required this.editProfileFieldRepository,
    required this.addRoleInCaregroupToProfile,
    required this.updateLastAccess,
    required this.giveKudos,
    required this.completeTask,
  }) : super(MyProfileInitial());

  Future fetchMyProfile(String id) async {
    try {
      emit(const MyProfileLoading());
      DatabaseReference reference =
          FirebaseDatabase.instance.ref('profiles/$id');
      final response = reference.onValue;

      response.listen((event) async {
        if (event.snapshot.value == null) {
          emit(const MyProfileError("profile is null"));
          return;
        } else {
          final data = event.snapshot.value;
          myProfile = Profile.fromJson(id, data);
          // print('-----loaded profile: ${myProfile.email}');
          emit(MyProfileLoaded(
            myProfile: myProfile,
          ));
        }
      });
    } catch (error) {
      emit(
        MyProfileError(
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
    String? phoneCountry,
    String? phoneCountryCode,
    String? phoneNumber,
    required String id,
  }) async {
    if (photo == null || name == null || email == null) {
      emit(MyProfileError(
          'One of the fields for the profile is null:\nphoto: $photo, \nname: $name\nlastName: $lastName\nemail: $email'));
      return;
    }
    emit(const MyProfileLoading());

    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_photos')
        .child(id + '.jpg');

    await ref.putFile(photo);
    final url = await ref.getDownloadURL();

    myProfile = Profile(
      type: ProfileType.user,
      id: id,
      name: name,
      firstName: firstName ?? "",
      lastName: lastName ?? "",
      email: email,
      phoneCountry: phoneCountry ?? "",
      phoneCountryCode: phoneCountryCode ?? "",
      phoneNumber: phoneNumber ?? "",
      kudos: 0,
      photo: url,
      createdDate: DateTime.now(),
      carerInCaregroups: [],
      tandcsAccepted: false,
      showInvitationsOnHomePage: true,
      showOtherCaregropusOnHomePage: true,
      messagingToken: "",
    );

    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref('profiles');
      reference.child(myProfile.id).set(myProfile.toJson());
    } catch (error) {
      emit(MyProfileError(error.toString()));
    }
    fetchMyProfile(id);
  }


  //
  // editProfile(
  //     {required Profile profile,
  //     required ProfileField profileField,
  //     required dynamic newValue}) {
  //   emit(const MyProfileLoading());
  //
  //   editProfileFieldRepository(
  //       profile: profile, profileField: profileField, newValue: newValue);
  // }



}
