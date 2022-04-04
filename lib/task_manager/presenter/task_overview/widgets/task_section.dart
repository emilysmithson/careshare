import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_category_view/task_category_view.dart';
import 'package:careshare/task_manager/presenter/task_overview/widgets/task_summary.dart';

import 'package:flutter/material.dart';

import 'add_task_bottom_sheet.dart';

class TaskSection extends StatelessWidget {
  final String title;
  final List<CareTask> careTaskList;
  const TaskSection({Key? key, required this.title, required this.careTaskList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              TaskCategoryView.routeName,
              arguments: {
                'careTaskList': careTaskList,
                'title': title,
              },
            );
          },
          child: Hero(
            tag: title,
            child: Container(
              width: double.infinity,
              color: Colors.blue[100],
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title + ' >',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 220,
          child: Container(
            color: Colors.blue[50],
            child: careTaskList.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(2),
                    color: Colors.blue[50],
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 160,
                        height: 190,
                        child: Card(
                            child: Center(
                                child: IconButton(
                                    onPressed: () {
                                      AddTaskBottomSheet().call(context);
                                    },
                                    icon: const Icon(Icons.add)))),
                      ),
                    ),
                  )
                : ListView(
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
        ),
      ],
    );
  }
}
