import 'priority.dart';
import 'task_type.dart';
import 'task_status.dart';

class CareTask {
  final String title;
  final String description;
  late String? id;
  DateTime? dateCreated;
  final Priority priority;

  // final bool assigned;

  late String? createdBy;
  late String? acceptedBy;

  final TaskType taskType;
  final TaskStatus taskStatus;

  CareTask({
    required this.title,
    required this.description,
    this.id,
    this.createdBy,
    this.acceptedBy,
    required this.taskType,
    required this.taskStatus,
    this.dateCreated,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'created_by': createdBy,
      'accepted_by': acceptedBy,
      'task_type': taskType.type,
      'status': taskStatus.status,
      'date_created': dateCreated.toString(),
      'priority': priority.value,
    };
  }

  CareTask.fromJson(dynamic key, dynamic value)
      : title = value['title'] ?? '',
        createdBy = value['created_by'] ?? '',
        acceptedBy = value['accepted_by'] ?? '',
        id = key,
        priority = Priority.priorityList.firstWhere((element) => value['priority'] == element.value),
        dateCreated = DateTime.parse(value['date_created']),
        description = value['description'] as String,
        taskType = TaskType.taskTypeList.firstWhere((element) => element.type == value['task_type']),
        taskStatus = TaskStatus.taskStatusList. firstWhere((element) => element.status == value['status']);
}
