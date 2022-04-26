import 'package:careshare/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future initialiseNotifications(String userId) async {
  void onMessage(RemoteMessage message) {}
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  messaging.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  messaging.subscribeToTopic('task');
  messaging.subscribeToTopic('task_completed');
  messaging.subscribeToTopic(userId);

  // print("kudos/$userId");


  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print('onMessageOpenedApp');
    onMessage(message);
  });

  FirebaseMessaging.onBackgroundMessage((message) async {
    print('onBackgroundMessage');
    onMessage(message);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: AlertDialog(
            title: Text(message.notification?.title ?? 'New Notification'),
            // content: Column(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Text(message.notification?.body ?? ''),
            //     Text(message.data['created_by']),
            //   ],
            // ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('See task'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Dismiss'),
              ),
            ],
          ),
        ),
      ),
    );
  });
}
