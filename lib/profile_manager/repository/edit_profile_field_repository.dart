import 'package:careshare/profile_manager/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfileFieldRepository {
  Future<Profile> call(
      {required Profile profile, required ProfileField profileField, required dynamic newValue}) async {
    Profile newProfile = profile;
    late String field;
    // ignore: prefer_typing_uninitialized_variables
    late var value;
    switch (profileField) {
      case ProfileField.type:
        newProfile.name = newValue;
        field = 'type';
        value = newValue;
        break;
      case ProfileField.name:
        newProfile.name = newValue;
        field = 'name';
        value = newValue;
        break;
      case ProfileField.messagingToken:
        newProfile.messagingToken = newValue;
        field = 'messaging_token';
        value = newValue;
        break;
      case ProfileField.firstName:
        newProfile.firstName = newValue;
        field = 'first_name';
        value = newValue;
        break;
      case ProfileField.lastName:
        newProfile.lastName = newValue;
        field = 'last_name';
        value = newValue;
        break;
      case ProfileField.email:
        newProfile.email = newValue;
        field = 'email';
        value = newValue;
        break;
      case ProfileField.phoneCountry:
        newProfile.phoneCountry = newValue;
        field = 'phone_country';
        value = newValue;
        break;
      case ProfileField.phoneCountryCode:
        newProfile.phoneCountryCode = newValue;
        field = 'phone_country_code';
        value = newValue;
        break;

      case ProfileField.phoneNumber:
        newProfile.phoneNumber = newValue;
        field = 'phone_number';
        value = newValue;
        break;

      case ProfileField.dateOfBirth:
        newProfile.dateOfBirth = newValue;
        field = 'date_of_birth';
        value = newValue.toString();
        break;

      case ProfileField.kudos:
        newProfile.kudos = newValue;
        field = 'kudos';
        value = newValue;
        break;
      case ProfileField.tandcsAccepted:
        newProfile.tandcsAccepted = newValue;
        field = 'tandcs_accepted';
        value = newValue;
        break;
      case ProfileField.setupComplete:
        newProfile.setupComplete = newValue;
        field = 'setup_complete';
        value = newValue;
        break;
      case ProfileField.showInvitationsOnHomePage:
        newProfile.showInvitationsOnHomePage = newValue;
        field = 'show_invitations_on_homepage';
        value = newValue;
        break;
      case ProfileField.showOtherCaregroupsOnHomePage:
        newProfile.showOtherCaregroupsOnHomePage = newValue;
        field = 'show_other_caregroups_on_homepage';
        value = newValue;
        break;
      case ProfileField.photo:
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_photos')
            .child(FirebaseAuth.instance.currentUser!.uid + '.jpg');

        await ref.putFile(newValue);
        final url = await ref.getDownloadURL();
        newProfile.photo = url;
        field = 'photo';
        value = url;
        break;
      case ProfileField.photoUrl:
        field = 'photo';
        value = newValue;
        break;
    }

    DatabaseReference reference = FirebaseDatabase.instance.ref("profiles/${profile.id}/$field");

    reference.set(value);
    return newProfile;
  }
}
