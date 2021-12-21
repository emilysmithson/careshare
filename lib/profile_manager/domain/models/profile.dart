import 'dart:io';

class Profile {
  final String? name;
  final String? profileId;
  // final File? profilePhoto;
  final String? authId;

  Profile({
    this.name,
    this.profileId,
    // this.profilePhoto,
    this.authId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name ?? '',
      // 'profile_photo': profilePhoto ?? '',
      'auth_id': authId ?? '',
    };
  }

  Profile.fromJson(key, value)
      : name = value['name'] ?? '',
        profileId = key,
        // profilePhoto = value['profile_photo'],
        authId = value['auth_id'] ?? '';

  Profile copyWith({String? authId, String? name, File? profilePhoto}) {
    return Profile(
      authId: authId ?? this.authId,
      name: name ?? this.name,
      profileId: profileId,
      // profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }

  @override
  String toString() {
    return '''
name: $name
profileId: $profileId
authId: $authId
    ''';
  }
}
