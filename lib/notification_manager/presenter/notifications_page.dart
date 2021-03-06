import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/notification_manager/cubit/notifications_cubit.dart';
import 'package:careshare/notification_manager/models/careshare_notification.dart';
import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatelessWidget {
  static const String routeName = "/notifications-page";
  final Caregroup caregroup;

  const NotificationsPage({Key? key, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        if (state is NotificationsLoaded) {
          List<CareshareNotification> myNotifications =
              state.notificationsList.where((n) => n.caregroupId == caregroup.id).toList();
          myNotifications.sort(
            (a, b) => b.dateTime.compareTo(a.dateTime),
          );
          int myNewNotificationsCount = myNotifications.where((n) => n.isRead == false).length;
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
                      BlocProvider.of<NotificationsCubit>(context).deleteAllNotifications(caregroup);
                    },
                    label: const Text('Delete all'),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton.extended(
                    key: const Key('Mark as read'),
                    onPressed: () {
                      BlocProvider.of<NotificationsCubit>(context).markAllAsRead();
                    },
                    label: const Text('Mark all as read'),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                ListTile(
                    leading: BellWidget(
                      caregroup: caregroup,
                    ),
                    title: myNewNotificationsCount == 0
                        ? const Text('You have no new notifications')
                        : Text(
                            "You have $myNewNotificationsCount new notification${myNewNotificationsCount > 1 ? 's' : ''}",
                          )),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                      itemCount: myNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = myNotifications[index];
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            BlocProvider.of<NotificationsCubit>(context).deleteNotification(notification.id);
                          },
                          background: Container(
                            color: Colors.red,
                            child: const Center(
                              child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.white),
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
                                BlocProvider.of<NotificationsCubit>(context).markAsRead(notification.id);
                              }
                              if (notification.routeName.isNotEmpty) {
                                if (notification.routeName == "/task-detailed-view") {
                                  final task =
                                      BlocProvider.of<TaskCubit>(context).fetchTaskFromID(notification.arguments);

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
