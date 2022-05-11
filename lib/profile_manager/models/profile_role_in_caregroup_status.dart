class ProfileRoleInCaregroupStatus {
  final String status;

  const ProfileRoleInCaregroupStatus(this.status);

  static const ProfileRoleInCaregroupStatus invited =
      ProfileRoleInCaregroupStatus('invited');
  static const ProfileRoleInCaregroupStatus accepted =
      ProfileRoleInCaregroupStatus('accepted');
  static const ProfileRoleInCaregroupStatus declined =
      ProfileRoleInCaregroupStatus('declined');

  static List<ProfileRoleInCaregroupStatus> profileRoleInCaregroupStatusList = [
    invited,
    accepted,
    declined,
  ];
}
