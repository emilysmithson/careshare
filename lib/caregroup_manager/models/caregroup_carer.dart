import 'package:careshare/caregroup_manager/models/caregroup_carer_status.dart';
import 'package:careshare/profile_manager/models/profile_role.dart';

class CarerInCaregroup {
  final String? id;
  final String profileId;
  ProfileRole role;
  CaregroupCarerStatus status;

  CarerInCaregroup({
    required this.id,
    required this.profileId,
    required this.role,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'role': role.role,
      'status': status.status,
    };
  }

  factory CarerInCaregroup.fromJson(dynamic json) {
    // print("caregroupId: ${json['caregroup_id']}");
    // print("json['status']: ${json['status']}");
    // print('########################');
    CarerInCaregroup newCarerInCaregroup = CarerInCaregroup(
      id: json['id'],
      profileId: json['profile_id'],
      role: ProfileRole.profileRoleList
          .firstWhere((element) => element.role == json['role']),
      status: CaregroupCarerStatus.caregroupCarerStatusList
          .firstWhere((element) => element.status == json['status']),
    );

    return newCarerInCaregroup;
  }

  @override
  String toString() {
    return '''
      id: $id,
      profileId: $profileId
      role: $role
      status: $status
      
      ''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CarerInCaregroup &&
        other.profileId == profileId &&
        other.role == role &&
        other.status == status;
  }

  @override
  int get hashCode => profileId.hashCode ^ role.hashCode ^ status.hashCode;
}
