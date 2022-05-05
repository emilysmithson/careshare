import 'profile_role.dart';

class RoleInCaregroup {
  final String? id;
  final String caregroupId;
  ProfileRole role;
  int completedCount;
  int completedValue;
  int kudosCount;
  int kudosValue;

  RoleInCaregroup({
    required this.id,
    required this.caregroupId,
    required this.role,
    required this.completedCount,
    required this.completedValue,
    required this.kudosCount,
    required this.kudosValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caregroup_id': caregroupId,
      'role': role.role,
      'completed_count': completedCount,
      'completed_value': completedValue,
      'kudos_count': kudosCount,
      'kudos_value': kudosValue,
   };
  }

  factory RoleInCaregroup.fromJson(dynamic json) {

    RoleInCaregroup newRoleInCaregroup = RoleInCaregroup(
      id: json['id'],
      caregroupId: json['caregroup_id'],
      role:  ProfileRole.profileRoleList
          .firstWhere((element) => element.role == json['role']),
      completedCount: json['completed_count'] ?? 0,
      completedValue: json['completed_value'] ?? 0,
      kudosCount: json['kudos_count'] ?? 0,
      kudosValue: json['kudos_value'] ?? 0,
    );

    return newRoleInCaregroup;
  }

  @override
  String toString() {
    return '''
      id: $id,
      caregroupId: $caregroupId
      role: $role
      completedCount: $completedCount
      completedValue: $completedValue
      kudosCount: $kudosCount
      kudosValue: $kudosValue
      '''
    ;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RoleInCaregroup
        && other.caregroupId == caregroupId
        && other.role == role
        && other.completedCount == completedCount
        && other.completedValue == completedValue
        && other.kudosCount == kudosCount
        && other.kudosValue == kudosValue
    ;

  }

  @override
  int get hashCode =>
      caregroupId.hashCode ^
      role.hashCode ^
      completedCount.hashCode ^
      completedValue.hashCode ^
      kudosCount.hashCode ^
      kudosValue.hashCode
  ;
}
