import 'package:careshare/task_manager/domain/models/task_status.dart';
import 'package:flutter/material.dart';
import '../../domain/models/task.dart';
import '../../domain/usecases/all_task_usecases.dart';
import '../task_entered/task_entered_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AcceptATaskController {
  final formKey = GlobalKey<FormState>();
  DateTime? acceptedDateTime;
  String? id;
  late CareTask task;

  initialiseControllers(CareTask? originalTask) {
    task = originalTask!;
    id = originalTask.id;
    acceptedDateTime = originalTask.taskAcceptedForDate;
  }

  acceptATask({
    required BuildContext context
  }) async {
    if (formKey.currentState!.validate()) {

      task.taskAcceptedForDate = acceptedDateTime;
      task.taskStatus = TaskStatus.accepted;

      String? id = FirebaseAuth.instance.currentUser?.uid;
      if (id != null) {
        task.acceptedBy = id;
      }

      AllTasksUseCases.editATask(task);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TaskEnteredScreen(task: task),
        ),
      );
    }
  }
}
