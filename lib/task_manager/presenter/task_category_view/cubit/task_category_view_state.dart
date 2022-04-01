part of 'task_category_view_cubit.dart';

abstract class TaskCategoryViewState extends Equatable {
  final List<String> filterCategories = [
    'Priority',
    'Category',
    'Created By',
  ];
  final List<String> sortCategories = [
    'Date created',
    'Priority',
    'Category',
    'Created By',
  ];
  final List<CareTask> careTaskList;

  TaskCategoryViewState({
    required this.careTaskList,
  });

  @override
  List<Object> get props => [];
}

class TaskCategoryViewInitial extends TaskCategoryViewState {
  TaskCategoryViewInitial({required List<CareTask> careTaskList})
      : super(careTaskList: careTaskList);
}

class TaskCategoryViewAmendedList extends TaskCategoryViewState {
  TaskCategoryViewAmendedList({required List<CareTask> careTaskList})
      : super(careTaskList: careTaskList);
}
