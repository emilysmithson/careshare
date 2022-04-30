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
  const TaskManagerView({
    Key? key,
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

            final taskCubit = BlocProvider.of<TaskCubit>(context);
            final CareTask? task = await taskCubit.draftTask('New Task');
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
          if (state.careTaskList.isEmpty) {
            return const Center(
              child: Text('no tasks'),
            );
          }

          return TasksOverview(careTaskList: state.careTaskList);
        }

        return const Center(
          child: Text('Oops something went wrong'),
        );
      }),
    );
  }
}
