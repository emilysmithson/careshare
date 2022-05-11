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

part 'caregroup_state.dart';

class CaregroupCubit extends Cubit<CaregroupState> {
  final CreateACaregroup createACaregroupRepository;
  final RemoveACaregroup removeACaregroupRepository;
  final AddCarerInCaregroupToCaregroup addCarerInCaregroupToCaregroup;

  final EditCaregroupFieldRepository editCaregroupFieldRepository;
  final List<Caregroup> caregroupList = [];
  final List<String> carerIds = [];
  late Caregroup myCaregroup;

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
    emit(CaregroupLoaded(caregroupList: caregroupList));
  }

  removeCaregroup(String id) {
    emit(const CaregroupLoading());
    removeACaregroupRepository(id);
    caregroupList.removeWhere((element) => element.id == id);

    emit(
      CaregroupLoaded(
        caregroupList: caregroupList,
      ),
    );
  }

  Future fetchCaregroups() async {
    try {
      emit(const CaregroupLoading());
      DatabaseReference reference = FirebaseDatabase.instance.ref('caregroups');
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
          caregroupList.clear();
          returnedList.forEach(
            (key, value) async {
              Caregroup caregroup = Caregroup.fromJson(key, value);

              caregroupList.add(caregroup);
            },
          );

          caregroupList.sort((a, b) => a.name.compareTo(b.name));
          emit(CaregroupLoaded(caregroupList: caregroupList));
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
