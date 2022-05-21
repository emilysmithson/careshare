import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/models/caregroup_status.dart';
import 'package:careshare/caregroup_manager/models/caregroup_type.dart';
import 'package:careshare/caregroup_manager/repository/add_carer_in_caregroup_to_caregroup.dart';
import 'package:careshare/caregroup_manager/repository/create_a_caregroup.dart';
import 'package:careshare/caregroup_manager/repository/remove_a_caregroup.dart';
import 'package:equatable/equatable.dart';
import 'package:careshare/caregroup_manager/repository/edit_caregroup_field_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:careshare/profile_manager/models/profile.dart';

part 'caregroup_state.dart';

class CaregroupCubit extends Cubit<CaregroupState> {
  final CreateACaregroup createACaregroupRepository;
  final RemoveACaregroup removeACaregroupRepository;
  final AddCarerInCaregroupToCaregroup addCarerInCaregroupToCaregroup;

  final EditCaregroupFieldRepository editCaregroupFieldRepository;
  final List<Caregroup> caregroupList = [];
  late List<Caregroup> myCaregroupList = [];
  late List<Caregroup> otherCaregroupList = [];
  final List<String> carerIds = [];
  bool isInitialised = false;

  CaregroupCubit({
    required this.createACaregroupRepository,
    required this.removeACaregroupRepository,
    required this.editCaregroupFieldRepository,
    required this.addCarerInCaregroupToCaregroup,
  }) : super(CaregroupInitial());

  Future<Caregroup?> draftCaregroup(String title) async {
    Caregroup? caregroup;
    try {
      caregroup = await createACaregroupRepository(title);

      return caregroup;
    } catch (e) {
      emit(CaregroupError(e.toString()));
    }
    return null;
  }

