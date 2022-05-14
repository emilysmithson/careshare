import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import 'package:careshare/profile_manager/models/profile.dart';

class CompleteTask {
  Future<Profile> call(
      {required Profile profile,
      required String caregroupId,
      required int effort}) async {
    RoleInCaregroup roleInCaregroup = profile.carerInCaregroups
        .firstWhere((element) => element.caregroupId == caregroupId);

    int newCompletedCount = roleInCaregroup.completedCount + 1;
    int newCompletedValue = roleInCaregroup.completedValue + effort;

    DatabaseReference reference = FirebaseDatabase.instance.ref(
        "profiles/${profile.id}/carer_in/${roleInCaregroup.id}/completed_count");
    try {
      reference.set(newCompletedCount);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    reference = FirebaseDatabase.instance.ref(
        "profiles/${profile.id}/carer_in/${roleInCaregroup.id}/completed_value");
    try {
      reference.set(newCompletedValue);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return profile;
  }
}
