import 'package:careshare/task_manager/domain/models/task_size.dart';
import 'package:flutter/material.dart';

class SelectTaskSize extends StatefulWidget {
  final TaskSize? currentSize;
  final Function onSelect;

  const SelectTaskSize({Key? key, this.currentSize, required this.onSelect})
      : super(key: key);

  @override
  _SelectTaskSizeState createState() => _SelectTaskSizeState();
}

class _SelectTaskSizeState extends State<SelectTaskSize> {
  final List<String> options = [];
  TaskSize? selectedTaskSize;
  String? currentTaskSize;
  @override
  void initState() {
    currentTaskSize = widget.currentSize?.size;
    for (var element in TaskSize.taskSizeList) {
      options.add(element.size);
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
      hint: const Text('Select a task size'),
      value: currentTaskSize,
      underline: Container(),
      icon: const RotatedBox(
        quarterTurns: 3,
        child: Icon(Icons.chevron_left),
      ),
      onChanged: (String? newValue) {
        setState(() {
          currentTaskSize = newValue;
          widget.onSelect(TaskSize.taskSizeList
              .firstWhere((element) => element.size == newValue));
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
