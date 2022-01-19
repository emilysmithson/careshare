import 'task_priority.dart';
import 'task_size.dart';
import 'task_status.dart';

class CareTask {
  String title;
  String? description;
  TaskPriority taskPriority;
  TaskEffort taskEffort;
  String? details;
  String? category;
  final String id;

  final String createdBy;
  final DateTime dateCreated;

  TaskStatus taskStatus;
  String? acceptedBy;

  DateTime? taskAcceptedForDate;
  String? completedBy;

  DateTime? taskCompletedDate;
  List<Comment>? comments;

  CareTask({
    required this.title,
    this.description,
    this.details,
    this.category,
    required this.id,
    required this.createdBy,
    this.taskEffort = TaskEffort.medium,
    this.taskStatus = TaskStatus.created,
    required this.dateCreated,
    this.taskPriority = TaskPriority.medium,
    this.acceptedBy,
    this.taskAcceptedForDate,
    this.completedBy,
    this.taskCompletedDate,
    this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'details': details,
      'category': category,
      'created_by': createdBy,
      'task_effort': taskEffort.value,
      'status': taskStatus.status,
      'date_created': dateCreated.toString(),
      'priority': taskPriority.value,
      'accepted_by': acceptedBy,
      'accepted_for_date': taskAcceptedForDate.toString(),
      'completed_by': completedBy,
      'completed_date': taskCompletedDate.toString(),
      'comments': comments?.map((comment) => comment.toJson()),
    };
  }

  factory CareTask.fromJson(dynamic key, dynamic value) {
    final title = value['title'] ?? '';

    final details = value['details'] ?? '';
    final category = value['category'];

    final taskSize = TaskEffort.taskSizeList
        .firstWhere((element) => element.value == value['task_effort']);
    final taskStatus = TaskStatus.taskStatusList
        .firstWhere((element) => element.status == value['status']);
    final priority = TaskPriority.priorityList
        .firstWhere((element) => value['priority'] == element.value);
    final createdBy = value['created_by'] ?? '';

    final dateCreated = DateTime.parse(value['date_created']);
    final taskAcceptedForDate = DateTime.tryParse(value['accepted_for_date']);
    final acceptedBy = value['accepted_by'] ?? '';

    final taskCompletedDate = (value['completed_date'] != null)
        ? DateTime.tryParse(value['completed_date'])
        : null;
    final completedBy = value['completed_by'] ?? '';

    final List<Comment> comments = <Comment>[];
    if (value['comments'] != null) {
      value['comments'].forEach((k, v) {
        comments.add(Comment.fromJson(k, v));
      });
    }

    return CareTask(
        id: key,
        title: title,
        details: details,
        category: category,
        taskEffort: taskSize,
        taskStatus: taskStatus,
        taskPriority: priority,
        createdBy: createdBy,
        dateCreated: dateCreated,
        taskAcceptedForDate: taskAcceptedForDate,
        acceptedBy: acceptedBy,
        taskCompletedDate: taskCompletedDate,
        completedBy: completedBy,
        comments: comments);
  }
}

class Comment {
  final String commment;
  late String? createdBy;
  late String? createdByDisplayName;
  DateTime? dateCreated;
  late String? id;

  @override
  String toString() {
    return '''
      comment: $commment
      created by: $createdByDisplayName
      date created: $dateCreated
    ''';
  }

  Comment({
    required this.commment,
    this.id,
    this.createdBy,
    this.createdByDisplayName,
    this.dateCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      'commment': commment,
      'created_by': createdBy,
      'created_by_display_name': createdByDisplayName,
      'date_created': dateCreated.toString(),
    };
  }

  factory Comment.fromJson(String key, value) {
    Comment newComment = Comment(
      commment: value['commment'] ?? '',
      createdBy: value['created_by'] ?? '',
      createdByDisplayName: value['created_by_name'] ?? '',
      dateCreated: DateTime.parse(value['date_created']),
      id: key,
    );

    return newComment;
  }
}

enum TaskField {
  title,
  taskPriority,
  taskEffort,
  details,
  category,
  taskStatus,
  acceptedBy,
  completedBy,
  taskCompleteDate,
}
