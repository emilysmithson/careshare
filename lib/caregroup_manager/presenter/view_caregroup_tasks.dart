import 'dart:io';

import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/models/caregroup_status.dart';

import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_input_field_widget.dart';
import 'package:careshare/caregroup_manager/presenter/edit_caregroup.dart';
import 'package:careshare/kudos/kudos_board.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/widgets/task_section.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'caregroup_widgets/upload_caregroup_photo.dart';
import 'package:intl/intl.dart';
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


    return Column(
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
              .where((element) =>
          (element.taskStatus == TaskStatus.assigned ||
              element.taskStatus == TaskStatus.accepted) &&
              element.assignedTo ==
                  BlocProvider.of<MyProfileCubit>(context).myProfile.id)
              .toList(),
        ),
        TaskSection(
          title: 'Completed Tasks',
          caregroup: caregroup,
          isCompletedTasks: true,
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
            (element.taskStatus == TaskStatus.assigned ||
                element.taskStatus == TaskStatus.accepted) &&
                element.assignedTo !=
                    BlocProvider.of<MyProfileCubit>(context).myProfile.id,
          )
              .toList(),
        ),
      ],
    );



  }
}
