import 'package:careshare/task_manager/domain/usecases/edit_a_task.dart';
import 'package:flutter/material.dart';

import '../../domain/models/task.dart';
import '../../domain/usecases/create_a_task.dart';
import '../../external/task_datasource_impl.dart';
import '../../infrastructure/repositories/task_repository_impl.dart';
import '../task_entered/task_entered_screen.dart';

class CreateATaskController {
  final formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;

  initialiseControllers(CareTask? task) {
    titleController = TextEditingController(text: task?.title);
    descriptionController = TextEditingController(text: task?.description);
  }

  createATask(BuildContext context, CareTask? originalTask) {
    final TaskDatasourceImpl datasource = TaskDatasourceImpl();
    final TaskRepoositoryImpl repository = TaskRepoositoryImpl(datasource);
    final CreateATask createATaskUseCase = CreateATask(repository);
    final EditATask editATask = EditATask(repository);
    if (formKey.currentState!.validate()) {
      final CareTask task = CareTask(
        title: titleController.text,
        description: descriptionController.text,
        createdBy: 'Emily',
      );
      if (originalTask == null) {
        createATaskUseCase(task);
      } else {
        editATask(task);
      }
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => TaskEnteredScreen(task: task)));
    }
  }
}
