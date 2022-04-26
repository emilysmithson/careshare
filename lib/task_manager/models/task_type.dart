class TaskType {
  final String type;
  final String definition;
  final int value;
  final String icon;

  const TaskType(this.type, this.value, this.definition, this.icon);

  static const TaskType local = TaskType('Local', 1, 'has to be done locally', 'holiday_village_outlined ');
  static const TaskType remote = TaskType('Remote', 2, 'can be done remotely','settings_phone_sharp ');
  static const TaskType any = TaskType('Any', 3, 'can be done from anywhere','gps_fixed_sharp ');

  static List<TaskType> taskTypeList = [
    local,
    remote,
    any,

  ];
}
