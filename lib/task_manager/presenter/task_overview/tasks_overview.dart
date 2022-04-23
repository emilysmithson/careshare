import 'package:careshare/kudos/kudos_board.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/task_section.dart';

class TasksOverview extends StatelessWidget {
  final List<CareTask> careTaskList;
  const TasksOverview({Key? key, required this.careTaskList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KudosBoard(
            profileList: BlocProvider.of<ProfileCubit>(context).profileList,
          ),
          TaskSection(
            title: 'New Tasks',
            careTaskList: careTaskList
                .where(
                  (element) => element.taskStatus == TaskStatus.created,
                )
                .toList(),
          ),
          TaskSection(
            title: 'My Tasks',
            careTaskList: careTaskList
                .where(
                  (element) =>
                      element.taskStatus == TaskStatus.accepted &&
                      element.acceptedBy ==
                          BlocProvider.of<ProfileCubit>(context).myProfile.id,
                )
                .toList(),
          ),
          TaskSection(
            title: 'Completed Tasks',
            careTaskList: careTaskList
                .where((element) => element.taskStatus == TaskStatus.completed)
                .toList(),
          ),
          TaskSection(
            title: "Other People's Tasks",
            careTaskList: careTaskList
                .where(
                  (element) =>
                      element.taskStatus == TaskStatus.accepted &&
                      element.acceptedBy !=
                          BlocProvider.of<ProfileCubit>(context).myProfile.id,
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
