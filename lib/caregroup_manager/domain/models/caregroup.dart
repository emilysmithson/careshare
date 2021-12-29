import 'caregroup_status.dart';

class Caregroup {
  late String? name;
  late String? details;
  late String? id;
  late String? carees;
  CaregroupStatus status;
  DateTime? dateCreated;
  late String? createdBy;

  Caregroup({
    this.id,
    this.name,
    this.details,
    this.carees,
    required this.status,
    this.dateCreated,
    this.createdBy,

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'details': details,
      'carees': carees,
      'status': status.status,
      'created_by': createdBy,
      'date_created': dateCreated.toString(),
    };
  }

  Caregroup.fromJson(dynamic key, dynamic value):
        name =   value['name'].toString(),
        details =   value['details'].toString(),
        createdBy = value['created_by'].toString(),
        dateCreated = DateTime.parse(value['date_created']),
        carees = value['carees'].toString(),
        status = CaregroupStatus.CaregroupStatusList. firstWhere((element) => element.status == value['status']),
      id = key.toString()
  ;

}
