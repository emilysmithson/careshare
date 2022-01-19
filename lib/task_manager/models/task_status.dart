class TaskStatus {
  final String status;

  const TaskStatus(this.status);

  static const TaskStatus created = TaskStatus('Created');
  static const TaskStatus accepted = TaskStatus('Accepted');
  static const TaskStatus completed = TaskStatus('Completed');
  static const TaskStatus archived = TaskStatus('Archived');

  static List<TaskStatus> taskStatusList = [
    created,
    accepted,
    completed,
    archived,
  ];
}