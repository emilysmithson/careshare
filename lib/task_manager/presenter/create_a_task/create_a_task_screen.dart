import 'package:careshare/task_manager/domain/models/task.dart';
import 'package:flutter/material.dart';

import '../../../widgets/custom_form_field.dart';
import 'create_a_task_controller.dart';

class CreateATaskScreen extends StatefulWidget {
  final CareTask? task;

  const CreateATaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<CreateATaskScreen> createState() => _CreateATaskScreenState();
}

class _CreateATaskScreenState extends State<CreateATaskScreen> {
  final controller = CreateATaskController();
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
        title: const Text('Create a New Task'),
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: controller.formKey,
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
                TextButton(
                  onPressed: () {
                    controller.createATask(context, widget.task);
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
