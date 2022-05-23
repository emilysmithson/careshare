import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/notification_manager/cubit/notifications_cubit.dart';
import 'package:careshare/notification_manager/models/careshare_notification.dart';
import 'package:careshare/notification_manager/presenter/notifications_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BellWidget extends StatelessWidget {
  final Caregroup caregroup;

  const BellWidget({Key? key, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(builder: (context, state) {
      if (state is NotificationsLoaded) {
        List<CareshareNotification> myNotifications =
            state.notificationsList.where((n) => n.caregroupId == caregroup.id).toList();
        int myNewNotificationsCount = myNotifications.where((n) => n.isRead == false).length;

        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, NotificationsPage.routeName, arguments: caregroup);
          },
          child: SizedBox(
            width: 50,
            height: 50,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Center(child: Icon(Icons.notifications)),
                if (myNewNotificationsCount > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      height: 18,
                      width: 18,
                      child: Center(
                        child: Text(
                          myNewNotificationsCount < 10 ? myNewNotificationsCount.toString() : '9+',
                          style: Theme.of(context).textTheme.caption?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }
}
