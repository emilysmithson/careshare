import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/models/caregroup_status.dart';
import 'package:careshare/caregroup_manager/models/caregroup_type.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';

class CreateACaregroup {
  Future<Caregroup> call(String name) async {
    final caregroup = Caregroup(
      name: name,
      details: "",
      status: CaregroupStatus.draft,
      type: CaregroupType.open,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdDate: DateTime.now(),
      createdBy: FirebaseAuth.instance.currentUser!.uid,
      test: false,
    );
    DatabaseReference reference = FirebaseDatabase.instance.ref('caregroups');

    reference.child(caregroup.id).set(caregroup.toJson());

    return caregroup;
  }
}
