class Profile {
  String name;
  String email;
  final String? id;
  String nickName;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    required this.nickName,
  });

  factory Profile.fromJson(dynamic json) {
    return Profile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      nickName: json['nick_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'nick_name': nickName,
    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    name: $name,
    email: $email,
    nickName: $nickName,
    ''';
  }
}
