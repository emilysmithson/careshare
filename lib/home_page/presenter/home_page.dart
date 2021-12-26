import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/presenter/view_all_profiles_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../task_manager/presenter/create_or_edit_task_screen.dart';
import '../../task_manager/presenter/view_all_tasks_screen.dart';

import '../../profile_manager/presenter/profile_page.dart';
import '../../profile_manager/domain/usecases/all_profile_usecases.dart';
import '../../task_manager/domain/usecases/all_task_usecases.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {

  late Profile myProfile;
  bool isLoading = true;

  Future fetchProfile() async {
    final response = await AllProfileUseCases.fetchMyProfile();
    response.fold((l) => print(">l "+l.message), (r) {
      myProfile = r;
      isLoading = false;
      setState(() {});
    });
  }

  @override
  void initState() {
    fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    print('######################################################');
    print('HOME PAGE');
    print('######################################################');

    if (isLoading){
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator()
        )
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${myProfile.name}, welcome to CareShare,'),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateOrEditATaskScreen()));
              },
              child: const Text('Create a new task'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAllTasksScreen(),
                  ),
                );
              },
              child: const Text('View all tasks'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAllProfilesScreen(),
                  ),
                );
              },
              child: const Text('View all profiles'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
              child: const Text('MyProfile'),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const App(),
                  ),
                );
              },
              child: const Text('Logout'),
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const ProfilePage(),
            //       ),
            //     );
            //   },
            //   child: const Text('Onboarding'),
            // ),
          ],
        ),
      ),
    );
  }
}
