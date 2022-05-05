

class Caregroup {
  final String id;
  String name;
  String? photo;
  DateTime createdDate;
  List<String>? carees = [];
  List<String>? members = [];


  Caregroup({
    required this.id,
    required this.name,
    this.photo,
    required this.createdDate,
    this.carees,
    this.members,
  });

  factory Caregroup.fromJson(dynamic key, dynamic value) {

    return Caregroup(
      id: key,
      name: value['name'] ?? "",
      photo: value['photo'] ?? "",
      createdDate: DateTime.parse(value['created_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photo': photo,
      'created_date': createdDate.toString(),
    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    name: $name,
    createdDate: $createdDate,
    ''';
  }
}

enum CaregroupField {
  name,
  photo,
  createdDate,
}
