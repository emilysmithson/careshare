import 'package:careshare/caregroup_manager/domain/models/caregroup.dart';
import 'package:careshare/story_manager/domain/models/story.dart';
import 'package:careshare/story_manager/domain/usecases/all_story_usecases.dart';
import 'package:flutter/material.dart';

import '../domain/models/task_priority.dart';
import '../domain/models/task.dart';
import '../domain/models/task_type.dart';
import '../domain/models/task_status.dart';
import '../domain/models/task_size.dart';
import '../domain/usecases/all_task_usecases.dart';
import 'task_entered_screen.dart';
import 'package:careshare/global.dart';

class CreateTaskController {
  final formKey = GlobalKey<FormState>();
  TaskType? taskType;
  TaskStatus? taskStatus;
  bool isLoading = true;
  Caregroup? caregroup;

  TaskPriority priority = TaskPriority.medium;
  TaskSize taskSize = TaskSize.medium;

  final List<Caregroup> caregroupList = carerInCaregroups;
  final List<String> caregroupOptions = [];

  late TextEditingController titleController;
  late TextEditingController detailsController;
  String? id;


  initialiseControllers()  {

    caregroupList.forEach((element) {
      caregroupOptions.add(element.name!);
    });

    titleController = TextEditingController();
    detailsController = TextEditingController();
    taskType = null;
    // taskSize = null;

  }


  createTask({required BuildContext context}) async {
    if (formKey.currentState!.validate()) {

      // Create the task
      final CareTask task = CareTask(
        caregroupId: caregroup!.id!,
        caregroupDisplayName: caregroup!.name!,
        taskType: taskType!,
        taskSize: taskSize,
        taskStatus: TaskStatus.created,
        title: titleController.text,
        details: detailsController.text,
        dateCreated: DateTime.now(),
        taskPriority: priority,
      );

      final response = await AllTaskUseCases.createATask(task);
      response.fold((l) => print('ERROR SAVING TASK ${l.message}'), (r) => task.id = r);

      // Create the story
      Story newStory = Story(
        taskId: task.id,
        dateCreated: DateTime.now(),
        createdBy: myProfile.id,
        createdByDisplayName: myProfile.displayName,
        story:
        '${myProfile.displayName} created task ${task.title} for caregroup ${task.caregroupDisplayName} on ${DateTime.now().toString()}');

      // Save the story
      AllStoryUseCases.createAStory(newStory);
      // response.fold((l) => null, (r) => caregroup.id = r);



      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskEnteredScreen(task: task),
        ),
      );
    }
  }
}
