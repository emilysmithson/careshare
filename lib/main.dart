import 'dart:ui';

import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/notifications/presenter/cubit/notifications_cubit.dart';
import 'package:careshare/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';

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
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: BlocProvider(
        create: (context) => NotificationsCubit(),
        child: MaterialApp(
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
              PointerDeviceKind.unknown
            },
          ),
          navigatorKey: navigatorKey,
          theme: CustomTheme.themeData,
          onGenerateRoute: _appRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
