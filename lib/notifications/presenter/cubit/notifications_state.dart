part of 'notifications_cubit.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationsState {
  final int numberOfNewNotifications = 4;
  final List<CareshareNotification> notificationsList = [
    CareshareNotification(
        title: 'Hello',
        routeName: 'test',
        subtitle: 'test',
        dateTime: DateTime.now(),
        userId: 'jyYsR5YLplXfH0ENNaklnAz39Ho1',
        isRead: true,
        arguments: {})
  ];
}

class NotificationsLoaded extends NotificationsState {
  final int numberOfNewNotifications;
  final List<CareshareNotification> notificationsList;

  const NotificationsLoaded(
    this.numberOfNewNotifications,
    this.notificationsList,
  );
}
