import 'package:bloc/bloc.dart';

import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/invitation_manager/models/invitation_status.dart';
import 'package:equatable/equatable.dart';
import 'package:careshare/invitation_manager/repository/edit_invitation_field_repository.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'invitations_state.dart';

class InvitationsCubit extends Cubit<InvitationState> {
  final EditInvitationFieldRepository editInvitationFieldRepository;
  final List<Invitation> invitationList = [];

  InvitationsCubit({
    required this.editInvitationFieldRepository,
  }) : super(InvitationInitial());

  sendInvitation({
    required String id,
    required String caregroupId,
    required String email,
    String? message,
    // required List<String> careeInCaregroups,
    // required List<String> carerInCaregroups,
  }) async {
    emit(const InvitationLoading());

    Invitation invitation = Invitation(
      caregroupId: caregroupId,
      id: id,
      email: email,
      message: message,
      invitedById: FirebaseAuth.instance.currentUser!.uid,
      invitedDate: DateTime.now(),
      status: InvitationStatus.invited,
    );
    try {
      DatabaseReference reference = FirebaseDatabase.instance.ref('invitations');

      reference.child(invitation.id).set(invitation.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    emit(InvitationLoaded(invitationList: invitationList));
  }

  Future fetchInvitations({required String caregroupId}) async {
    try {
      emit(const InvitationLoading());
      final reference = FirebaseDatabase.instance.ref('invitations').orderByChild('caregroup_id').equalTo(caregroupId);

      final response = reference.onValue;

      response.listen((event) async {
        if (event.snapshot.value == null) {
          if (kDebugMode) {
            print('empty invitations list');
          }
        }
        Map<dynamic, dynamic> returnedList = event.snapshot.value as Map<dynamic, dynamic>;
        invitationList.clear();
        returnedList.forEach(
          (key, value) async {
            Invitation invitation = Invitation.fromJson(value);

            invitationList.add(invitation);
          },
        );

        invitationList.sort((a, b) => a.email.compareTo(b.email));
        emit(InvitationLoaded(invitationList: invitationList));
      });
    } catch (error) {
      emit(
        InvitationError(
          error.toString(),
        ),
      );
    }
  }

  clearList() {
    invitationList.clear();
  }

  editInvitation(
      {required Invitation invitation, required InvitationField invitationField, required dynamic newValue}) {
    emit(const InvitationLoading());

    editInvitationFieldRepository(invitation: invitation, invitationField: invitationField, newValue: newValue);
  }
}
