enum Status {
  inProgress,
  complete,
}
enum TaskType {
  shopping,
  cleaning,
  gardening,
  technicalSupport,
  cooking,
  other,
}

class CareTask {
  final String title;
  final String description;

  // final bool assigned;

  final String createdBy;

  // final TaskType taskType;
  // final DateTime dueDate;

  CareTask({
    required this.title,
    required this.description,
    // this.comments,

    // required this.assigned,
    required this.createdBy,
    // required this.taskType,
    // required this.dueDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      // 'assigned': assigned,
      'created_by': createdBy,
      // 'task_type': taskType,
      // 'due_date': dueDate,
    };
  }

  CareTask.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        description = json['description'] as String,
        // assigned = json['assigned'],
        createdBy = json['created_by'] as String;
  // taskType = json['task_type'],
  // dueDate = json['due_date'];
}
