import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/models/profile_role.dart';
import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:careshare/profile_manager/models/profile_role_in_caregroup_status.dart';
import 'package:firebase_database/firebase_database.dart';

class AddCarerInCaregroupToProfile {
  Future<RoleInCaregroup> call({
    required String profileId,
    required String caregroupId,
  }) async {

    final roleInCaregroup = RoleInCaregroup(
      id: caregroupId,
      caregroupId: caregroupId,
      role: ProfileRole.member,
      status: ProfileRoleInCaregroupStatus.accepted,
      completedCount: 0,
      completedValue: 0,
      kudosCount: 0,
      kudosValue: 0,
    );
    DatabaseReference reference = FirebaseDatabase.instance.ref('profiles/$profileId/carer_in');

    reference.child(roleInCaregroup.id!).set(roleInCaregroup.toJson());

    return roleInCaregroup;
  }
}
