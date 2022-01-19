import 'package:careshare/task_manager/models/task.dart';

import 'package:firebase_database/firebase_database.dart';

class EditTaskField {
  CareTask call(
      {required CareTask task,
      required TaskField taskField,
      required dynamic newValue}) {
    CareTask newTask = task;
    late String field;
    switch (taskField) {
      case TaskField.title:
        newTask.title = newValue;
        field = 'title';
        break;
      case TaskField.details:
        newTask.details = newValue;
        field = 'details';
        break;
      case TaskField.taskEffort:
        newTask.taskEffort = newValue;
        field = 'task_effort';
        break;
      case TaskField.taskPriority:
        newTask.taskPriority = newValue;
        field = 'task_priority';
        break;
      case TaskField.category:
        newTask.category = newValue;
        field = 'category';
        break;
      case TaskField.taskStatus:
        newTask.taskStatus = newValue;
        field = 'task_status';
        break;
      case TaskField.acceptedBy:
        newTask.acceptedBy = newValue;
        field = 'accepted_by';
        break;
      case TaskField.completedBy:
        newTask.completedBy = newValue;
        field = 'completed_by';
        break;
      case TaskField.taskCompleteDate:
        newTask.taskCompletedDate = newValue;
        field = 'task_completed_date';
        break;
    }
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("tasks_test/${task.id}/$field");

    reference.set(newValue);
    return newTask;
  }
}
