class ProfileRole {
  final String role;

  const ProfileRole(this.role);

  static const ProfileRole administrator = ProfileRole('administrator');
  static const ProfileRole member = ProfileRole('member');
  static const ProfileRole disabled = ProfileRole('disabled');

  static List<ProfileRole> profileRoleList = [
    administrator,
    member,
    disabled,
  ];
}
