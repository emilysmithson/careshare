import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/kudos/kudos_board.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_search/task_search.dart';
import 'package:careshare/task_manager/presenter/widgets/task_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ViewCaregroupTasks extends StatelessWidget {
  static const routeName = '/view-caregroup-tasks';
  final Caregroup caregroup;
  final List<CareTask> careTaskList;

  const ViewCaregroupTasks({
    Key? key,
    required this.caregroup,
    required this.careTaskList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;
    List<Profile> allProfiles = BlocProvider.of<AllProfilesCubit>(context).profileList;

    return SingleChildScrollView(
      child: Column(
        children: [

          KudosBoard(
            profileList: BlocProvider.of<AllProfilesCubit>(context)
                .profileList
                .where((profile) => profile.carerInCaregroups
                .where((element) => element.caregroupId == caregroup.id)
                .isNotEmpty)
                .toList(),
            caregroup: caregroup,
          ),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                TaskSearch.routeName,
                arguments: {
                  'selectedStatuses': [TaskStatus.created],
                },
              );
            },
            child: Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                children: [
                  Text(
                    'New Tasks',
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
          TaskSection(
            title: 'New Tasks',
            caregroup: caregroup,
            careTaskList: careTaskList
                .where(
                  (element) => element.taskStatus == TaskStatus.created,
            )
                .toList(),
          ),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                TaskSearch.routeName,
                arguments: {
                  'selectedStatuses': [TaskStatus.assigned, TaskStatus.accepted],
                  'selectedProfiles': [myProfile],
                },
              );
            },
            child: Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                children: [
                  Text(
                    'My Tasks',
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
          TaskSection(
            title: 'My Tasks',
            caregroup: caregroup,
            careTaskList: careTaskList
                .where((element) =>
            (element.taskStatus == TaskStatus.assigned ||
                element.taskStatus == TaskStatus.accepted) &&
                element.assignedTo ==
                    BlocProvider.of<MyProfileCubit>(context).myProfile.id)
                .toList(),
          ),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                TaskSearch.routeName,
                arguments: {
                  'selectedStatuses': [TaskStatus.completed],
                },
              );
            },
            child: Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                children: [
                  Text(
                    'Completed Tasks',
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
          TaskSection(
            title: 'Completed Tasks',
            caregroup: caregroup,
            isCompletedTasks: true,
            careTaskList: careTaskList
                .where((element) => element.taskStatus == TaskStatus.completed)
                .toList(),
          ),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                TaskSearch.routeName,
                arguments: {
                  'selectedStatuses': [TaskStatus.assigned, TaskStatus.accepted],
                  'selectedProfiles': allProfiles,

                },
              );
            },
            child: Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                children: [
                  Text(
                    "Other People's Tasks",
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
          TaskSection(
            title: "Other People's Tasks",
            caregroup: caregroup,
            careTaskList: careTaskList
                .where(
                  (element) =>
              (element.taskStatus == TaskStatus.assigned ||
                  element.taskStatus == TaskStatus.accepted) &&
                  element.assignedTo !=
                      BlocProvider.of<MyProfileCubit>(context).myProfile.id,
            )
                .toList(),
          ),
        ],
      ),
    );



  }
}
