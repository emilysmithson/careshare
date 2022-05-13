part of 'invitations_cubit.dart';

abstract class InvitationState extends Equatable {
  const InvitationState();

  @override
  List<Object> get props => [];
}

class InvitationInitial extends InvitationState {}

class InvitationLoading extends InvitationState {
  const InvitationLoading();
}

class InvitationListEmpty extends InvitationState {}

class InvitationError extends InvitationState {
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

class InvitationLoaded extends InvitationState {
  final List<Invitation> invitationList;
  // final Invitation? myInvitation;

  const InvitationLoaded({
    required this.invitationList,
    // required this.myInvitation,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is InvitationLoaded && listEquals(other.invitationList, invitationList);
  }

  @override
  int get hashCode => invitationList.hashCode;
}
