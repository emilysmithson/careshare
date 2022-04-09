import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/presentation/custom_theme.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Future initialise(BuildContext context) async {
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
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    messaging.subscribeToTopic('task');

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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message.notification?.body ?? ''),
                  Text(message.data['created_by']),
                ],
              ),
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

  void onMessage(RemoteMessage message) {}

  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    initialise(context);
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: CustomTheme.themeData,
        onGenerateRoute: _appRouter.onGenerateRoute,
      ),
    );
  }
}
