import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/models/task_status.dart';
import 'package:careshare/task_manager/presenter/task_widgets/task_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TasksOverview extends StatelessWidget {
  final List<CareTask> careTaskList;
  const TasksOverview({Key? key, required this.careTaskList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TaskSection(
            title: 'New Tasks',
            careTaskList: careTaskList.where((element) => element.taskStatus == TaskStatus.created),
          ),
          TaskSection(
            title: 'My Tasks',
            careTaskList: careTaskList.where((element) => element.taskStatus == TaskStatus.accepted && element.acceptedBy == BlocProvider.of<ProfileCubit>(context).fetchMyProfile().id)
    ),
          TaskSection(
            title: 'Completed Tasks',
            careTaskList: careTaskList.where((element) => element.taskStatus == TaskStatus.completed),
          ),
          TaskSection(
            title: 'Other People''s Tasks',
              careTaskList: careTaskList.where((element) => element.taskStatus == TaskStatus.accepted && element.acceptedBy != BlocProvider.of<ProfileCubit>(context).fetchMyProfile().id)
          ),
        ],
      ),
    );
  }
}
