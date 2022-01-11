import 'package:careshare/caregroup_manager/domain/models/caregroup_status.dart';
import 'package:careshare/profile_manager/domain/models/profile.dart';

class Caregroup {
  late String? name;
  late String? details;
  late String? id;
  late String? carees;
  late String? carers;
  late List<String>? careeList;
  late List<String>? carerList;
  late List<Profile>? careeProfiles;
  late List<Profile>? carerProfiles;
  CaregroupStatus status;
  DateTime? dateCreated;
  late String? createdBy;

  Caregroup({
    this.id,
    this.name,
    this.details,
    this.carees,
    this.carers,
    this.careeList,
    this.carerList,
    this.careeProfiles,
    this.carerProfiles,
    required this.status,
    this.dateCreated,
    this.createdBy,

  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'details': details,
      'carees': carees,
      'carers': carers,
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
        carers = value['carers'].toString(),
        status = CaregroupStatus.caregroupStatusList. firstWhere((element) => element.status == value['status']),
      id = key.toString()
  ;

}
