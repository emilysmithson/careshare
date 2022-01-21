class TaskEffort {
  final String size;
  final String definition;
  final int value;

  const TaskEffort(this.size, this.value, this.definition);

  static const TaskEffort tiny = TaskEffort('Tiny', 1, 'less than 10 minutes');
  static const TaskEffort small = TaskEffort('Small', 2, 'less than an hour');
  static const TaskEffort medium =
      TaskEffort('Medium', 4, 'less than half a day');
  static const TaskEffort large = TaskEffort('Large', 6, 'less than a day');
  static const TaskEffort huge = TaskEffort('Huge', 10, 'more than a day');
  static const TaskEffort gargantuan =
      TaskEffort('Gargantuan', 20, 'more than a week');

  static List<TaskEffort> taskSizeList = [
    tiny,
    small,
    medium,
    large,
    huge,
    gargantuan,
  ];
}
