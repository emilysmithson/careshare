

class Caregroup {
  final String id;
  String name;
  String? photo;
  List<String>? carees = [];
  List<String>? members = [];


  Caregroup({
    required this.id,
    required this.name,
    this.photo,
    this.carees,
    this.members,
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
      'photo': photo,

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
