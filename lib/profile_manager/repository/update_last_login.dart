import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'package:careshare/profile_manager/models/profile.dart';

class UpdateLastLogin {
  Future<Profile> call({required Profile profile, required String caregroupId}) async {
    RoleInCaregroup roleInCaregroup =
        profile.carerInCaregroups.firstWhere((element) => element.caregroupId == caregroupId);

    DatabaseReference reference =
        FirebaseDatabase.instance.ref("profiles/${profile.id}/carer_in/${roleInCaregroup.caregroupId}/last_login");
    try {
      reference.set(DateTime.now().toString());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return profile;
  }
}
