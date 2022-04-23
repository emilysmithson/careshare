import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_category_view/task_category_view.dart';
import 'package:careshare/task_manager/presenter/task_overview/widgets/task_summary.dart';

import 'package:flutter/material.dart';

import 'add_task_bottom_sheet.dart';

class TaskSection extends StatelessWidget {
  final String title;
  final List<CareTask> careTaskList;
  const TaskSection({
    Key? key,
    required this.title,
    required this.careTaskList,
  }) : super(key: key);

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
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title + ' >',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 130,
          child: Container(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            child: careTaskList.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(2),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 160,
                        child: Card(
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                AddTaskBottomSheet().call(context);
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: careTaskList
                        .map(
                          (task) => TaskSummary(
                            task: task,
                            isInListView: false,
                          ),
                        )
                        .toList(),
                  ),
          ),
        ),
        // const SizedBox(height: 4),
      ],
    );
  }
}
