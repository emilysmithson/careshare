import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/repository/create_a_caregroup.dart';
import 'package:equatable/equatable.dart';
import 'package:careshare/caregroup_manager/repository/edit_caregroup_field_repository.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

part 'caregroup_state.dart';

class CaregroupCubit extends Cubit<CaregroupState> {
  final CreateACaregroup createACaregroupRepository;
  final EditCaregroupFieldRepository editCaregroupFieldRepository;
  final List<Caregroup> caregroupList = [];
  late Caregroup myCaregroup;

  CaregroupCubit({
    required this.createACaregroupRepository,
    required this.editCaregroupFieldRepository,
  }) : super(CaregroupInitial());

  Future<Caregroup?> draftCaregroup(String title) async {
    Caregroup? caregroup;
    try {
      caregroup = await createACaregroupRepository(title);

      return caregroup;
    } catch (e) {
      emit(CaregroupError(e.toString()));
    }
    if (Caregroup == null) {
      emit(
        const CaregroupError('Something went wrong, Caregroup is null'),
      );
    }
    return null;
  }

  createCaregroup({
    required File photo,
    required String name,
    String? firstName,
    String? lastName,
    required String email,
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
      photo: url,
      createdDate: DateTime.now(),
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

  Future fetchCaregroups() async {
    print('fetching caaregroups');
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
