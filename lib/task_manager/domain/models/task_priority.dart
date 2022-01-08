import 'package:flutter/material.dart';

class TaskPriority {
  final String level;
  final int value;
  final Color color;

  TaskPriority({
    required this.level,
    required this.value,
    required this.color,
  });
  static final TaskPriority highest = TaskPriority(
    level: 'Highest',
    value: 1,
    color: Colors.red,
  );
  static final TaskPriority high = TaskPriority(
    level: 'High',
    value: 2,
    color: Colors.orange,
  );
  static final TaskPriority medium = TaskPriority(
    level: 'Medium',
    value: 3,
    color: Colors.yellow,
  );
  static final TaskPriority low = TaskPriority(
    level: 'Low',
    value: 4,
    color: Colors.blueGrey,
  );
  static final TaskPriority lowest = TaskPriority(
    level: 'Lowest',
    value: 5,
    color: Colors.grey,
  );
  static final List<TaskPriority> priorityList = [
    highest,
    high,
    medium,
    low,
    lowest,
  ];
}
