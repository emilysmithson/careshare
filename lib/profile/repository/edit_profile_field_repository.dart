import 'package:careshare/profile/models/profile.dart';
import 'package:firebase_database/firebase_database.dart';

class EditProfileFieldRepository {
  Profile call(
      {required Profile profile,
      required ProfileField profileField,
      required dynamic newValue}) {
    Profile newProfile = profile;
    late String field;
    // ignore: prefer_typing_uninitialized_variables
    late var value;
    switch (profileField) {
      case ProfileField.name:
        newProfile.name = newValue;
        field = 'name';
        value = newValue;
        break;
      case ProfileField.email:
        newProfile.email = newValue;
        field = 'email';
        value = newValue;
        break;
    }

    DatabaseReference reference =
        FirebaseDatabase.instance.ref("profiles_test/${profile.id}/$field");

    reference.set(value);
    return newProfile;
  }
}
