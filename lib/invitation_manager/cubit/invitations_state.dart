part of 'invitations_cubit.dart';

abstract class InvitationsState extends Equatable {
  const InvitationsState();

  @override
  List<Object> get props => [];
}

class InvitationInitial extends InvitationsState {}

class InvitationLoading extends InvitationsState {
  const InvitationLoading();
}

class InvitationListEmpty extends InvitationsState {}

class InvitationError extends InvitationsState {
  final String message;

  const InvitationError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InvitationError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class InvitationsLoaded extends InvitationsState {
  final List<Invitation> invitationList;
  // final Invitation? myInvitation;

  const InvitationsLoaded.AllInvitationsLoaded({
    required this.invitationList,
    // required this.myInvitation,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InvitationsLoaded && listEquals(other.invitationList, invitationList);
  }

  @override
  int get hashCode => invitationList.hashCode;
}
