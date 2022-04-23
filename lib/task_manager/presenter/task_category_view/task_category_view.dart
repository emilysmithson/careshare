import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/task_manager/presenter/task_category_view/cubit/task_category_view_cubit.dart';
import 'package:careshare/task_manager/presenter/task_detailed_view/widgets/effort_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../category_manager/cubit/category_cubit.dart';
import '../../models/task.dart';
import '../task_detailed_view/task_detailed_view.dart';

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
                    tooltip: 'Filter',
                    icon: const Icon(Icons.filter_alt_outlined),
                    onSelected: (String id) {
                      BlocProvider.of<TaskCategoryViewCubit>(context)
                          .filterBy(id);
                    },
                    itemBuilder: (BuildContext context) {
                      List<PopupMenuItem<String>> widgetList =
                          BlocProvider.of<CategoriesCubit>(context)
                              .categoryList
                              .map(
                                (CareCategory category) =>
                                    PopupMenuItem<String>(
                                  value: category.id,
                                  child: Text(category.name),
                                ),
                              )
                              .toList();
                      widgetList.add(
                        const PopupMenuItem<String>(
                          value: 'Show all',
                          child: Text('Show all'),
                        ),
                      );
                      return widgetList;
                    }),
                PopupMenuButton<String>(
                  tooltip: 'Sort by',
                  icon: const Icon(Icons.sort_by_alpha_outlined),
                  onSelected: (String result) {
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
                      .toList(),
                ),
              ],
            ),
            body: ListView(
              children: state.careTaskList
                  .map(
                    (task) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          TaskDetailedView.routeName,
                          arguments: task,
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category: ${task.category?.name}'),
                              ]),
                          trailing: EffortIcon(
                            effort: task.taskEffort.value,
                          ),
                          leading: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: task.taskPriority.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
