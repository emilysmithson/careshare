class Profile {
  String name;
  String firstName;
  String lastName;
  String email;
  final String? id;
  String photo;

  int kudos;

  Profile({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.photo,
    required this.kudos,
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
}
