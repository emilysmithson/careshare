import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../category_manager/cubit/category_cubit.dart';
import '../../../../category_manager/models/category.dart';
import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';
import 'add_category_widget.dart';

class ChooseCategoryWidget extends StatelessWidget {
  final CareTask task;
  final bool showButton;
  const ChooseCategoryWidget({
    Key? key,
    required this.task,
    this.showButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showButton) {
      return ElevatedButton(
        onPressed: () {
          _showDialog(context);
        },
        child: const Text('Choose a Category'),
      );
    }
    return GestureDetector(
      child: Text(task.category == null
          ? 'Category: Choose a category'
          : 'Category: ${task.category!.name}'),
      onTap: () {
        _showDialog(context);
      },
    );
  }

  _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => BlocProvider.value(
              value: BlocProvider.of<CategoriesCubit>(context),
              child: BlocProvider.value(
                value: BlocProvider.of<TaskCubit>(context),
                child: BlocBuilder<TaskCubit, TaskState>(
                  builder: (context, state) {
                    List<Widget> widgetList = [];

                    widgetList.addAll(
                      BlocProvider.of<CategoriesCubit>(context)
                          .categoryList
                          .map((CareCategory category) => GestureDetector(
                                onTap: () {
                                  BlocProvider.of<TaskCubit>(context).editTask(
                                    task: task,
                                    newValue: category,
                                    taskField: TaskField.category,
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: task.category == category
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[100],
                                  ),
                                  child: Text(category.name),
                                ),
                              ))
                          .toList(),
                    );

                    widgetList.add(const AddCategoryWidget());
                    return AlertDialog(
                      title: const Text('Category'),
                      content: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: widgetList,
                      ),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Ok'))
                      ],
                    );
                  },
                ),
              ),
            ));
  }
}
