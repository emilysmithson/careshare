part of 'task_cubit.dart';

enum CareTaskView {
  overview,
  details,
}

abstract class TaskState extends Equatable {
  const TaskState();

  @override
  List<Object> get props => [];
}

class TaskInitial extends TaskState {
  const TaskInitial();
}

class TaskLoading extends TaskState {
  const TaskLoading();
}

class TaskLoaded extends TaskState {
  final List<CareTask> careTaskList;
  final CareTaskView view;
  final CareTask? task;

  const TaskLoaded({required this.careTaskList, required this.view, this.task});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskLoaded &&
        listEquals(other.careTaskList, careTaskList) &&
        other.view == view &&
        other.task == task;
  }

  @override
  int get hashCode => careTaskList.hashCode ^ view.hashCode ^ task.hashCode;
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
