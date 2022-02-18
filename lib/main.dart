import 'package:careshare/router/app_router.dart';

import 'package:flutter/material.dart';

import 'core/presentation/custom_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
    return MaterialApp(
      theme: CustomTheme.themeData,
      onGenerateRoute: _appRouter.onGenerateRoute,
    );
  }
}
