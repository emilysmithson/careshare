import 'package:bloc/bloc.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';

import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

part 'my_invitations_state.dart';

class MyInvitationsCubit extends Cubit<MyInvitationsState> {
  final List<Invitation> myInvitationsList = [];

  MyInvitationsCubit() : super(MyInvitationsInitial());

  Future fetchMyInvitations({
    required String email,
    required List<Caregroup> myCaregroupList,
  }) async {
    try {
      // print('.....fetching invitations for: $email');
      emit(const MyInvitationsLoading());
      Map<dynamic, dynamic> returnedList;
      final reference = FirebaseDatabase.instance.ref('invitations');

      final response = reference.onValue;

      response.listen((event) async {
        if (event.snapshot.value == null) {
          if (kDebugMode) {
            print('empty my invitations list');
            returnedList = {};
          }
        } else {
          returnedList = event.snapshot.value as Map<dynamic, dynamic>;
          myInvitationsList.clear();
          returnedList.forEach(
            (key, value) async {
              Invitation invitation = Invitation.fromJson(value);
              if (invitation.email == email &&
                  myCaregroupList.indexWhere((caregroup) => caregroup.id == invitation.caregroupId) == -1) {
                myInvitationsList.add(invitation);
              }
            },
          );

          myInvitationsList.sort((a, b) => a.email.compareTo(b.email));

          // print('.....invitiations loaded: ${myInvitationsList.length}');
          emit(MyInvitationsLoaded(myInvitationsList: myInvitationsList));
        }
      });
    } catch (error) {
      emit(
        MyInvitationsError(
          error.toString(),
        ),
      );
    }
  }

  clearList() {
    myInvitationsList.clear();
  }
}
