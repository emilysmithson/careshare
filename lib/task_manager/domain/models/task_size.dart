class TaskSize {
  final String size;
  final String definition;
  final int value;

  TaskSize(this.size, this.value, this.definition);

  static TaskSize tiny = TaskSize('Tiny',1,'less than 10 minutes');
  static TaskSize small = TaskSize('Small',2,'less than an hour');
  static TaskSize medium = TaskSize('Medium',4,'less than half a day');
  static TaskSize large = TaskSize('Large',6,'less than a day');
  static TaskSize huge = TaskSize('Huge',10,'more than a day');
  static TaskSize gargantuan = TaskSize('Gargantuan',20,'more than a week');

  static List<TaskSize> taskSizeList = [
    tiny,
    small,
    medium,
    large,
    huge,
    gargantuan,
  ];
}
