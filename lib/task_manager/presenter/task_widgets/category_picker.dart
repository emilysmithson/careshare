import 'package:careshare/categories/cubit/categories_cubit.dart';
import 'package:careshare/categories/models/category.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryPicker extends StatelessWidget {
  final CareCategory category;
  final CareTask task;
  const CategoryPicker({Key? key, required this.category, required this.task})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        return GestureDetector(
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
              color:
                  task.category == category ? Colors.yellow : Colors.grey[100],
            ),
            child: Text(category.name),
          ),
        );
      },
    );
  }
}
