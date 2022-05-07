class InvitationStatus {
  final String status;

  const InvitationStatus(this.status);

  static const InvitationStatus invited = InvitationStatus('invited');
  static const InvitationStatus accepted = InvitationStatus('accepted');
  static const InvitationStatus rejected = InvitationStatus('rejected');

  static List<InvitationStatus> invitationStatusList = [
    invited,
    accepted,
    rejected,
  ];
}
