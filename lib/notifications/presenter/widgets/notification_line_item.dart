import 'package:careshare/notifications/domain/careshare_notification.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:flutter/material.dart';

class NotificationLineItem extends StatelessWidget {
  final CareshareNotification notification;
  const NotificationLineItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(
          context,
          notification.routeName,
          arguments: notification.arguments,
        );
      },
      leading: ProfilePhotoWidget(
        id: notification.senderId,
        size: 30,
      ),
      title: Text(notification.title),
      subtitle: Text(notification.subtitle),
      trailing: notification.isRead
          ? Container()
          : const CircleAvatar(
              foregroundColor: Colors.blue,
              radius: 10,
            ),
    );
  }
}
