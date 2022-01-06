import 'package:careshare/global.dart';
import 'package:careshare/story_manager/domain/models/story.dart';
import 'package:careshare/story_manager/domain/usecases/all_story_usecases.dart';
import 'package:careshare/task_manager/domain/models/task_status.dart';
import 'package:flutter/material.dart';
import '../domain/models/task.dart';
import '../domain/usecases/all_task_usecases.dart';
import 'task_entered_screen.dart';

class AcceptATaskController {
  final formKey = GlobalKey<FormState>();
  DateTime? acceptedDateTime;
  String? id;
  late CareTask task;

  late TextEditingController commentController;

  initialiseControllers(CareTask? originalTask) {
    task = originalTask!;
    id = originalTask.id;
    acceptedDateTime = originalTask.taskAcceptedForDate;

    commentController = TextEditingController(
      text: "",
    );
  }

  acceptATask({required BuildContext context}) async {
    if (formKey.currentState!.validate()) {
      final comment = Comment(
          createdBy: myProfile.id,
          createdByDisplayName: myProfile.displayName,
          dateCreated: DateTime.now(),
          commment: commentController.text);
      AllTaskUseCases.addComment(
        comment: comment,
        taskId: task.id!,
        profileId: myProfile.id!,
        acceptedDateTime: DateTime.now(),
        displayName: myProfile.displayName,
      );
      Story newStory = Story(
          name: 'name',
          dateCreated: DateTime.now(),
          createdBy: myProfile.id,
          createdByDisplayName: myProfile.displayName,
          story:
              '${myProfile.displayName} accepted task ${task.title} for caregroup ${task.caregroupDisplayName} on ${DateTime.now().toString()}');
      await AllStoryUseCases.createAStory(newStory);
      // response.fold((l) => null, (r) => caregroup.id = r);
      // myProfileId = caregroup.id!;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskEnteredScreen(task: task),
        ),
      );
    }
  }
}
