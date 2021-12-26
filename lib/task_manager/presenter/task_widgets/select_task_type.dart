import 'package:flutter/material.dart';

import '../../domain/models/task_type.dart';

class SelectTaskType extends StatefulWidget {
  final TaskType? currentType;
  final Function onSelect;

  const SelectTaskType({Key? key, this.currentType, required this.onSelect})
      : super(key: key);

  @override
  _SelectTaskTypeState createState() => _SelectTaskTypeState();
}

class _SelectTaskTypeState extends State<SelectTaskType> {
  final List<String> options = [];
  TaskType? selectedTaskType;
  String? currentTaskType;
  @override
  void initState() {
    currentTaskType = widget.currentType?.type;

    for (var element in TaskType.taskTypeList) {
      options.add(element.type);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      isExpanded: true,
      hint: const Text('Select a task type'),
      value: currentTaskType,
      underline: Container(),
      icon: const RotatedBox(
        quarterTurns: 3,
        child: Icon(Icons.chevron_left),
      ),
      onChanged: (String? newValue) {
        setState(() {
          currentTaskType = newValue;
          widget.onSelect(TaskType.taskTypeList
              .firstWhere((element) => element.type == newValue));
        });
      },
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
