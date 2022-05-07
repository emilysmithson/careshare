

import 'package:careshare/caregroup_manager/models/caregroup_type.dart';

class Caregroup {
  final String id;
  String name;
  String details;
  CaregroupType type;
  String? photo;
  DateTime createdDate;
  List<String>? carees = [];
  List<String>? members = [];


  Caregroup({
    required this.id,
    required this.name,
    required this.details,
    required  this.type,
    this.photo,
    required this.createdDate,
    this.carees,
    this.members,
  });

  factory Caregroup.fromJson(dynamic key, dynamic value) {

    return Caregroup(
      id: key,
      name: value['name'] ?? "",
      details: value['details'] ?? "",
      type:  CaregroupType.caregroupTypeList
          .firstWhere((element) => element.type == value['type']),
      photo: value['photo'] ?? "",
      createdDate: DateTime.parse(value['created_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'status': type.type,
      'photo': photo,
      'created_date': createdDate.toString(),
    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    name: $name,
    details: $details,
    type: $type
    createdDate: $createdDate,
    ''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Caregroup
        && other.id == id
        && other.name == name
        && other.details == details
        && other.type == type
        && other.createdDate == createdDate
    ;


  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      details.hashCode ^
      type.hashCode ^
      createdDate.hashCode
  ;
}



enum CaregroupField {
  name,
  details,
  photo,
  createdDate,
}
