import 'package:careshare/style/style.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:careshare/widgets/item_widget.dart';

import 'package:flutter/material.dart';
import '../domain/models/task.dart';
import 'view_task_controller.dart';
import 'package:intl/intl.dart';
import 'edit_task_screen.dart';
import 'accept_task_screen.dart';
import '../domain/usecases/all_task_usecases.dart';
import 'package:careshare/global.dart';
import '../../widgets/custom_app_bar.dart';

class ViewTaskScreen extends StatefulWidget {
  final CareTask task;
  const ViewTaskScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<ViewTaskScreen> createState() =>
      _ViewTaskScreenState();
}

class _ViewTaskScreenState extends State<ViewTaskScreen> {
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
      endDrawer: CustomDrawer(),
      body: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(6),
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
                  title: 'Size',
                  content: widget.task.taskSize.size,
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

                if (widget.task.comments != null) Text("Comments"),
                if (widget.task.comments != null) Column(
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
                              builder: (context) => EditTaskScreen(
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
                              builder: (context) => AcceptTaskScreen(
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
                          color: widget.task.taskPriority.color,
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
