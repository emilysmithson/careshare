import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import '../domain/errors/caregroup_manager_exception.dart';
import '../domain/models/caregroup.dart';
import '../infrastructure/datasources/caregroup_datasouce.dart';

class CaregroupDatasourceImpl implements CaregroupDatasource {

  @override
  Future<String> createCaregroup(Caregroup caregroup) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("caregroups");
    final String newkey = reference.push().key as String;
    reference.child(newkey).set(caregroup.toJson());

    return newkey;
  }

  @override
  Future editCaregroup(Caregroup caregroup) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("caregroups/${caregroup.id}");

    await reference.set(caregroup.toJson());
  }


  // FirebaseFirestore.instance
  //     .collection('users')
  //     .where('age', isGreaterThan: 20)
  //     .get()
  //     .then(...);

  @override
  Future<DatabaseEvent> fetchCaregroups({String? search}) async {
    DatabaseReference reference;
    if (search == null) {
      reference = FirebaseDatabase.instance.ref("caregroups");
    }
    else {
      reference = FirebaseDatabase.instance.ref("caregroups/"+search);
    }
    final response = await reference.once();

    return response;
  }

  @override
  Future updateCaregroup(Caregroup caregroup) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("caregroups/${caregroup.id}");

    await reference.set(caregroup.toJson());
  }

  @override
  Future<DatabaseEvent> fetchACaregroup(String id) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("caregroups/${id}");

    final response = await reference.once();
    return response;
  }

  @override
  Future<DatabaseEvent> fetchMyCaregroup() async {

    String? authId = FirebaseAuth.instance.currentUser?.uid;
    print('fetchMyCaregroup: authId: $authId');
    Query query = FirebaseDatabase.instance.ref("caregroups") .orderByChild("auth_id").equalTo(authId).limitToFirst(1);

    final response = await query.once();
    return response;
  }


  @override
  Future removeACaregroup(String caregroupId) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("caregroups/$caregroupId");
    reference.remove();
  }

  @override
  Future<Either<CaregroupManagerException, bool>> saveCaregroupPhoto(File photo) {
    // TODO: implement saveCaregroupPhoto
    throw UnimplementedError();
  }
}
