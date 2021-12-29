import 'package:careshare/caregroup_manager/presenter/create_caregroup_screen.dart';
import 'package:careshare/caregroup_manager/presenter/view_all_caregroups_screen.dart';
import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/presenter/create_profile_screen.dart';
import 'package:careshare/profile_manager/presenter/view_all_profiles_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../task_manager/presenter/create_or_edit_task_screen.dart';
import '../../task_manager/presenter/view_all_tasks_screen.dart';

import '../../profile_manager/presenter/view_my_profile_page.dart';
import '../../profile_manager/domain/usecases/all_profile_usecases.dart';

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
    response.fold(
            (l) {
              print(">l " + l.message);

                if (l.message=='no value'){
                print('no value for this authId');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CreateProfileScreen()));
                }
              },
            (r) {
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
      appBar: AppBar(

        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'images/CareShareLogo50.jpg',
              fit: BoxFit.contain,
              height: 32,
            ),
            Container(
                padding: const EdgeInsets.all(8.0), child: Text('CareShare')),

          ],

        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_alert),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            tooltip: 'Go to the next page',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text('Next page'),
                    ),
                    body: const Center(
                      child: Text(
                        'This is the next page',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  );
                },
              ));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [


            Text('${myProfile.firstName}, welcome to CareShare,'),
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
                    builder: (context) => const CreateProfileScreen(),
                  ),
                );
              },
              child: const Text('Create a profile'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewAllCaregroupsScreen(),
                  ),
                );
              },
              child: const Text('View all caregroups'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateCaregroupScreen(),
                  ),
                );
              },
              child: const Text('Create a caregroup'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewMyProfilePage(),
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
