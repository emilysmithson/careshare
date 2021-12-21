import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../task_manager/presenter/create_or_edit_task/create_or_edit_task_screen.dart';
import '../../task_manager/presenter/task_manager/task_manager_screen.dart';

import '../../profile_manager/presenter/profile_page.dart';
import '../../profile_manager/domain/usecases/all_profile_usecases.dart';
import '../../task_manager/domain/usecases/all_task_usecases.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

Future fetchProfile() async {


final response = await ProfileUsecases.fetchProfiles(search: "QqoEQYifYCvH_p6dkMt");
  response.fold((l) => print(l.message), (r) => print(r));
}


class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {

    print('######################################################');
    print('HOME PAGE');
    print('######################################################');

    fetchProfile();




    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Welcome to CareShare,'),
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
                    builder: (context) => const TaskManagerScreen(),
                  ),
                );
              },
              child: const Text('View all tasks'),
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
