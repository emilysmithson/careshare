import 'package:careshare/task_manager/presenter/task_category_view/cubit/task_category_view_cubit.dart';
import 'package:careshare/task_manager/presenter/task_overview/widgets/task_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/task.dart';

class TaskCategoryView extends StatelessWidget {
  final String title;
  final List<CareTask> careTaskList;
  static const String routeName = "/task-category_view";
  const TaskCategoryView({
    Key? key,
    required this.careTaskList,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sortByValue = '';
    return BlocProvider(
      create: (context) => TaskCategoryViewCubit(careTaskList: careTaskList),
      child: BlocBuilder<TaskCategoryViewCubit, TaskCategoryViewState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Hero(
                tag: title,
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.white),
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                    icon: const Icon(Icons.sort_by_alpha_outlined),
                    onSelected: (String result) {
                      sortByValue = result;
                      BlocProvider.of<TaskCategoryViewCubit>(context)
                          .sortBy(result);
                    },
                    itemBuilder: (BuildContext context) => state.sortCategories
                        .map(
                          (String text) => PopupMenuItem<String>(
                            value: text,
                            child: Text(text),
                          ),
                        )
                        .toList()),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: state.careTaskList
                        .map(
                          (task) => SizedBox(
                            child: TaskSummary(task: task),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
