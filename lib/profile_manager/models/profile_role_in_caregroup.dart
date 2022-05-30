import 'package:careshare/profile_manager/models/profile_role_in_caregroup_status.dart';

import 'profile_role.dart';

class RoleInCaregroup {
  final String caregroupId;
  ProfileRole role;
  ProfileRoleInCaregroupStatus status;
  int completedCount;
  int completedValue;
  int kudosCount;
  int kudosValue;
  DateTime? lastLogin;

  RoleInCaregroup({
    required this.caregroupId,
    required this.role,
    required this.status,
    required this.completedCount,
    required this.completedValue,
    required this.kudosCount,
    required this.kudosValue,
    required this.lastLogin,
  });

  Map<String, dynamic> toJson() {
    return {
      'caregroup_id': caregroupId,
      'role': role.role,
      'status': status.status,
      'completed_count': completedCount,
      'completed_value': completedValue,
      'kudos_count': kudosCount,
      'kudos_value': kudosValue,
      'last_login': lastLogin.toString(),
    };
  }

  factory RoleInCaregroup.fromJson(dynamic key, dynamic json) {
    RoleInCaregroup newRoleInCaregroup = RoleInCaregroup(
      caregroupId: key,
      role: ProfileRole.profileRoleList.firstWhere((element) => element.role == json['role']),
      status: ProfileRoleInCaregroupStatus.profileRoleInCaregroupStatusList
          .firstWhere((element) => element.status == json['status']),
      completedCount: json['completed_count'] ?? 0,
      completedValue: json['completed_value'] ?? 0,
      kudosCount: json['kudos_count'] ?? 0,
      kudosValue: json['kudos_value'] ?? 0,
      lastLogin: (json['last_login']!=null) ? DateTime.parse(json['last_login']) : null,
    );

    return newRoleInCaregroup;
  }

  @override
  String toString() {
    return '''
      caregroupId: $caregroupId
      role: $role
      status: $status
      completedCount: $completedCount
      completedValue: $completedValue
      kudosCount: $kudosCount
      kudosValue: $kudosValue
      lastLogin: $lastLogin
      ''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoleInCaregroup &&
        other.caregroupId == caregroupId &&
        other.role == role &&
        other.status == status &&
        other.completedCount == completedCount &&
        other.completedValue == completedValue &&
        other.kudosCount == kudosCount &&
        other.kudosValue == kudosValue &&
        other.lastLogin == lastLogin;
  }

  @override
  int get hashCode =>
      caregroupId.hashCode ^
      role.hashCode ^
      status.hashCode ^
      completedCount.hashCode ^
      completedValue.hashCode ^
      kudosCount.hashCode ^
      kudosValue.hashCode ^
      lastLogin.hashCode;
}
