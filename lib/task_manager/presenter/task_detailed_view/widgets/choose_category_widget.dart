import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../category_manager/cubit/category_cubit.dart';
import '../../../../category_manager/domain/models/category.dart';
import '../../../../category_manager/presenter/add_category_widget.dart';
import '../../../cubit/task_cubit.dart';
import '../../../models/task.dart';

class ChooseCategoryWidget extends StatelessWidget {
  final CareTask task;
  final bool showButton;
  final bool locked;
  const ChooseCategoryWidget({
    Key? key,
    required this.task,
    this.showButton = false,
    this.locked = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];

    widgetList.addAll(
      BlocProvider.of<CategoriesCubit>(context)
          .categoryList
          .map(
            (CareCategory category) => GestureDetector(
              onTap: () {
                if (!locked) {
                  BlocProvider.of<TaskCubit>(context).editTask(
                    task: task,
                    newValue: category,
                    taskField: TaskField.category,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: task.category == category
                    ? BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(2),
                      )
                    : null,
                child: Text(category.name),
              ),
            ),
          )
          .toList(),
    );

    if (!locked) widgetList.add(const AddCategoryWidget());
    return InputDecorator(
      decoration: const InputDecoration(
        label: Text('Category'),
      ),
      child: Wrap(
        runSpacing: 8,
        spacing: 8,
        alignment: WrapAlignment.spaceEvenly,
        children: widgetList,
      ),
    );
  }
}
