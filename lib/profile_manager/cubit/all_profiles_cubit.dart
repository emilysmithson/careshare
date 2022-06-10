import 'package:bloc/bloc.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/profile_manager/repository/add_role_in_caregroup_to_profile.dart';
import 'package:careshare/profile_manager/repository/complete_task.dart';
import 'package:careshare/profile_manager/repository/give_kudos.dart';
import 'package:equatable/equatable.dart';
import 'package:careshare/profile_manager/repository/edit_profile_field_repository.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

part 'all_profiles_state.dart';

class AllProfilesCubit extends Cubit<AllProfilesState> {
  final EditProfileFieldRepository editProfileFieldRepository;
  final GiveKudos giveKudos;
  final AddRoleInCaregroupToProfile addCarerInCaregroupToProfile;
  final CompleteTask completeTask;
  final List<Profile> profileList = [];
  late Profile myProfile;

  AllProfilesCubit({
    required this.editProfileFieldRepository,
    required this.addCarerInCaregroupToProfile,
    required this.giveKudos,
    required this.completeTask,
  }) : super(AllProfilesInitial());

  Future fetchProfiles({required String caregroupId}) async {
    try {
      emit(const AllProfilesLoading());
      DatabaseReference reference = FirebaseDatabase.instance.ref('profiles');
      final response = reference.onValue;

      response.listen((event) async {
        emit(AllProfilesLoading());
        Map<dynamic, dynamic> returnedList;
        if (event.snapshot.value == null) {
          if (kDebugMode) {
            print('empty profile list');
            returnedList = {};
          }
        } else {
          returnedList = event.snapshot.value as Map<dynamic, dynamic>;
          profileList.clear();
          returnedList.forEach(
            (key, value) async {
              Profile profile = Profile.fromJson(key, value);
              if (profile.carerInCaregroups.indexWhere((element) => element.caregroupId == caregroupId) != -1) {
                profileList.add(profile);
              }
            },
          );

          profileList.sort((a, b) => a.name.compareTo(b.name));
          emit(AllProfilesLoaded(profileList: profileList));
        }
      });
    } catch (error) {
      emit(
        AllProfilesError(
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
      name = profileList.firstWhere((element) => element.id == id).displayName;
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

  editProfile({required Profile profile, required ProfileField profileField, required dynamic newValue}) {
    emit(const AllProfilesLoading());

    editProfileFieldRepository(profile: profile, profileField: profileField, newValue: newValue);
  }

  addKudos(String id) {
    Profile profile = profileList.firstWhere((element) => element.id == id);

    int newKudos = profile.kudos + 1;

    editProfile(newValue: newKudos, profile: profile, profileField: ProfileField.kudos);

    emit(AllProfilesLoaded(profileList: profileList));
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
