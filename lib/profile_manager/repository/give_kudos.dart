import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../my_profile/models/profile.dart';

class GiveKudos {
  Future<Profile> call(
      {required Profile profile,
      required String caregroupId,
      required int kudos}) async {
    RoleInCaregroup roleInCaregroup = profile.carerInCaregroups
        .firstWhere((element) => element.caregroupId == caregroupId);

    int newKudosValue = roleInCaregroup.kudosValue + kudos;
    int newKudosCount = roleInCaregroup.kudosCount + 1;

    DatabaseReference reference = FirebaseDatabase.instance.ref(
        "profiles/${profile.id}/carer_in/${roleInCaregroup.id}/kudos_count");
    try {
      reference.set(newKudosCount);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    reference = FirebaseDatabase.instance.ref(
        "profiles/${profile.id}/carer_in/${roleInCaregroup.id}/kudos_value");
    try {
      reference.set(newKudosValue);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return profile;
  }
}
