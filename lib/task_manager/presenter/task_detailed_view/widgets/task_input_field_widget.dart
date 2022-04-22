import 'dart:async';

import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter/material.dart';

class TaskInputFieldWidget extends StatefulWidget {
  final CareTask task;
  final String? currentValue;
  final Function onChanged;
  final int maxLines;
  final String label;
  final TextStyle? textStyle;
  const TaskInputFieldWidget({
    Key? key,
    required this.task,
    required this.label,
    this.currentValue,
    required this.onChanged,
    this.textStyle,
    this.maxLines = 1,
  }) : super(
          key: key,
        );

  @override
  State<TaskInputFieldWidget> createState() => _TaskInputFieldWidgetState();
}

class _TaskInputFieldWidgetState extends State<TaskInputFieldWidget> {
  TextEditingController controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    if (widget.currentValue != null) {
      controller.text = widget.currentValue!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: widget.textStyle,
      maxLines: widget.maxLines,
      controller: controller,
      onChanged: (value) async {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          widget.onChanged(value);
        });
      },
      decoration: InputDecoration(
        label: Text(widget.label),
      ),
    );
  }
}
