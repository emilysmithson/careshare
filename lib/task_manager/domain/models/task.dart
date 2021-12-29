import 'priority.dart';
import 'task_type.dart';
import 'task_status.dart';

class CareTask {
  final String title;
  final String careFor;
  final Priority priority;
  final TaskType taskType;
  final String details;
  late String? id;

  late String? createdBy;
  DateTime? dateCreated;

  TaskStatus taskStatus;
  late String? acceptedBy;
  DateTime? taskAcceptedForDate;

  CareTask({
    required this.title,
    required this.careFor,
    required this.details,
    this.id,
    this.createdBy,
    required this.taskType,
    required this.taskStatus,
    this.dateCreated,
    required this.priority,
    this.acceptedBy,
    this.taskAcceptedForDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'for': careFor,
      'details': details,
      'created_by': createdBy,
      'task_type': taskType.type,
      'status': taskStatus.status,
      'date_created': dateCreated.toString(),
      'priority': priority.value,
      'accepted_by': acceptedBy,
      'accepted_for_date': taskAcceptedForDate.toString(),
    };
  }

  CareTask.fromJson(dynamic key, dynamic value)
      : title = value['title'] ?? '',
        careFor = value['care_for'] ?? '',
        createdBy = value['created_by'] ?? '',
        id = key,
        priority = Priority.priorityList.firstWhere((element) => value['priority'] == element.value),
        dateCreated = DateTime.parse(value['date_created']),

        details = value['details'] ?? '',
        taskType = TaskType.taskTypeList.firstWhere((element) => element.type == value['task_type']),
        taskStatus = TaskStatus.taskStatusList. firstWhere((element) => element.status == value['status']),
        taskAcceptedForDate = DateTime.tryParse(value['accepted_for_date']),
        acceptedBy = value['accepted_by'] ?? ''
  ;
}
