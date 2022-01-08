import 'package:careshare/task_manager/domain/models/task_size.dart';
import 'package:careshare/task_manager/presenter/task_widgets/select_caregroup.dart';
import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';

import '../domain/models/task_priority.dart';
import 'package:flutter/material.dart';

import '../../style/style.dart';
import '../../widgets/custom_form_field.dart';
import '../domain/models/task_type.dart';
import 'task_widgets/select_priority.dart';
import 'task_widgets/select_task_size.dart';
import 'task_widgets/select_task_type.dart';
import 'create_task_controller.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  State<CreateTaskScreen> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  late CreateTaskController controller = CreateTaskController();
  bool showTaskTypeError = false;
  bool showTaskSizeError = false;

  initialise() async {
    await controller.initialiseControllers();
    setState(() {

    });
  }

  @override
  void initState() {
    initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('controller.caregroup?.name: ');
    // print(controller.caregroup);
    // print(controller.caregroup?.name);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar('Create a New Task'),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(6),
                  decoration: Style.boxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectCaregroup(

                        onSelect: (String caregroup) {
                          controller.caregroup = controller.caregroupList.firstWhere((element) => element.name == caregroup);
                          setState(() {

                          });
                        },
                        caregroupOptions: controller.caregroupOptions,
                        currentCaregroup: controller.caregroup?.name,

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
                  controller: controller.detailsController,
                  maxLines: 8,
                  label: 'Details',
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the task details';
                    }
                    return null;
                  },
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(6),
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
                  onSelect: (TaskPriority priority) {
                    controller.priority = priority;
                  },
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(6),
                  decoration: Style.boxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectTaskSize(
                        onSelect: (TaskSize newTaskSize) {
                          controller.taskSize = newTaskSize;
                        },
                        currentSize: controller.taskSize,
                      ),
                      Text(
                        showTaskSizeError ? 'Please select a task size' : '',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
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
                    controller.createTask(
                      context: context,
                    );
                  },
                  child: Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
