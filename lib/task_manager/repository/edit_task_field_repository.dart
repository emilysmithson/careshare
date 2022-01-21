import 'package:careshare/task_manager/models/task.dart';

import 'package:firebase_database/firebase_database.dart';

class EditTaskFieldRepository {
  CareTask call(
      {required CareTask task,
      required TaskField taskField,
      required dynamic newValue}) {
    CareTask newTask = task;
    late String field;
    // ignore: prefer_typing_uninitialized_variables
    late var value;
    switch (taskField) {
      case TaskField.title:
        newTask.title = newValue;
        field = 'title';
        value = newValue;
        break;
      case TaskField.details:
        newTask.details = newValue;
        field = 'details';
        value = newValue;
        break;
      case TaskField.taskEffort:
        newTask.taskEffort = newValue;
        field = 'task_effort';
        value = newValue.value;
        break;
      case TaskField.taskPriority:
        newTask.taskPriority = newValue;
        field = 'task_priority';
        value = newValue.value;
        break;
      case TaskField.category:
        newTask.category = newValue;
        field = 'category';
        value = newValue;
        break;
      case TaskField.taskStatus:
        newTask.taskStatus = newValue;
        field = 'task_status';
        value = newValue.status;
        break;
      case TaskField.acceptedBy:
        newTask.acceptedBy = newValue;
        field = 'accepted_by';
        value = newValue;
        break;
      case TaskField.completedBy:
        newTask.completedBy = newValue;
        field = 'completed_by';
        value = newValue;
        break;
      case TaskField.taskCompleteDate:
        newTask.taskCompletedDate = newValue;
        field = 'task_completed_date';
        value = newValue.toString();
        break;
      case TaskField.acceptedOnDate:
        newTask.acceptedOnDate = newValue;
        field = 'accepted_on_date';

        value = newValue.toString();
        break;
      // case TaskField.comments:
      //   newTask.comments.add(newValue);
      //   field = 'comments';
      //   value = newTask.comments.map((e) => e.toJson());
      //   break;
    }

    DatabaseReference reference =
        FirebaseDatabase.instance.ref("tasks_test/${task.id}/$field");

    reference.set(value);
    return newTask;
  }
}