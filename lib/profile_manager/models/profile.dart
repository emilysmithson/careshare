
class Profile {
  String name;
  String firstName;
  String lastName;
  String email;
  final String? id;
  String? photo;
  String? photoURL;

  Profile({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.photo,
    this.photoURL,
  });

  factory Profile.fromJson(dynamic json) {
    return Profile(
        id: json['id'],
        name: json['name'] ?? "",
        firstName: json['first_name'] ?? "",
        lastName: json['last_name'] ?? "",
        email: json['email'] ?? "",
        photo: json['photo']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
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

    ''';
  }
}

enum ProfileField {
  name,
  firstName,
  lastName,
  email,
}
