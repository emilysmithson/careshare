import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/task_detailed_view.dart';

import 'package:careshare/task_manager/presenter/task_overview/tasks_overview.dart';
import 'package:careshare/templates/page_scaffold.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../category_manager/cubit/category_cubit.dart';
import '../../profile_manager/cubit/profile_cubit.dart';
import '../models/task.dart';

class TaskManagerView extends StatefulWidget {
  static const String routeName = "/task-manager";
  final Caregroup caregroup;
  const TaskManagerView({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  _TaskManagerViewState createState() => _TaskManagerViewState();
}

class _TaskManagerViewState extends State<TaskManagerView> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // AddTaskBottomSheet().call(context);

            // Create a draft task and pass it to the edit screen
            final taskCubit = BlocProvider.of<TaskCubit>(context);
            final CareTask? task =
                await taskCubit.draftTask('', widget.caregroup.id);
            if (task != null) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<TaskCubit>(context),
                      child: BlocProvider.value(
                        value: BlocProvider.of<ProfileCubit>(context),
                        child: BlocProvider.value(
                          value: BlocProvider.of<CategoriesCubit>(context),
                          child: TaskDetailedView(
                            task: task,
                          ),
                        ),
                      )),
                ),
              );
            }
          },
          child: const Icon(Icons.add)),
      body: BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is TaskLoaded) {
          // if (state.careTaskList.isEmpty) {
          //   return const Center(
          //     child: Text('no tasks'),
          //   );
          // }

          Iterable<CareTask> filteredTaskList = state.careTaskList
              .where((element) => element.caregroup == widget.caregroup.id);

          return TasksOverview(
              careTaskList: filteredTaskList.toList(),
              caregroup: widget.caregroup);
        }

        return const Center(
          child: Text('Oops something went wrong'),
        );
      }),
    );
  }
}
