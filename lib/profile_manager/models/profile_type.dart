class ProfileType {
  final String type;
  final String definition;

  const ProfileType(this.type, this.definition);

  static const ProfileType user = ProfileType('user', 'Careshare user');
  static const ProfileType administrator = ProfileType('administrator', 'Careshare administrator');

  static List<ProfileType> profileTypeList = [
    user,
    administrator,
  ];
}
