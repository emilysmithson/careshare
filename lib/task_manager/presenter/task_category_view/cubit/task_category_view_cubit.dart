import 'package:bloc/bloc.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:equatable/equatable.dart';

import '../../../../category_manager/domain/models/category.dart';

part 'task_category_view_state.dart';

class TaskCategoryViewCubit extends Cubit<TaskCategoryViewState> {
  final List<CareTask> careTaskList;

  TaskCategoryViewCubit({
    required this.careTaskList,
  }) : super(
          TaskCategoryViewInitial(
            careTaskList: careTaskList,
          ),
        );

  filterBy(CareCategory careCategory) {
    emit(
      TaskCategoryViewInitial(careTaskList: careTaskList),
    );
    final List<CareTask> _tempCareTaskList = careTaskList;
    careTaskList.clear();
    careTaskList.addAll(
      _tempCareTaskList.where((careTask) => careTask.category == careCategory),
    );
    emit(
      TaskCategoryViewAmendedList(careTaskList: careTaskList),
    );
  }

  sortBy(String value) {
    emit(
      TaskCategoryViewInitial(careTaskList: careTaskList),
    );
    if (value == 'Date created') {
      careTaskList.sort(
        (a, b) => a.dateCreated.compareTo(b.dateCreated),
      );
    }
    if (value == 'Priority') {
      careTaskList.sort(
        (a, b) => b.taskPriority.value.compareTo(a.taskPriority.value),
      );
    }
    if (value == 'Category') {
      careTaskList.sort(
        (a, b) => a.category!.name.compareTo(b.category!.name),
      );
    }
    if (value == 'Created By') {
      careTaskList.sort(
        (a, b) => a.createdBy.compareTo(b.createdBy),
      );
    }

    emit(
      TaskCategoryViewAmendedList(careTaskList: careTaskList),
    );
  }
}
