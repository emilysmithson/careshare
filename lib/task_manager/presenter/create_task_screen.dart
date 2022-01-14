import 'package:careshare/style/style.dart';
import 'package:careshare/task_manager/domain/models/task_priority.dart';
import 'package:careshare/task_manager/domain/models/task_size.dart';
import 'package:careshare/task_manager/presenter/task_widgets/select_caregroup.dart';
import 'package:careshare/task_manager/presenter/task_widgets/select_category.dart';
import 'package:careshare/task_manager/presenter/task_widgets/select_priority.dart';
import 'package:careshare/task_manager/presenter/task_widgets/select_task_size.dart';
import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:careshare/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'create_task_controller.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({Key? key}) : super(key: key);

  @override
  State<CreateTaskScreen> createState() =>
      _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  late CreateTaskController controller = CreateTaskController();
  bool showTaskCaregroupError = false;
  bool showTaskCategoryError = false;
  bool showTaskPriorityError = false;
  bool showTaskSizeError = false;
  bool showTaskError = false;

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

                //Caregroup
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
                            showTaskCaregroupError = false;
                          });
                        },
                        caregroupOptions: controller.caregroupOptions,
                        currentCaregroup: controller.caregroup?.name,
                      ),
                      Text(
                        showTaskCaregroupError ? 'Please select a caregroup' : '',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),

                //Category
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(6),
                  padding: const EdgeInsets.all(6),
                  decoration: Style.boxDecoration,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectCategory(
                        onSelect: (String category) {
                          controller.category = controller.categoryList.firstWhere((element) => element.name == category);
                          setState(() {
                            showTaskCategoryError = false;
                          });
                        },
                        categoryOptions: controller.categoryOptions,
                        currentCategory: controller.category?.name,

                      ),
                      Text(
                        showTaskCategoryError ? 'Please select a task category' : '',
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),

                // Title
                CustomFormField(
                  controller: controller.titleController,
                  label: 'Title',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),


                // Details
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

                // Priority
                SelectPriority(
                  onSelect: (TaskPriority priority) {
                    controller.priority = priority;
                  },
                ),

                //Size
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

                // Create
                TextButton(
                  onPressed: () {

                    controller.formKey.currentState?.validate();
                    if (controller.caregroup == null) {
                      showTaskCaregroupError = true;
                      showTaskError = true;
                    }
                    if (controller.category == null) {
                      showTaskCategoryError = true;
                      showTaskError = true;
                    }
                    if (controller.taskSize == null) {
                      showTaskSizeError = true;
                      showTaskError = true;
                    }

                    if (showTaskError) {
                      setState(() {
                        showTaskError = true;
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
