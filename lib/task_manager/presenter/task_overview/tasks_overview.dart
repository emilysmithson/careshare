import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup.dart';
import 'package:careshare/kudos/kudos_board.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/task_section.dart';




class TasksOverview extends StatelessWidget {
  final List<CareTask> careTaskList;
  final Caregroup caregroup;

  const TasksOverview({
    Key? key,
    required this.caregroup,
    required this.careTaskList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              ViewCaregroup.routeName,
              arguments: caregroup,
            );
          },
          child: Hero(
          tag: 'Caregroup',
          child: Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Caregroup: ${caregroup.name}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.white),
                ),
                const SizedBox(width: 10),
                const Icon(
                    Icons.play_circle_fill_outlined, size: 25, color: Colors.white
                ),
              ],
            ),
          ),
      ),
        ),

          KudosBoard(
            profileList: BlocProvider.of<ProfileCubit>(context).profileList
                .where((profile) => profile.carerInCaregroups!
                .where((element) => element.caregroupId==caregroup.id).isNotEmpty).toList(),
            caregroup: caregroup,
          ),
          TaskSection(
            title: 'New Tasks',
            caregroup: caregroup,
            careTaskList: careTaskList
                .where(
                  (element) => element.taskStatus == TaskStatus.created,
                )
                .toList(),
          ),
          TaskSection(
            title: 'My Tasks',
            caregroup: caregroup,
            careTaskList: careTaskList
                .where(
                  (element) =>
                      (element.taskStatus == TaskStatus.assigned || element.taskStatus == TaskStatus.accepted ) &&
                      element.assignedTo == BlocProvider.of<ProfileCubit>(context).myProfile.id
                )
                .toList(),
          ),
          TaskSection(
            title: 'Completed Tasks',
            caregroup: caregroup,
            careTaskList: careTaskList
                .where((element) => element.taskStatus == TaskStatus.completed)
                .toList(),
          ),
          TaskSection(
            title: "Other People's Tasks",
            caregroup: caregroup,
            careTaskList: careTaskList
                .where(
                  (element) =>
                      (element.taskStatus == TaskStatus.assigned || element.taskStatus == TaskStatus.accepted ) &&
                      element.assignedTo !=
                          BlocProvider.of<ProfileCubit>(context).myProfile.id,
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
