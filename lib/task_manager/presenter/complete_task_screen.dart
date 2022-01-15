import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:careshare/widgets/item_widget.dart';

import 'package:flutter/material.dart';
import '../../global.dart';
import '../domain/models/task.dart';
import 'complete_task_controller.dart';
import 'package:intl/intl.dart';
import '../../widgets/date_picker.dart';
import '../../widgets/custom_form_field.dart';



class CompleteTaskScreen extends StatefulWidget {
  final CareTask task;
  const CompleteTaskScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<CompleteTaskScreen> createState() =>
      _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  late CompleteTaskController controller = CompleteTaskController();
  bool showTaskTypeError = false;
  DateTime? completedDateTime;

  @override
  void initState() {
    controller.initialiseControllers(widget.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar('Complete a Task'),
      endDrawer: CustomDrawer(),
      body: SafeArea(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  itemWidget(
                    title: 'Caregroup',
                    content: (careeInCaregroups + carerInCaregroups).firstWhere((element) => element.id == widget.task.caregroupId).name!,
                  ),
                  itemWidget(
                    title: 'Title',
                    content: widget.task.title,
                  ),
                  itemWidget(
                    title: 'Details',
                    content: widget.task.details,
                  ),
                  itemWidget(
                    title: 'Size',
                    content: widget.task.taskSize.size,
                  ),
                  itemWidget(
                    title: 'Created',
                    content:
                    DateFormat('dd-MM-yyyy – kk:mm').format(widget.task.dateCreated!),
                  ),


                  DatePicker(onDateTimeChanged: (date){
                    controller.completedDateTime = date;
                    },

                  ),

                  CustomFormField(
                    controller: controller.commentController,
                    maxLines: 8,
                    label: 'Comments',
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tell us more about what you are going to do';
                      }
                      return null;
                    },
                  ),

                  TextButton(
                    onPressed: () {
                      controller.completeATask(
                        context: context,
                      );
                    },
                    child: Text('Complete Task',),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
