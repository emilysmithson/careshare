part of 'my_invitations_cubit.dart';

abstract class MyInvitationsState extends Equatable {
  const MyInvitationsState();

  @override
  List<Object> get props => [];
}

class MyInvitationsInitial extends MyInvitationsState {}

class MyInvitationsLoading extends MyInvitationsState {
  const MyInvitationsLoading();
}

class MyInvitationsListEmpty extends MyInvitationsState {}

class MyInvitationsError extends MyInvitationsState {
  final String message;

  const MyInvitationsError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyInvitationsError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class MyInvitationsLoaded extends MyInvitationsState {
  final List<Invitation> myInvitationsList;
  // final Invitation? myInvitation;

  const MyInvitationsLoaded({
    required this.myInvitationsList,
    // required this.myInvitation,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyInvitationsLoaded && listEquals(other.myInvitationsList, myInvitationsList);
  }

  @override
  int get hashCode => myInvitationsList.hashCode;
}
