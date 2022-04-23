import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class TaskPriority extends Equatable {
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
  static const TaskPriority medium =
      TaskPriority(level: 'Medium', value: 3, color: Colors.amber);
  static const TaskPriority low = TaskPriority(
    level: 'Low',
    value: 2,
    color: Colors.yellow,
  );
  static const TaskPriority lowest = TaskPriority(
    level: 'Lowest',
    value: 1,
    color: Colors.green,
  );
  static final List<TaskPriority> priorityList = [
    lowest,
    low,
    medium,
    high,
    highest,
  ];

  @override
  List<Object> get props => [level, value, color];
}
