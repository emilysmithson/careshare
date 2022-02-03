
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_summary.dart';
import 'package:flutter/material.dart';

class TaskSection extends StatelessWidget {
  final String title;
  final Iterable<CareTask> careTaskList;
  const TaskSection(
      {Key? key,
      required this.title,
      required this.careTaskList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.blue[100],
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(
          height: 200,

          child: Container(
            color: Colors.blue[50],

            child: ListView(
              scrollDirection: Axis.horizontal,
              children: careTaskList
                  .map(
                    (task) => TaskSummary(
                  task: task,
                ),
              ).toList()
              ,
            ),
          ),
        ),
      ],
    );
  }
}
