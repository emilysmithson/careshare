class TaskType {
  final String type;

  TaskType(this.type);

  static TaskType shopping = TaskType('Shopping');
  static TaskType cleaning = TaskType('Cleaning');
  static TaskType gardening = TaskType('Gardening');
  static TaskType technicalSupport = TaskType('Technical Support');
  static TaskType cooking = TaskType('Cooking');
  static TaskType other = TaskType('Other');

  static List<TaskType> taskTypeList = [
    shopping,
    cleaning,
    gardening,
    technicalSupport,
    cooking,
    other,
  ];
}
