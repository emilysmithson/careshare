import 'package:careshare/categories/cubit/categories_cubit.dart';
import 'package:careshare/categories/models/category.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:careshare/task_manager/presenter/task_widgets/add_category_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPicker extends StatelessWidget {
  final CareTask task;
  const CategoryPicker({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (task.category != null) {
      return Text('Category: ${task.category!.name}');
    }
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
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category'),
            Wrap(
              children: widgetList,
            ),
          ],
        );
      },
    );
  }
}
