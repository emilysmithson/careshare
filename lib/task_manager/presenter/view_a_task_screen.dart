import 'package:careshare/style/style.dart';
import 'package:careshare/widgets/item_widget.dart';

import 'package:flutter/material.dart';
import '../domain/models/task.dart';
import 'view_a_task_controller.dart';
import 'package:intl/intl.dart';
import 'create_or_edit_task_screen.dart';
import 'accept_a_task_screen.dart';
import '../domain/usecases/all_task_usecases.dart';
import 'package:careshare/global.dart';
import '../../widgets/custom_app_bar.dart';

class ViewATaskScreen extends StatefulWidget {
  final CareTask task;
  const ViewATaskScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<ViewATaskScreen> createState() =>
      _ViewATaskScreenState();
}

class _ViewATaskScreenState extends State<ViewATaskScreen> {
  late ViewATaskController controller = ViewATaskController();
  bool showTaskTypeError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar('Task Details'),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: Style.boxDecoration,
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  title: 'Type',
                  content: widget.task.taskType.type,
                ),
                itemWidget(
                  title: 'Created',
                  content:
                  DateFormat('dd-MM-yyyy – kk:mm').format(widget.task.dateCreated!),
                ),

                if(widget.task.taskAcceptedForDate != null) itemWidget(
                  title: 'Accepted For Date',
                  content:
                  DateFormat('dd-MM-yyyy – kk:mm').format(widget.task.taskAcceptedForDate!),
                ) ,

                if(widget.task.acceptedBy != "")  itemWidget(
                  title: 'Accepted By',
                  content: widget.task.acceptedByDisplayName ?? 'Anonymous',
                ),
                itemWidget(
                  title: 'Created By',
                  content: widget.task.createdByDisplayName ?? 'Anonymous',
                ),
                itemWidget(
                    title: 'Status',
                    content: widget.task.taskStatus.status
                ),

                Text("Comments"),

                Column(
                  children: widget.task.comments!.map((e) => Text(e.toString())).toList(),
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateOrEditATaskScreen(
                                task: widget.task,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          AllTaskUseCases.removeTask(widget.task.id!);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                      ),


                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AcceptATaskScreen(
                                task: widget.task,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.adjust,
                          color: Colors.grey,
                        ),
                      ),


                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.circle,
                          color: widget.task.priority.color,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),

        ),
      ),
    );
  }
}
