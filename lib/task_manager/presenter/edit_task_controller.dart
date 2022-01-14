import 'package:careshare/caregroup_manager/domain/models/caregroup.dart';
import 'package:careshare/task_manager/domain/models/task_size.dart';
import 'package:flutter/material.dart';

import '../domain/models/task_priority.dart';
import '../domain/models/task.dart';
import '../domain/models/task_status.dart';
import '../domain/usecases/all_task_usecases.dart';
import 'task_entered_screen.dart';
import 'package:careshare/global.dart';

class EditTaskController {
  final formKey = GlobalKey<FormState>();
  TaskSize? taskSize;
  TaskStatus? taskStatus;
  bool isCreateTask = true;
  bool isLoading = true;
  Caregroup? caregroup;

  TaskPriority priority = TaskPriority.medium;
  final List<Caregroup> caregroupList = carerInCaregroups;
  final List<String> caregroupOptions = [];

  late TextEditingController titleController;
  late TextEditingController detailsController;
  late TextEditingController categoryController;
  String? id;

  // Future fetchCaregroupList(CareTask originalTask) async {
  //   final response = await AllCaregroupUseCases.fetchAllCaregroups();
  //   response.fold(
  //           (l) {
  //         // print(">l " + l.message);
  //         if (l.message=='no value'){
  //           // print('no Caregroups');
  //         }
  //       },
  //           (r) {
  //
  //           caregroupList.addAll(r);
  //           caregroupList.forEach((element) {
  //           caregroupOptions.add(element.name!);
  //
  //           if (originalTask != null) {
  //             caregroup = caregroupList.firstWhere((element) => element.id ==
  //                 originalTask.caregroupId);
  //           }
  //
  //           });
  //       });
  // }

  initialiseControllers(CareTask? originalTask) async {
    // print(myProfile.firstName);
    // print(careeInCaregroups);
    // print(carerInCaregroups);

    caregroupList.forEach((element) {
      caregroupOptions.add(element.name!);
    });

    if (originalTask != null) {
      caregroup = caregroupList.firstWhere((element) => element.id ==
          originalTask.caregroupId);
    }

    if (originalTask != null) {
      isCreateTask = false;
      id = originalTask.id;
    }
    titleController = TextEditingController(
      text: originalTask?.title,
    );
    detailsController = TextEditingController(
      text: originalTask?.details,
    );
    categoryController = TextEditingController(
      text: originalTask?.category,
    );
    taskSize = originalTask?.taskSize;

  // await fetchCaregroupList();


  }


  createTask({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      final CareTask task = CareTask(
        caregroupId: caregroup!.id!,
        caregroupDisplayName: caregroup!.name!,
        taskSize: taskSize!,
        taskStatus: TaskStatus.created,
        title: titleController.text,
        details: detailsController.text,
        category: categoryController.text,
        dateCreated: DateTime.now(),
        taskPriority: priority,
      );
      if (isCreateTask) {
        final response = await AllTaskUseCases.createATask(task);
        response.fold((l) => print('ERROR SAVING TASK ${l.message}'), (r) => task.id = r);
      } else {
        task.id = id;
        AllTaskUseCases.editATask(task);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskEnteredScreen(task: task),
        ),
      );
    }
  }
}
