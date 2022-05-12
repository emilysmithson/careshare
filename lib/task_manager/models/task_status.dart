class TaskStatus {
  final String status;
  final bool locked;

  const TaskStatus(this.status, this.locked);

  static const TaskStatus draft = TaskStatus('Draft', false);
  static const TaskStatus created = TaskStatus('Created', false);
  static const TaskStatus assigned = TaskStatus('Assigned', false);
  static const TaskStatus accepted = TaskStatus('Accepted', false);
  static const TaskStatus completed = TaskStatus('Completed', true);
  static const TaskStatus archived = TaskStatus('Archived', true);

  static List<TaskStatus> taskStatusList = [
    draft,
    created,
    assigned,
    accepted,
    completed,
    archived,
  ];
}
