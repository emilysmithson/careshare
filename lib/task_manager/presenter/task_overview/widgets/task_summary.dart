import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/task_status.dart';
import '../../task_detailed_view/widgets/add_kudos_widget.dart';

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
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                String photoId = task.acceptedBy ?? task.createdBy;
                if (photoId == '') {
                  photoId = task.createdBy;
                }

                return Row(
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
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  task.title,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ),
                          ),
                          if (task.taskStatus == TaskStatus.completed &&
                              !isInListView)
                            const Spacer(),
                          if (task.taskStatus == TaskStatus.completed)
                            KudosWidget(task: task),
                        ],
                      ),
                    ),
                    // if (task.taskStatus == TaskStatus.created)
                    //   Positioned(
                    //     right: 0,
                    //     bottom: 0,
                    //     child: ProfilePhotoWidget(
                    //       id: task.createdBy,
                    //       size: 30,
                    //     ),
                    //   ),

                    // if (task.acceptedBy != null && task.acceptedBy!.isNotEmpty)
                    //   Positioned(
                    //     right: 4,
                    //     bottom: 4,
                    //     child:
                    //         ProfilePhotoWidget(id: task.acceptedBy!, size: 30),
                    //   ),

                    // // const SizedBox(height: 4),
                    // // Text.rich(
                    // //   TextSpan(
                    // //     children: [
                    // //       TextSpan(
                    // //         text: 'Priority: ',
                    // //         style: Theme.of(context).textTheme.bodySmall,
                    // //       ),
                    // //       TextSpan(
                    // //         text: task.taskPriority.level,
                    // //         style: Theme.of(context)
                    //             .textTheme
                    //             .bodySmall
                    //             ?.copyWith(color: task.taskPriority.color),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // const SizedBox(height: 4),
                    // Text(
                    //   'Difficulty: ${task.taskEffort.size}',
                    //   style: Theme.of(context).textTheme.bodySmall,
                    // ),
                    // const SizedBox(height: 4),
                    // if (task.category != null)
                    //   Text(
                    //     'Type: ${task.category!.name}',
                    //     style: Theme.of(context).textTheme.bodySmall,
                    //   ),
                    // const SizedBox(height: 4),
                    // if (task.taskStatus == TaskStatus.created)
                    //   SizedBox(
                    //     width: double.infinity,
                    //     child: Text(
                    //       'Created by: ${BlocProvider.of<ProfileCubit>(context).getName(task.createdBy)}',
                    //       style: Theme.of(context).textTheme.bodySmall,
                    //     ),
                    //   ),
                    // const SizedBox(height: 4),
                    // if (task.acceptedBy != null && task.acceptedBy!.isNotEmpty)
                    //   Text(
                    //     'Assigned to: ${BlocProvider.of<ProfileCubit>(context).getName(task.acceptedBy!)}',
                    //     style: Theme.of(context).textTheme.bodySmall,
                    //   ),
                    // const SizedBox(height: 4),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
