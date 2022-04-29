class Caregroup {
  final String id;
  String name;
  String photo;

  Caregroup({
    required this.id,
    required this.name,
    required this.photo,
  });

  factory Caregroup.fromJson(dynamic key, dynamic value) {

    return Caregroup(
      id: key,
      name: value['name'] ?? "",
      photo: value['photo'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photo': photo
    };
  }

  @override
  String toString() {
    return '''
    name: $name,
    ''';
  }
}

enum CaregroupField {
  name,
  photo,
}
