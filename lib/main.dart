import 'package:careshare/task_manager/presenter/tasks_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'authentication/presenter/authentication_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(Colors.green[50]),
            foregroundColor: MaterialStateProperty.all(Colors.black),
          ),
        ),
        appBarTheme:
            const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle.light),
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black),
          headline2: TextStyle(
              fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(8),
          border: OutlineInputBorder(),
        ),
      ),
      home: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // Future fetchProfile() async {
  //   final response = await AllProfileUseCases.fetchMyProfile();
  //   response.fold(
  //           (l) {
  //             // print(">l " + l.message);
  //             },
  //           (r) {myProfileId = r.id!;});
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {}

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          if (FirebaseAuth.instance.currentUser == null) {
            return AuthenticationPage();
          }

          return TasksView();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}
