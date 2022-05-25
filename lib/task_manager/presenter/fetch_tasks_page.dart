import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/view_caregroup.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FetchTasksPage extends StatelessWidget {
  final Caregroup caregroup;
  static const routeName = '/fetch-tasks-page';
  const FetchTasksPage({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('fetching tasks');

    BlocProvider.of<TaskCubit>(context)
        .fetchTasksForCaregroup(caregroupId: caregroup.id);

    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const LoadingPageTemplate(
              loadingMessage: 'Loading tasks...');
        }
        if (state is TaskError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is TaskLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              Navigator.pushReplacementNamed(context, ViewCaregroup.routeName,
                arguments: {
                  'careTaskList': state.careTaskList,
                  'caregroup': caregroup,
                },));
          return Container();
        }
        return Container();
      },
    );
  }
}
