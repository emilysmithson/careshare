import 'package:careshare/task_manager/models/task_status.dart';

class TaskHistory {
  final String id;
  final TaskStatus taskStatus;
  final DateTime dateTime;

  TaskHistory({
    required this.id,
    required this.taskStatus,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': taskStatus.status,
      'date_time': dateTime.toString(),
    };
  }

  factory TaskHistory.fromJson(value) {


    TaskHistory newTaskHistory = TaskHistory(
      // taskStatus: TaskStatus.taskStatusList
      //     .firstWhere((element) => element.status == (value['status'])),
        taskStatus: TaskStatus.created,
      // dateTime: DateTime.parse(value['date_time']),
      dateTime: DateTime.now(),
      // id: value['id'],
      id: 'xxx',
    );

    return newTaskHistory;
  }
  @override
  String toString() {
    return '''id: $id
              taskStatus: $taskStatus
              dateTime: $dateTime''';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskHistory && other.id == id
        && other.dateTime == dateTime
        && other.taskStatus == taskStatus;
  }

  @override
  int get hashCode => id.hashCode ^
    dateTime.hashCode ^
    taskStatus.hashCode;
}
