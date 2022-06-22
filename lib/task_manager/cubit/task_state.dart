part of 'task_cubit.dart';

abstract class  TaskState extends Equatable {
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

class TaskUpdating extends TaskState {
  const TaskUpdating();
}

class TaskLoaded extends TaskState {
  final List<CareTask> careTaskList;
  
  const TaskLoaded({
    required this.careTaskList,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskLoaded && listEquals(other.careTaskList, careTaskList);
  }

  @override
  int get hashCode => careTaskList.hashCode;
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
