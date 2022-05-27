import 'package:careshare/caregroup_manager/models/caregroup_carer.dart';
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
  bool test;
  DateTime? lastReminders;
  List<CarerInCaregroup>? carers = [];

  Caregroup({
    required this.id,
    required this.name,
    required this.details,
    required this.status,
    required this.type,
    this.photo,
    required this.createdDate,
    required this.test,
    required this.createdBy,
    required this.lastReminders,
  });

  factory Caregroup.fromJson(dynamic key, dynamic value) {
    final status = CaregroupStatus.caregroupStatusList.firstWhere((element) => element.status == value['status']);

    return Caregroup(
      id: key,
      name: value['name'] ?? "",
      details: value['details'] ?? "",
      status: status,
      type: CaregroupType.caregroupTypeList.firstWhere((element) => element.type == value['type']),
      photo: value['photo'] ?? "",
      createdDate: DateTime.parse(value['created_date']),
      createdBy: value['created_by'] ?? '',
      test: value['test'],
      lastReminders: (value['last_reminders'] != null) ? DateTime.parse(value['last_reminders']) : null,
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
      'test': test,
      'last_reminders': lastReminders,
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
    test: $test,
    lastReminders: $lastReminders,
    ''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Caregroup &&
        other.id == id &&
        other.name == name &&
        other.details == details &&
        other.status == status &&
        other.type == type &&
        other.photo == photo &&
        other.createdDate == createdDate &&
        other.createdBy == createdBy &&
        other.test == test &&
        other.lastReminders == lastReminders;
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
      createdBy.hashCode ^
      test.hashCode ^
      lastReminders.hashCode;
}

enum CaregroupField {
  name,
  details,
  status,
  type,
  photo,
  createdDate,
  createdBy,
  test,
  lastReminders,
}
