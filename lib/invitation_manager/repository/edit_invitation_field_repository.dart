import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:firebase_database/firebase_database.dart';

class EditInvitationFieldRepository {
  Future<Invitation> call(
      {required Invitation invitation,
      required InvitationField invitationField,
      required dynamic newValue}) async {
    Invitation newInvitation = invitation;
    late String field;
    // ignore: prefer_typing_uninitialized_variables
    late var value;
    switch (invitationField) {
      case InvitationField.caregroupId:
        newInvitation.caregroupId = newValue;
        field = 'caregroupId';
        value = newValue;
        break;
      case InvitationField.status:
        newInvitation.status = newValue;
        field = 'status';
        value = newValue;
        break;
      case InvitationField.email:
        newInvitation.email = newValue;
        field = 'email';
        value = newValue;
        break;

      case InvitationField.message:
        newInvitation.message = newValue;
        field = 'message';
        value = newValue;
        break;
      case InvitationField.invitedById:
        newInvitation.invitedById = newValue;
        field = 'invitedById';
        value = newValue;
        break;
      case InvitationField.invitedDate:
        newInvitation.invitedDate = newValue;
        field = 'invitedDate';
        value = newValue;
        break;
    }

    DatabaseReference reference =
        FirebaseDatabase.instance.ref("invitations/${invitation.id}/$field");

    reference.set(value);
    return newInvitation;
  }
}
