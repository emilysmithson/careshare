import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/models/caregroup_carer.dart';
import 'package:careshare/caregroup_manager/models/caregroup_carer_status.dart';
import 'package:careshare/profile_manager/models/profile_role.dart';
import 'package:firebase_database/firebase_database.dart';

class AddCarerInCaregroupToCaregroup {
  Future<CarerInCaregroup> call({
    required String profileId,
    required String caregroupId,
  }) async {

    final carerInCaregroup = CarerInCaregroup(
      id: profileId,
      profileId: profileId,
      role: ProfileRole.member,
      status: CaregroupCarerStatus.active,
    );
    DatabaseReference reference = FirebaseDatabase.instance.ref('caregroups/$caregroupId/carers');

    reference.child(carerInCaregroup.id!).set(carerInCaregroup.toJson());

    return carerInCaregroup;
  }
}
