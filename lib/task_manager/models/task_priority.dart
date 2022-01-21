import 'package:flutter/material.dart';

class TaskPriority {
  final String level;
  final int value;
  final Color color;

  const TaskPriority({
    required this.level,
    required this.value,
    required this.color,
  });
  static const TaskPriority highest = TaskPriority(
    level: 'Highest',
    value: 5,
    color: Colors.red,
  );
  static const TaskPriority high = TaskPriority(
    level: 'High',
    value: 4,
    color: Colors.orange,
  );
  static const TaskPriority medium = TaskPriority(
    level: 'Medium',
    value: 3,
    color: Colors.yellow,
  );
  static const TaskPriority low = TaskPriority(
    level: 'Low',
    value: 2,
    color: Colors.blueGrey,
  );
  static const TaskPriority lowest = TaskPriority(
    level: 'Lowest',
    value: 1,
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
