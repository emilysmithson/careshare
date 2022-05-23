part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsError extends NotificationsState {
  final String errorMessage;

  const NotificationsError(this.errorMessage);
}

class NotificationsLoaded extends NotificationsState {
  final List<CareshareNotification> notificationsList;
  const NotificationsLoaded({
    required this.notificationsList,
  });
}
