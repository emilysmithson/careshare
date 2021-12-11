import 'package:careshare/task_manager/domain/models/task.dart';
import 'package:careshare/authentication/domain/models/user.dart';

class FetchTasks {
  List<Task> call() {
    return [
      Task(
        assignedTo: [
          User(
            nickname: 'Emily',
            email: 'Emily_foulkes@hotmail.com',
          ),
        ],
        status: Status.complete,
        title: 'Fix the dishwasher',
        assigned: false,
        createdBy: User(
          nickname: 'Emily',
          email: 'Emily_foulkes@hotmail.com',
        ),
      )
    ];
  }
}
