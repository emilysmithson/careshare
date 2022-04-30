import 'package:bloc/bloc.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:equatable/equatable.dart';

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

  filterBy(String careCategory) {
    emit(
      TaskCategoryViewInitial(careTaskList: careTaskList),
    );
    if (careCategory == 'Show all') {
      return;
    }
    final List<CareTask> _tempCareTaskList = [];

    _tempCareTaskList.addAll(
      careTaskList.where(
        (careTask) => careTask.category!.id == careCategory,
      ),
    );
    emit(
      TaskCategoryViewAmendedList(careTaskList: _tempCareTaskList),
    );
  }

  sortBy(String value) {
    emit(
      TaskCategoryViewInitial(careTaskList: careTaskList),
    );
    if (value == 'Date created') {
      careTaskList.sort(
        (a, b) => a.taskCreatedDate!.compareTo(b.taskCreatedDate!),
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
        (a, b) => a.createdBy!.compareTo(b.createdBy!),
      );
    }

    emit(
      TaskCategoryViewAmendedList(careTaskList: careTaskList),
    );
  }
}
