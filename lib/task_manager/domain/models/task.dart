import 'priority.dart';
import 'task_type.dart';

enum Status {
  inProgress,
  complete,
}

class CareTask {
  final String title;
  final String description;
  late String? id;
  DateTime? dateCreated;
  DateTime? dueDate;
  final Priority priority;

  // final bool assigned;

  late String? createdBy;

  final TaskType taskType;

  CareTask({
    required this.title,
    required this.description,
    this.id,
    this.createdBy,
    required this.taskType,
    this.dateCreated,
    this.dueDate,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'created_by': createdBy,
      'task_type': taskType.type,
      'date_created': dateCreated.toString(),
      'due_date': dueDate.toString(),
      'priority': priority.value,
    };
  }

  CareTask.fromJson(dynamic key, dynamic value)
      : title = value['title'] ?? '',
        createdBy = value['created_by'] ?? '',
        id = key,
        priority = Priority.priorityList
            .firstWhere((element) => value['priority'] == element.value),
        dateCreated = DateTime.parse(value['date_created']),
        description = value['description'] as String,
        taskType = TaskType.taskTypeList.firstWhere(
          (element) => element.type == value['task_type'],
        );
}
