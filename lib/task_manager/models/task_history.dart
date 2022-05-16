import 'package:careshare/task_manager/models/task_status.dart';

class TaskHistory {
  final String id;
  final String profileId;
  final TaskStatus taskStatus;
  final DateTime dateTime;

  TaskHistory({
    required this.id,
    required this.profileId,
    required this.taskStatus,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'status': taskStatus.status,
      'date_time': dateTime.toString(),
    };
  }

  factory TaskHistory.fromJson(key, value) {
    TaskStatus taskStatus = TaskStatus.draft;
    if (TaskStatus.taskStatusList.indexWhere((element) => element.status == (value['status'])) != -1)
      {
        taskStatus = TaskStatus.taskStatusList.firstWhere((element) => element.status == value['status']);
      }
    String profileId = (value['profile_id'] != null && value['profile_id'] != "") ? value['profile_id'] : "RWfw1NO39sg8fyuMTuOXUUnTS6b2";
    TaskHistory newTaskHistory = TaskHistory(
      id: key,
      profileId: profileId,
      taskStatus: taskStatus,
      dateTime: DateTime.parse(value['date_time']),
    );

    return newTaskHistory;
  }
  @override
  String toString() {
    return '''id: $id
    profileId: $profileId
    taskStatus: $taskStatus
    dateTime: $dateTime''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskHistory
        && other.id == id
        && other.profileId == profileId
        && other.dateTime == dateTime
        && other.taskStatus == taskStatus;
  }

  @override
  int get hashCode =>
    id.hashCode ^
    profileId.hashCode ^
    dateTime.hashCode ^
    taskStatus.hashCode;
}
