

import 'package:careshare/caregroup_manager/models/caregroup_status.dart';
import 'package:careshare/caregroup_manager/models/caregroup_type.dart';

class Caregroup {
  final String id;
  String name;
  String details;
  CaregroupStatus status;
  CaregroupType type;
  String? photo;
  DateTime createdDate;
  String? createdBy;


  Caregroup({
    required this.id,
    required this.name,
    required this.details,
    required this.status,
    required  this.type,
    this.photo,
    required this.createdDate,
    required this.createdBy,
  });

  factory Caregroup.fromJson(dynamic key, dynamic value) {
    final status = CaregroupStatus.CaregroupStatusList
        .firstWhere((element) => element.status == value['status']);

    return Caregroup(
      id: key,
      name: value['name'] ?? "",
      details: value['details'] ?? "",
      status: status,
      type:  CaregroupType.caregroupTypeList
          .firstWhere((element) => element.type == value['type']),
      photo: value['photo'] ?? "",
      createdDate: DateTime.parse(value['created_date']),
      createdBy: value['created_by'] ?? '',

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
      'status': status.status,
      'type': type.type,
      'photo': photo,
      'created_date': createdDate.toString(),
      'created_by': createdBy,

    };
  }

  @override
  String toString() {
    return '''
    id: $id,
    name: $name,
    details: $details,
    status: $status,
    type: $type
    photo: $photo
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
        && other.status == status
        && other.type == type
        && other.photo == photo
        && other.createdDate == createdDate
        && other.createdBy == createdBy
    ;


  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      details.hashCode ^
      status.hashCode ^
      type.hashCode ^
      photo.hashCode ^
      createdDate.hashCode ^
      createdBy.hashCode

  ;
}



enum CaregroupField {
  name,
  details,
  status,
  type,
  photo,
  createdDate,
  createdBy,
}
