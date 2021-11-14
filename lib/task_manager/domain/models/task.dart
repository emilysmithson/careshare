import 'package:careshare/authentication/domain/models/user.dart';

enum Status {
  inProgress,
  complete,
}

class Task {
  final String title;
  final String? description;
  final List<String>? comments;
  final Status status;
  final bool assigned;
  final List<User> assignedTo;
  final User createdBy;
  final bool archive;

  Task({
    required this.title,
    this.description,
    this.comments,
    required this.status,
    required this.assigned,
    this.assignedTo = const [],
    required this.createdBy,
    this.archive = false,
  });
}
