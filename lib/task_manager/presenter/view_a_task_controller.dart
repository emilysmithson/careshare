import 'package:careshare/task_manager/domain/models/task_status.dart';
import 'package:flutter/material.dart';
import '../domain/models/task.dart';
import '../domain/usecases/all_task_usecases.dart';
import 'task_entered_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ViewATaskController {
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

  ViewATask({
    required BuildContext context
  }) async {
    if (formKey.currentState!.validate()) {

      task.taskAcceptedForDate = acceptedDateTime;
      task.taskStatus = TaskStatus.accepted;
      if (commentController.text != null){
        task.comments!.add(
          Comment(
            createdBy: "me",
            dateCreated: DateTime.now(),
            commment: commentController.text
          )
        );
      }

      String? id = FirebaseAuth.instance.currentUser?.uid;
      if (id != null) {
        task.acceptedBy = id;
      }

      AllTaskUseCases.editATask(task);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskEnteredScreen(task: task),
        ),
      );
    }
  }
}
