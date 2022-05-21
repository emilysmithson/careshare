class TaskStatus {
  final String status;
  final bool complete;
  final bool locked;

  const TaskStatus(this.status, this.complete, this.locked);

  static const TaskStatus draft = TaskStatus('Draft', false, false);
  static const TaskStatus created = TaskStatus('Created', false, false);
  static const TaskStatus assigned = TaskStatus('Assigned', false, true);
  static const TaskStatus accepted = TaskStatus('Accepted', false, true);
  static const TaskStatus completed = TaskStatus('Completed', true, true);
  static const TaskStatus archived = TaskStatus('Archived', true, true);

  static List<TaskStatus> taskStatusList = [
    draft,
    created,
    assigned,
    accepted,
    completed,
    archived,
  ];
}
