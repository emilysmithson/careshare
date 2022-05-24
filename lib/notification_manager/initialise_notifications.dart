import 'package:careshare/main.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future initialiseNotifications() async {
  final context = navigatorKey.currentContext!;

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
    // print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    // print('User granted provisional permission');
  } else {
    // print('User declined or has not accepted permission');
  }

  // get my profile
  Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;

  // retrieve the my token
  final fcmToken = await FirebaseMessaging.instance.getToken();

  // save it to my profile
  BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
    profileField: ProfileField.messagingToken,
    profile: myProfile,
    newValue: fcmToken,
  );

  messaging.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  if (!kIsWeb) {
    print('unsubscribing.............................................................................');
    messaging.unsubscribeFromTopic('Rc5YlbwrzWbG8Q1um4CkHvfFrwl2');
    messaging.unsubscribeFromTopic('RWfw1NO39sg8fyuMTuOXUUnTS6b2');

    // messaging.subscribeToTopic('task');
    // messaging.subscribeToTopic('task_completed');
    print('subscribing to ${myProfile.id}   .............................................................................');
    messaging.subscribeToTopic(myProfile.id);
  }

  // print("kudos/$userId");

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final route = message.data['route'];
    // print(route);
    final arguments = message.data['arguments'];
    // print(arguments);
    if (route != null) {
      Navigator.pushNamed(context, route, arguments: arguments);
    }
  });

  FirebaseMessaging.onBackgroundMessage((message) async {
    // print('onBackgroundMessage');
    onMessage(message);
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final route = message.data['route'];
    // print(route);
    final arguments = message.data['arguments'];
    // print(arguments);

    showDialog(
      context: context,
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
                  if (route != null) {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, route, arguments: arguments);
                  }
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
