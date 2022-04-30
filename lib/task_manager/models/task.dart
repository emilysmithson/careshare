import 'package:flutter/foundation.dart';

import 'package:careshare/task_manager/models/comment.dart';

import '../../category_manager/domain/models/category.dart';
import 'kudos.dart';
import 'task_effort.dart';
import 'task_type.dart';
import 'task_priority.dart';
import 'task_status.dart';

class CareTask {

  final String id;
  String caregroup;
  TaskStatus taskStatus;

  String title;
  String? details;

  CareCategory? category;
  TaskEffort taskEffort;
  TaskPriority taskPriority;
  TaskType taskType;

  String? createdBy;
  DateTime? taskCreatedDate;

  String? assignedTo;
  String? assignedBy;
  DateTime? assignedByDate;

  String? acceptedBy;
  DateTime? acceptedOnDate;
  DateTime? taskAcceptedForDate;

  String? completedBy;
  DateTime? taskCompletedDate;


  List<Comment>? comments = [];
  List<Kudos>? kudos = [];


  CareTask({
    required this.id,
    required this.caregroup,
    this.taskStatus = TaskStatus.draft,

    required this.title,
    this.details,

    this.category,
    this.taskEffort = TaskEffort.medium,
    this.taskPriority = TaskPriority.medium,
    this.taskType = TaskType.any,

    required this.createdBy,
    required this.taskCreatedDate,

    this.assignedTo,
    this.assignedBy,
    this.assignedByDate,

    this.acceptedBy,
    this.acceptedOnDate,
    this.taskAcceptedForDate,

    this.completedBy,
    this.taskCompletedDate,

    this.comments,
    this.kudos,
  });

  Map<String, dynamic> toJson() {
    return {
      'caregroup': '-Ms4vguCCloDVf3mhEhN',
      'task_status': taskStatus.status,

      'title': title,
      'details': details,

      'category': category?.toJson(),
      'task_effort': taskEffort.value,
      'priority': taskPriority.value,
      'task_type': taskType.value,

      'created_by': createdBy,
      'created_date': taskCreatedDate.toString(),

      'assigned_to': assignedTo,
      'assigned_by': assignedBy,
      'assigned_by_date': assignedByDate.toString(),

      'accepted_by': acceptedBy,
      'accepted_on_date': acceptedOnDate.toString(),
      'accepted_for_date': taskAcceptedForDate.toString(),

      'completed_by': completedBy,
      'completed_date': taskCompletedDate.toString(),

      'comments': comments?.map((comment) => comment.toJson()).toList(),
      'kudos': kudos?.map((kudos) => kudos.toJson()).toList(),
    };
  }

  factory CareTask.fromJson(dynamic key, dynamic value) {

    final caregroup = value['caregroup'] ?? '';
    final taskStatus = TaskStatus.taskStatusList
        .firstWhere((element) => element.status == value['task_status']);

    final title = value['title'] ?? '';
    final details = value['details'] ?? '';

    CareCategory? category;
    if (value['category'] != null) {
      category = CareCategory.fromJson(value['category']);
    }
    final taskSize = TaskEffort.taskSizeList
        .firstWhere((element) => element.value == value['task_effort']);

    final taskType = TaskType.taskTypeList
        .firstWhere((element) => element.value == value['task_type']);


    final priority = TaskPriority.priorityList
        .firstWhere((element) => value['priority'] == element.value);

    final createdBy = value['created_by'] ?? '';
    final taskCreatedDate = DateTime.parse(value['created_date']);

    final assignedTo = value['assigned_to'] ?? '';
    final assignedBy = value['assigned_By'] ?? '';
    final DateTime? assignedByDate = (value['assigned_by_date'] != null)
    ? DateTime.tryParse(value['assigned_by_date'])
        : null;


    final DateTime? acceptedOnDate = (value['accepted_on_date'] != null)
        ? DateTime.tryParse(value['accepted_on_date'])
        : null;
    final taskAcceptedForDate = DateTime.tryParse(value['accepted_for_date']);
    final acceptedBy = value['accepted_by'] ?? '';

    final taskCompletedDate = (value['completed_date'] != null)
        ? DateTime.tryParse(value['completed_date'])
        : null;
    final completedBy = value['completed_by'] ?? '';
    final List<Comment> comments = [];

    if (value['comments'] != null) {
      value['comments'].forEach((k, v) {
        comments.add(Comment.fromJson(v));
      });
    }
    final List<Kudos> kudos = [];

    if (value['kudos'] != null) {
      value['kudos'].forEach((k, v) {
        kudos.add(Kudos.fromJson(v));
      });
    }

    return CareTask(
        id: key,
        title: title,
        caregroup: caregroup,
        details: details,
        category: category,
        taskEffort: taskSize,
        taskType: taskType,
        taskStatus: taskStatus,
        taskPriority: priority,
        createdBy: createdBy,
        taskCreatedDate: taskCreatedDate,

        assignedTo: assignedTo,
        assignedBy: assignedBy,
        assignedByDate: assignedByDate,

        taskAcceptedForDate: taskAcceptedForDate,
        acceptedBy: acceptedBy,
        acceptedOnDate: acceptedOnDate,
        taskCompletedDate: taskCompletedDate,
        completedBy: completedBy,
        comments: comments,
        kudos: kudos);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CareTask &&
        other.title == title &&
        other.caregroup == caregroup &&
        other.taskPriority == taskPriority &&
        other.taskEffort == taskEffort &&
        other.taskType == taskType &&
        other.details == details &&
        other.category == category &&
        other.id == id &&
        other.createdBy == createdBy &&
        other.taskCreatedDate == taskCreatedDate &&

        other.assignedTo == assignedTo &&
        other.assignedBy == assignedBy &&
        other.assignedByDate == assignedByDate &&

        other.taskStatus == taskStatus &&
        other.acceptedBy == acceptedBy &&
        other.acceptedOnDate == acceptedOnDate &&
        other.taskAcceptedForDate == taskAcceptedForDate &&
        other.completedBy == completedBy &&
        other.taskCompletedDate == taskCompletedDate &&
        listEquals(other.comments, comments) &&
        listEquals(other.kudos, kudos);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        caregroup.hashCode ^
        taskPriority.hashCode ^
        taskEffort.hashCode ^
        taskType.hashCode ^
        details.hashCode ^
        category.hashCode ^
        id.hashCode ^
        createdBy.hashCode ^
        taskCreatedDate.hashCode ^
        assignedTo.hashCode ^
        assignedBy.hashCode ^
        assignedByDate.hashCode ^

        taskStatus.hashCode ^
        acceptedBy.hashCode ^
        acceptedOnDate.hashCode ^
        taskAcceptedForDate.hashCode ^
        completedBy.hashCode ^
        taskCompletedDate.hashCode ^
        comments.hashCode ^
        kudos.hashCode;
  }
}

enum TaskField {
  caregroup,
  taskStatus,

  title,
  details,

  category,
  taskEffort,
  taskPriority,
  taskType,

  createdBy,
  taskCreatedDate,

  assignedTo,
  assignedBy,
  assignedByDate,

  acceptedBy,

  acceptedOnDate,
  taskAcceptedForDate,

  completedBy,
  taskCompleteDate,

  comment,
  kudos,
}
