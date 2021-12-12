import 'package:flutter/material.dart';

class Priority {
  final String level;
  final int value;
  final Color color;

  Priority({
    required this.level,
    required this.value,
    required this.color,
  });
  static final Priority highest = Priority(
    level: 'Highest',
    value: 1,
    color: Colors.red,
  );
  static final Priority high = Priority(
    level: 'High',
    value: 2,
    color: Colors.orange,
  );
  static final Priority medium = Priority(
    level: 'Medium',
    value: 3,
    color: Colors.yellow,
  );
  static final Priority low = Priority(
    level: 'Low',
    value: 4,
    color: Colors.blueGrey,
  );
  static final Priority lowest = Priority(
    level: 'Lowest',
    value: 5,
    color: Colors.grey,
  );
  static final List<Priority> priorityList = [
    highest,
    high,
    medium,
    low,
    lowest,
  ];
}
