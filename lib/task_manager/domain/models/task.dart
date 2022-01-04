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
  late String? createdByDisplayName;
  DateTime? dateCreated;

  TaskStatus taskStatus;
  late String? acceptedBy;
  late String? acceptedByDisplayName;
  DateTime? taskAcceptedForDate;
  List<Comment>? comments;

  CareTask({
    required this.title,
    required this.caregroupId,
    required this.details,
    this.id,
    this.createdBy,
    this.createdByDisplayName,
    required this.taskType,
    required this.taskStatus,
    this.dateCreated,
    required this.priority,
    this.acceptedBy,
    this.acceptedByDisplayName,
    this.taskAcceptedForDate,
    this.comments,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'caregroup_id': caregroupId,
      'details': details,
      'created_by': createdBy,
      'created_by_display_name': createdByDisplayName,
      'task_type': taskType.type,
      'status': taskStatus.status,
      'date_created': dateCreated.toString(),
      'priority': priority.value,
      'accepted_by': acceptedBy,
      'accepted_by_display_name': acceptedByDisplayName,
      'accepted_for_date': taskAcceptedForDate.toString(),
      'comments': comments?.map((comment) => comment.toJson()).toList(),
    };
  }
  
  
 factory CareTask.fromJson(dynamic key, dynamic value) {

   final title = value['title'] ?? '';
    final caregroupId = value['caregroup_id'] ?? '';
    final details = value['details'] ?? '';
    final taskType = TaskType.taskTypeList.firstWhere((element) => element.type == value['task_type']);
    final taskStatus = TaskStatus.taskStatusList. firstWhere((element) => element.status == value['status']);
    final priority = Priority.priorityList.firstWhere((element) => value['priority'] == element.value);
   final createdBy = value['created_by'] ?? '';
   final createdByDisplayName = value['created_by_display_name'] ?? '';
    final dateCreated = DateTime.parse(value['date_created']);
    final taskAcceptedForDate = DateTime.tryParse(value['accepted_for_date']);
    final acceptedBy = value['accepted_by'] ?? '';
    final acceptedByDisplayName = value['accepted_by_display_name'] ?? '';

    final List<Comment> comments = <Comment>[];
    if (value['comments'] != null) {
      value['comments'].forEach((comment) =>
      {
        if (comment!=null){
          comments.add(Comment.fromJson(comment))
        }
      });
    };

   return CareTask(
        id: key,
        title: title,
        caregroupId: caregroupId,
        details: details,
        taskType: taskType,
        taskStatus: taskStatus,
        priority: priority,
       createdBy: createdBy,
       createdByDisplayName: createdByDisplayName,

        dateCreated: dateCreated,
        taskAcceptedForDate: taskAcceptedForDate,
        acceptedBy: acceptedBy,
        acceptedByDisplayName: acceptedByDisplayName,
        comments: comments

    );


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

 factory Comment.fromJson(dynamic value){
    Comment newComment = Comment(
      commment: value['commment'] ?? '',
      createdBy: value['created_by'] ?? '',
      createdByDisplayName: value['created_by_name'] ?? '',
      dateCreated: DateTime.parse(value['date_created']),
    );

   return newComment;
 }}