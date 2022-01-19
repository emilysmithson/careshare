import 'package:careshare/profile/usecases/fetch_profiles.dart';
import 'package:careshare/task_manager/models/task.dart';

import 'package:careshare/task_manager/presenter/task_widgets/task_input_field_widget.dart';
import 'package:careshare/task_manager/usecases/edit_task_field.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TaskView extends StatefulWidget {
  final CareTask task;
  final FetchProfiles profileModule;
  const TaskView({
    Key? key,
    required this.task,
    required this.profileModule,
  }) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  late CareTask task;
  final double spacing = 16;
  @override
  void initState() {
    task = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final EditTaskField editTaskField = EditTaskField();
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacing),
              TaskInputFieldWidget(
                label: 'Title',
                maxLines: 1,
                currentValue: task.title,
                task: task,
                onChanged: (value) {
                  editTaskField(
                    taskField: TaskField.title,
                    task: widget.task,
                    newValue: value,
                  );
                },
              ),
              SizedBox(height: spacing),
              Text(
                'Created by: ${widget.profileModule.getNickName(task.createdBy)} on ${DateFormat('E').add_jm().format(task.dateCreated)}',
              ),
              SizedBox(height: spacing),
              TaskInputFieldWidget(
                label: 'Description',
                maxLines: 5,
                currentValue: task.details,
                task: task,
                onChanged: (value) {
                  editTaskField(
                    task: widget.task,
                    newValue: value,
                    taskField: TaskField.details,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
