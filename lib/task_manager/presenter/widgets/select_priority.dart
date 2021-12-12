import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../../domain/models/priority.dart';

class SelectPriority extends StatefulWidget {
  final Priority? currentPriority;
  final Function onSelect;

  const SelectPriority({Key? key, this.currentPriority, required this.onSelect})
      : super(key: key);

  @override
  _SelectPriorityState createState() => _SelectPriorityState();
}

class _SelectPriorityState extends State<SelectPriority> {
  final List<Priority> options = [];
  Priority currentPriority = Priority.medium;

  @override
  void initState() {
    if (widget.currentPriority != null) {
      currentPriority = widget.currentPriority!;
    }
    options.addAll(Priority.priorityList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Style.boxDecoration,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text('Priority:  '),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
              isExpanded: true,
              value: currentPriority.level,
              underline: Container(),
              icon: const RotatedBox(
                quarterTurns: 3,
                child: Icon(Icons.chevron_left),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  final Priority newPriority = Priority.priorityList.firstWhere(
                    (element) => newValue == element.level,
                  );
                  currentPriority = newPriority;
                  widget.onSelect(newPriority);
                });
              },
              items: options.map<DropdownMenuItem<String>>((Priority value) {
                return DropdownMenuItem<String>(
                  value: value.level,
                  child: Row(
                    children: [
                      Icon(Icons.circle, color: value.color),
                      const SizedBox(width: 16),
                      Text(value.level),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
