import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_summary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TasksOverview extends StatelessWidget {
  final List<CareTask> careTaskList;
  const TasksOverview({Key? key, required this.careTaskList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

// NEW TASKS
        Expanded(
            flex: 1,
            child: AppBar(title: Text('New Tasks')),
        ),
        Expanded(
          flex: 7,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: careTaskList.where((element) => element.taskStatus==TaskStatus.created)
                .map(
                  (task) => TaskSummary(
                task: task,
              ),
            )
                .toList(),
          ),
        ),

// MY TASKS
        Expanded(
            flex: 1,
            child: AppBar(title: Text('My Tasks')),
        ),
        Expanded(
          flex: 7,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: careTaskList
                .map(
                  (task) => TaskSummary(
                task: task,
              ),
            )
                .toList(),
          ),
        ),

// COMPLETED TASKS
        Expanded(
            flex: 1,
            child: Container(
                width: double.infinity,
                color: Colors.blueAccent,
                child: Text('Completed Tasks')
              ),
            ),


        Expanded(
          flex: 7,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: careTaskList.where((element) => element.taskStatus==TaskStatus.completed)
                .map(
                  (task) => TaskSummary(
                task: task,
              ),
            )
                .toList(),
          ),
        ),



      ],
    );
  }
}
