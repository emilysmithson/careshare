import 'package:careshare/caregroup_manager/models/caregroup.dart';

import 'package:firebase_database/firebase_database.dart';

class CreateACaregroup {
  Future<Caregroup> call(String name) async {
    final caregroup = Caregroup(
      name: name,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdDate: DateTime.now(),
    );
    DatabaseReference reference = FirebaseDatabase.instance.ref('caregroups');

    reference.child(caregroup.id).set(caregroup.toJson());

    return caregroup;
  }
}
