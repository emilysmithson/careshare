import 'package:careshare/global.dart';
import 'package:careshare/story_manager/domain/models/story.dart';
import 'package:careshare/story_manager/domain/usecases/all_story_usecases.dart';

import 'package:flutter/material.dart';
import '../domain/models/task.dart';
import '../domain/usecases/all_task_usecases.dart';
import 'task_entered_screen.dart';

class AcceptTaskController {
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

      // Create the comment
      final comment = Comment(
          createdBy: myProfile.id,
          createdByDisplayName: myProfile.displayName,
          dateCreated: DateTime.now(),
          commment: commentController.text);

      // Save the comment
      AllTaskUseCases.addComment(
        comment: comment,
        taskId: task.id!,
        profileId: myProfile.id!,
        acceptedDateTime: DateTime.now(),
        displayName: myProfile.displayName,
      );

      // Add the comment to the task
      task.comments!.add(comment);

      // Create the story
      Story newStory = Story(
          taskId: task.id,
          dateCreated: DateTime.now(),
          createdBy: myProfile.id,
          createdByDisplayName: myProfile.displayName,
          story:
              '${myProfile.displayName} accepted task ${task.title} for caregroup ${task.caregroupDisplayName} on ${DateTime.now().toString()}');

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