  createCaregroup({
    required File photo,
    required String name,
    required String details,
    required CaregroupStatus status,
    required CaregroupType type,
    required String id,
  }) async {
    emit(const CaregroupLoading());
    final ref = FirebaseStorage.instance
        .ref()
        .child('caregroup_photos')
        .child(id + '.jpg');

    await ref.putFile(photo);
    final url = await ref.getDownloadURL();

    Caregroup caregroup = Caregroup(
      id: id,
      name: name,
      details: details,
      status: status,
      type: type,
      photo: url,
      createdDate: DateTime.now(),
      createdBy: FirebaseAuth.instance.currentUser!.uid,
    );
    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref('caregroups');

      reference.child(caregroup.id).set(caregroup.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    emit(CaregroupsLoaded(
        caregroupList: caregroupList,
        myCaregroupList: myCaregroupList,
        otherCaregroupList: otherCaregroupList,
    ));
  }

  removeCaregroup(String id) {
    emit(const CaregroupLoading());
    removeACaregroupRepository(id);
    caregroupList.removeWhere((element) => element.id == id);

    emit(
      CaregroupsLoaded(
        caregroupList: caregroupList,
        myCaregroupList: myCaregroupList,
        otherCaregroupList: otherCaregroupList,
      ),
    );
  }

  // Future fetchCaregroups() async {
  //   try {
  //     emit(const CaregroupLoading());
  //     DatabaseReference reference = FirebaseDatabase.instance.ref('caregroups');
  //     final response = reference.onValue;

  //     response.listen((event) async {
  //       if (event.snapshot.value == null) {
  //         if (kDebugMode) {
  //           print('empty list');
  //         }
  //         return;
  //       } else {
  //         Map<dynamic, dynamic> returnedList =
  //             event.snapshot.value as Map<dynamic, dynamic>;
  //         caregroupList.clear();
  //         returnedList.forEach(
  //           (key, value) async {
  //             Caregroup caregroup = Caregroup.fromJson(key, value);

  //             caregroupList.add(caregroup);
  //           },
  //         );

  //         caregroupList.sort((a, b) => a.name.compareTo(b.name));
  //         emit(CaregroupLoaded(caregroupList: caregroupList));
  //       }
  //     });
  //   } catch (error) {
  //     emit(
  //       CaregroupError(
  //         error.toString(),
  //       ),
  //     );
  //   }
  //   isInitialised = true;
  // }

  Future fetchMyCaregroups({required Profile profile}) async {
    // emit(const CaregroupLoading());
    // caregroupList.clear();
    // for (final role in profile.carerInCaregroups) {
    //   try {
    //     DatabaseReference reference =
    //         FirebaseDatabase.instance.ref('caregroups/${role.caregroupId}');
    //     final response = reference.onValue;
    //
    //     response.listen((event) async {
    //       if (event.snapshot.value == null) {
    //         if (kDebugMode) {
    //           print("caregroup is null");
    //         }
    //         // emit(const CaregroupError("caregroup is null"));
    //         return;
    //       } else {
    //         final data = event.snapshot.value;
    //         final _role = Caregroup.fromJson(role.caregroupId, data);
    //         myCaregroupList.add(_role);
    //         myCaregroupList.sort((a, b) => a.name.compareTo(b.name));
    //
    //         emit(CaregroupLoaded(caregroupList: myCaregroupList));
    //       }
    //     });
    //   } catch (error) {
    //     emit(
    //       CaregroupError(
    //         error.toString(),
    //       ),
    //     );
    //   }
    // }

    emit(const CaregroupLoading());

    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref('caregroups');
      final response = reference.onValue;
      response.listen((event) {
        if (event.snapshot.value == null) {
          if (kDebugMode) {
            print('empty caregroup list');
          }
          return;
        } else {
          Map<dynamic, dynamic> returnedList =
          event.snapshot.value as Map<dynamic, dynamic>;

          caregroupList.clear();
          myCaregroupList.clear();
          otherCaregroupList.clear();

          returnedList.forEach(
                (key, value) {
              caregroupList.add(Caregroup.fromJson(key, value));
            },
          );

          caregroupList.sort((a, b) => a.name.compareTo(b.name));

          // if(profile.carerInCaregroups.isNotEmpty) {

            myCaregroupList = caregroupList.where((caregroup) =>
              profile.carerInCaregroups.indexWhere((element) => element.caregroupId == caregroup.id) != -1
            ).toList();

            otherCaregroupList = caregroupList.where((caregroup) =>
            profile.carerInCaregroups.indexWhere((element) => element.caregroupId == caregroup.id) == -1
            ).toList();

          // }

          print('.....loaded caregroupList: ${caregroupList.length}');
          print('.....loaded myCaregroupList: ${myCaregroupList.length}');
          print('.....loaded otherCaregroupList: ${otherCaregroupList.length}');

          emit(CaregroupsLoaded(
            caregroupList: caregroupList,
            myCaregroupList: myCaregroupList,
            otherCaregroupList: otherCaregroupList,
          ));
        }
      });
    } catch (error) {
      emit(
        CaregroupError(
          error.toString(),
        ),
      );
    }
  }

  clearList() {
    caregroupList.clear();
  }

  String? getName(String id) {
    String? name;
    try {
      name = caregroupList.firstWhere((element) => element.id == id).name;
    } catch (e) {
      return 'no name found';
    }
    return name;
  }

  String? getPhoto(String id) {
    String? photo;
    try {
      photo = caregroupList.firstWhere((element) => element.id == id).photo;
    } catch (e) {
      return "https://firebasestorage.googleapis.com/v0/b/careshare-data.appspot.com/o/nuccia.jpeg?alt=media&token=f9e4cc37-d756-4af5-85e2-18db5b08e897";
    }
    return photo;
  }

  editCaregroup(
      {required Caregroup caregroup,
      required CaregroupField caregroupField,
      required dynamic newValue}) {
    emit(const CaregroupLoading());

    editCaregroupFieldRepository(
        caregroup: caregroup,
        caregroupField: caregroupField,
        newValue: newValue);
  }
}
