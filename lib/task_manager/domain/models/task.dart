import 'package:careshare/profile_manager/domain/usecases/create_a_profile.dart';

import 'priority.dart';
import 'task_type.dart';
import 'task_status.dart';

class CareTask {
  final String title;
  final String caregroupId;
  final Priority priority;
  final TaskType taskType;
  final String details;
  late String? id;

  late String? createdBy;
  DateTime? dateCreated;

  TaskStatus taskStatus;
  late String? acceptedBy;
  DateTime? taskAcceptedForDate;
  List<Comment>? comments;

  CareTask({
    required this.title,
    required this.caregroupId,
    required this.details,
    this.id,
    this.createdBy,
    required this.taskType,
    required this.taskStatus,
    this.dateCreated,
    required this.priority,
    this.acceptedBy,
    this.taskAcceptedForDate,
    this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'caregroup_id': caregroupId,
      'details': details,
      'created_by': createdBy,
      'task_type': taskType.type,
      'status': taskStatus.status,
      'date_created': dateCreated.toString(),
      'priority': priority.value,
      'accepted_by': acceptedBy,
      'accepted_for_date': taskAcceptedForDate.toString(),
      'comments': comments!.map((review) => review.toJson()).toList(),
    };
  }
  
  
  CareTask.fromJson(dynamic key, dynamic value)
      : title = value['title'] ?? '',
        caregroupId = value['caregroup_id'] ?? '',
        createdBy = value['created_by'] ?? '',
        id = key,
        priority = Priority.priorityList.firstWhere((element) => value['priority'] == element.value),
        dateCreated = DateTime.parse(value['date_created']),

        details = value['details'] ?? '',
        taskType = TaskType.taskTypeList.firstWhere((element) => element.type == value['task_type']),
        taskStatus = TaskStatus.taskStatusList. firstWhere((element) => element.status == value['status']),
        taskAcceptedForDate = DateTime.tryParse(value['accepted_for_date']),
        acceptedBy = value['accepted_by'] ?? '',
        comments = value['comments']  ?? []
  ;
}

class Comment {
  final String commment;
  late String? createdBy;
  DateTime? dateCreated;
  late String? id;

  Comment({
    required this.commment,
    this.id,
    this.createdBy,
    this.dateCreated,
  });

  Map<String, dynamic> toJson() {
    return {
      'commment': commment,
      'created_by': createdBy,
      'date_created': dateCreated.toString(),
    };
  }

  Comment.fromJson(dynamic key, dynamic value)
      : commment = value['commment'] ?? '',
        createdBy = value['created_by'] ?? '',
        id = key,
        dateCreated = DateTime.parse(value['date_created'])
  ;
}