import 'task_type.dart';

enum Status {
  inProgress,
  complete,
}

class CareTask {
  final String title;
  final String description;
  late String? id;

  // final bool assigned;

  late String? createdBy;

  final TaskType taskType;
  // final DateTime dueDate;

  CareTask({
    required this.title,
    required this.description,
    // this.comments,
    this.id,
    // required this.assigned,
    this.createdBy,
    required this.taskType,
    // required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      // 'assigned': assigned,
      'created_by': createdBy,
      'task_type': taskType.type,
      // 'task_type': taskType,
      // 'due_date': dueDate,
    };
  }

  CareTask.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        description = json['description'] as String,
        // assigned = json['assigned'],
        createdBy = json['created_by'] as String,
        taskType = TaskType.taskTypeList.firstWhere(
          (element) => element.type == json['task_type'],
        );
  // dueDate = json['due_date'];
}
