import 'package:careshare/widgets/item_widget.dart';

import 'package:flutter/material.dart';
import '../domain/models/task.dart';
import 'accept_a_task_controller.dart';
import 'package:intl/intl.dart';
import '../../widgets/date_picker.dart';
import '../../widgets/custom_form_field.dart';


class AcceptATaskScreen extends StatefulWidget {
  final CareTask task;
  const AcceptATaskScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<AcceptATaskScreen> createState() =>
      _AcceptATaskScreenState();
}

class _AcceptATaskScreenState extends State<AcceptATaskScreen> {
  late AcceptATaskController controller = AcceptATaskController();
  bool showTaskTypeError = false;
  DateTime? acceptedDateTime;

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
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  itemWidget(
                    title: 'Title',
                    content: widget.task.title,
                  ),
                  itemWidget(
                    title: 'Details',
                    content: widget.task.details,
                  ),
                  itemWidget(
                    title: 'Type',
                    content: widget.task.taskType.type,
                  ),
                  itemWidget(
                    title: 'Created',
                    content:
                    DateFormat('dd-MM-yyyy – kk:mm').format(widget.task.dateCreated!),
                  ),


                  DatePicker(onDateTimeChanged: (date){
                    controller.acceptedDateTime = date;
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
                      controller.acceptATask(
                        context: context,
                      );
                    },
                    child: Text('Accept Task',),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
