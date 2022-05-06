import 'package:careshare/notifications/presenter/cubit/notifications_cubit.dart';
import 'package:careshare/notifications/presenter/widgets/bell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import '../../task_manager/cubit/task_cubit.dart';

class NotificationsPage extends StatelessWidget {
  static const String routeName = "/notifications-page";
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoaded) {
          state.notificationsList.sort(
            (a, b) => b.dateTime.compareTo(a.dateTime),
          );
          return Scaffold(
            appBar: AppBar(
              title: const Text('Notifications Page'),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    key: const Key('Delete'),
                    onPressed: () {
                      BlocProvider.of<NotificationsCubit>(context)
                          .deleteAllNotifications();
                    },
                    label: const Text('Delete all'),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.extended(
                    key: const Key('Mark as read'),
                    onPressed: () {
                      BlocProvider.of<NotificationsCubit>(context)
                          .markAllAsRead();
                    },
                    label: const Text('Mark all as read'),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                ListTile(
                    leading: const BellWidget(),
                    title: state.numberOfNewNotifications == 0
                        ? const Text('You have no new notifications')
                        : Text(
                            "You have ${state.numberOfNewNotifications} new notification${state.numberOfNewNotifications > 1 ? 's' : ''}",
                          )),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                      itemCount: state.notificationsList.length,
                      itemBuilder: (context, index) {
                        final notification = state.notificationsList[index];
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            BlocProvider.of<NotificationsCubit>(context)
                                .deleteNotification(notification.id);
                          },
                          background: Container(
                            color: Colors.red,
                            child: const Center(
                              child: ListTile(
                                leading:
                                    Icon(Icons.delete, color: Colors.white),
                                title: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (!notification.isRead) {
                                BlocProvider.of<NotificationsCubit>(context)
                                    .markAsRead(notification.id);
                              }
                              if (notification.routeName.isNotEmpty) {
                                if (notification.routeName ==
                                    "/task-detailed-view") {
                                  final task = BlocProvider.of<TaskCubit>(
                                          context)
                                      .fetchTaskFromID(notification.arguments);

                                  if (task == null) {
                                    Navigator.pop(context);
                                    return;
                                  }
                                  Navigator.pushNamed(
                                    context,
                                    notification.routeName,
                                    arguments: task,
                                  );
                                  return;
                                }
                                Navigator.pushNamed(
                                  context,
                                  notification.routeName,
                                );
                              }
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  leading: SizedBox(
                                    width: 40,
                                    child: ProfilePhotoWidget(
                                      id: notification.senderId,
                                    ),
                                  ),
                                  title: Text(notification.title),
                                  subtitle: Text(notification.subtitle),
                                  trailing: !notification.isRead
                                      ? Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.blue,
                                            shape: BoxShape.circle,
                                          ),
                                          height: 10,
                                          width: 10)
                                      : null,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}
