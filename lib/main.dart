import 'package:careshare/caregroup_manager/domain/usecases/all_caregroup_usecases.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'authentication/presenter/authentication_page.dart';
import 'home_page/presenter/home_page.dart';
import 'global.dart';
import '../profile_manager/domain/usecases/all_profile_usecases.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(home: App()));
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

          // fetchProfile();


          // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
          // print('myProfileId: $myProfileId');
          // print('#caregroups: {$caregroups}');

          return const HomePage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const CircularProgressIndicator();
      },
    );
  }
}
