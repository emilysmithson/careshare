import '../../domain/models/priority.dart';
import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../../../widgets/custom_form_field.dart';
import '../../domain/models/task.dart';
import '../../domain/models/task_type.dart';
import '../widgets/select_priority.dart';
import '../widgets/select_task_type.dart';
import 'accept_a_task_controller.dart';

class AcceptATaskScreen extends StatefulWidget {
  final CareTask? task;
  const AcceptATaskScreen({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  State<AcceptATaskScreen> createState() =>
      _AcceptATaskScreenState();
}

class _AcceptATaskScreenState extends State<AcceptATaskScreen> {
  late AcceptATaskController controller = AcceptATaskController();
  bool showTaskTypeError = false;

  @override
  void initState() {
    controller.initialiseControllers(widget.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title:
        Text('Accept a Task'),
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomFormField(
                    controller: controller.titleController,
                    label: 'Title',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Title';
                      }
                      return null;
                    },
                  ),
                  CustomFormField(
                    controller: controller.descriptionController,
                    maxLines: 8,
                    label: 'Description',
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Title';
                      }
                      return null;
                    },
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
                    padding:
                    const EdgeInsets.only(top: 16, left: 16, right: 16),
                    decoration: Style.boxDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectTaskType(
                          onSelect: (TaskType newTaskType) {
                            controller.taskType = newTaskType;
                          },
                          currentType: controller.taskType,
                        ),
                        Text(
                          showTaskTypeError ? 'Please select a task type' : '',
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                  SelectPriority(
                    onSelect: (Priority priority) {
                      controller.priority = priority;
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      controller.formKey.currentState?.validate();
                      if (controller.taskType == null) {
                        setState(() {
                          showTaskTypeError = true;
                        });
                        return;
                      }
                      controller.acceptATask(
                        context: context,
                      );
                    },
                    child: Text(
                      controller.isCreateTask ? 'Create' : 'Save changes',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
