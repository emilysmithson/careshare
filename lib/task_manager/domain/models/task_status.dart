class TaskStatus {
  final String status;

  TaskStatus(this.status);

  static TaskStatus created = TaskStatus('Created');
  static TaskStatus accepted = TaskStatus('Accepted');
  static TaskStatus completed = TaskStatus('Completed');
  static TaskStatus archived = TaskStatus('Archived');

  static List<TaskStatus> taskStatusList = [
    created,
    accepted,
    completed,
    archived,
  ];
}
