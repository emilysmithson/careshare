import 'package:careshare/task_manager/models/task.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class FetchTasks {
  ValueNotifier<List<CareTask>> careTaskList =
      ValueNotifier<List<CareTask>>([]);
  fetchTasks() async {
    DatabaseReference reference = FirebaseDatabase.instance.ref('tasks_test');
    final response = reference.onValue;
    response.listen((event) {
      final List<CareTask> _careTaskList = [];
      if (event.snapshot.value == null) {
        if (kDebugMode) {
          print('empty list');
        }
        return;
      } else {
        Map<dynamic, dynamic> returnedList =
            event.snapshot.value as Map<dynamic, dynamic>;
        if (kDebugMode) {
          print(returnedList);
        }

        returnedList.forEach(
          (key, value) {
            _careTaskList.add(CareTask.fromJson(key, value));
          },
        );
        careTaskList.value.clear();
        careTaskList.value.addAll(_careTaskList);
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        careTaskList.notifyListeners();
      }
    });
  }
}
