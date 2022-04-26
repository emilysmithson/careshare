import 'package:flutter/foundation.dart';

import 'package:careshare/task_manager/models/comment.dart';

import '../../category_manager/domain/models/category.dart';
import 'kudos.dart';
import 'task_effort.dart';
import 'task_type.dart';
import 'task_priority.dart';
import 'task_status.dart';

class CareTask {
  String title;

  TaskPriority taskPriority;
  TaskEffort taskEffort;
  TaskType taskType;
  String? details;
  CareCategory? category;
  final String id;

  final String createdBy;
  final DateTime dateCreated;

  TaskStatus taskStatus;
  String? acceptedBy;
  DateTime? acceptedOnDate;

  DateTime? taskAcceptedForDate;
  String? completedBy;

  DateTime? taskCompletedDate;
  List<Comment>? comments = [];
  List<Kudos>? kudos = [];

  CareTask({
    required this.title,
    this.details,
    this.category,
    required this.id,
    this.acceptedOnDate,
    required this.createdBy,
    this.taskEffort = TaskEffort.medium,
    this.taskType = TaskType.any,
    this.taskStatus = TaskStatus.created,
    required this.dateCreated,
    this.taskPriority = TaskPriority.medium,
    this.acceptedBy,
    this.taskAcceptedForDate,
    this.completedBy,
    this.taskCompletedDate,
    this.comments,
    this.kudos,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'details': details,
      'category': category?.toJson(),
      'created_by': createdBy,
      'task_effort': taskEffort.value,
      'task_type': taskType.value,
      'task_status': taskStatus.status,
      'date_created': dateCreated.toString(),
      'priority': taskPriority.value,
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

    final taskStatus = TaskStatus.taskStatusList
        .firstWhere((element) => element.status == value['task_status']);

    final priority = TaskPriority.priorityList
        .firstWhere((element) => value['priority'] == element.value);

    final createdBy = value['created_by'] ?? '';

    final dateCreated = DateTime.parse(value['date_created']);
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
        details: details,
        category: category,
        taskEffort: taskSize,
        taskType: taskType,
        taskStatus: taskStatus,
        taskPriority: priority,
        createdBy: createdBy,
        dateCreated: dateCreated,
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
        other.taskPriority == taskPriority &&
        other.taskEffort == taskEffort &&
        other.taskType == taskType &&
        other.details == details &&
        other.category == category &&
        other.id == id &&
        other.createdBy == createdBy &&
        other.dateCreated == dateCreated &&
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
        taskPriority.hashCode ^
        taskEffort.hashCode ^
        taskType.hashCode ^
        details.hashCode ^
        category.hashCode ^
        id.hashCode ^
        createdBy.hashCode ^
        dateCreated.hashCode ^
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
  title,
  taskPriority,
  taskEffort,
  taskType,
  details,
  category,
  taskStatus,
  acceptedBy,
  completedBy,
  taskCompleteDate,
  acceptedOnDate,
  comment,
  kudos,
}
