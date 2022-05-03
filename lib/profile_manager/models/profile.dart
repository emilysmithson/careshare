class Profile {
  String name;
  String firstName;
  String lastName;
  String email;
  final String? id;
  String photo;

  int kudos;

  // List<String> careeInCaregroups;
  // List<String> carerInCaregroups;

  Profile({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photo,
    required this.kudos,
    // required this.careeInCaregroups,
    // required this.carerInCaregroups,
  });

  factory Profile.fromJson(dynamic json) {
    return Profile(
      id: json['id'],
      name: json['name'] ?? "",
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      email: json['email'] ?? "",
      photo: json['photo'] ?? "",
      kudos: json['kudos'] ?? 0,
      // careeInCaregroups: json['caree_in_caregroups'] ?? [],
      // carerInCaregroups: json['carer_in_caregroups'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'kudos': kudos,
      'photo': photo
    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    name: $name,
    firstName: $firstName,
    lastName: $lastName,
    email: $email,
    kudos: $kudos,
    ''';
  }
}

enum ProfileField {
  name,
  firstName,
  lastName,
  email,
  kudos,
  photo,
}
