import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/add_kudos_widget.dart';

import 'package:flutter/material.dart';


class TaskSummary extends StatelessWidget {
  final CareTask task;
  final bool isInListView;

  const TaskSummary({
    Key? key,
    required this.task,
    required this.isInListView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          TaskDetailedView.routeName,
          arguments: task,
        );
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                      height: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isInListView)
                            Container(
                              height: 10,
                              width: 10,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: task.taskPriority.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                task.title,
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ),
                        ],
                      ),


                ),
              ),
            ),
            if (task.taskStatus == TaskStatus.completed)
              Positioned(bottom: 0, right: -5, child: KudosWidget(task: task)),
          ],
        ),
      ),
    );
  }
}
