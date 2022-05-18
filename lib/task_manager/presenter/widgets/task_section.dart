import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_category_view/task_category_view.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';
import 'package:careshare/task_manager/presenter/widgets/task_summary.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class TaskSection extends StatelessWidget {
  final String title;
  final Caregroup caregroup;
  final List<CareTask> careTaskList;
  final bool isCompletedTasks;
  const TaskSection({
    Key? key,
    required this.title,
    required this.caregroup,
    required this.careTaskList,
    this.isCompletedTasks = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // if task are complete, place tasks I completed at the end of the list
    // if (isCompletedTasks) {
    //   Profile profile = BlocProvider.of<MyProfileCubit>(context).myProfile;
    //   careTaskList.sort(
    //     ((a, b) {
    //       if (a.kudos
    //               ?.firstWhereOrNull((element) => element.id == profile.id) ==
    //           null) {
    //         return -1;
    //       } else {
    //         return 1;
    //       }
    //     }),
    //   );
    // }

    // if tasks are complete sort by completed date, otherwise sort them by due date
    if (isCompletedTasks) {
      careTaskList.sort((a,b) => b.taskCompletedDate!.compareTo(a.taskCompletedDate!));
      }
    else
      {
        careTaskList.sort((a,b) => b.dueDate.compareTo(a.dueDate));
      }


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
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  const Icon(Icons.play_circle_fill_outlined,
                      size: 25, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 160,
          child: Container(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            child: careTaskList.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(2),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: 140,
                        child: Card(
                          child: Center(
                            child: IconButton(
                              onPressed: () async {
                                // AddTaskBottomSheet().call(context);
                                final taskCubit =
                                    BlocProvider.of<TaskCubit>(context);
                                final CareTask? task =
                                    await taskCubit.draftTask('', caregroup.id);
                                if (task != null) {
                                  Navigator.of(context).pushNamed(
                                    TaskDetailedView.routeName,
                                    arguments: task,

                                  );
                                }
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
                    children: careTaskList.map((task) {
                      return TaskSummary(
                        task: task,
                        isInListView: false,
                      );
                    }).toList(),
                  ),
          ),
        ),
        // const SizedBox(height: 4),
      ],
    );
  }
}
