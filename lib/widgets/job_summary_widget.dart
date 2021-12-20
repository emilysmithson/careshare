import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../style/style.dart';
import '../task_manager/domain/models/task.dart';
import '../task_manager/domain/usecases/all_usecases.dart';
import '../task_manager/presenter/create_or_edit_task/create_or_edit_task_screen.dart';
import '../task_manager/presenter/accept_a_task/accept_a_task_screen.dart';
import 'item_widget.dart';

class JobSummaryWidget extends StatelessWidget {
  final CareTask task;
  const JobSummaryWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: Style.boxDecoration,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              itemWidget(
                title: 'Title',
                content: task.title,
              ),
              itemWidget(
                title: 'Description',
                content: task.description,
              ),
              itemWidget(
                title: 'Type',
                content: task.taskType.type,
              ),
              itemWidget(
                title: 'Created',
                content:
                DateFormat('dd-MM-yyyy – kk:mm').format(task.dateCreated!),
              ),
              itemWidget(
                title: 'Created By',
                content: task.createdBy.toString(),
              ),
              itemWidget(
                title: 'Status',
                content: task.taskStatus.status
              ),

              if(task.taskAcceptedForDate != null) itemWidget(
                title: 'Accepted For Date',
                content:
                DateFormat('dd-MM-yyyy – kk:mm').format(task.taskAcceptedForDate!),
              ) ,

              if(task.acceptedBy != "")  itemWidget(
                title: 'Accepted By',
                content: task.acceptedBy.toString(),
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
                              task: task,
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
                        TasksUseCases.removeTask(task.id!);
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
                              task: task,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.breakfast_dining_outlined,
                        color: Colors.grey,
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.circle,
                        color: task.priority.color,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),



        ],
      ),
    );
  }
}
