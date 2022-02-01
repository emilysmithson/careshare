class Profile {
  String name;
  String email;
  final String? id;

  Profile({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Profile.fromJson(dynamic json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    name: $name,
    email: $email,

    ''';
  }
}

enum ProfileField {
  name,
  email,
}