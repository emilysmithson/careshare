import 'package:careshare/home_page/cubit/home_page_cubit.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/profile_overview.dart';
import 'package:careshare/task_manager/presenter/task_manager_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../main.dart';
import '../profile_manager/presenter/profile_widgets/profile_summary.dart';

class CareshareDrawer extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  CareshareDrawer({
    Key? key,
  })  : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const ListTile(
            tileColor: Colors.blueAccent,
            title: Text(
              'Careshare Menu',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),

          const Divider(),

          //
          // ListTile(
          //   tileColor: Colors.lightBlueAccent,
          //   title: Text('New Task',
          //     style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
          //   ),
          //   trailing: Icon(Icons.add_box_outlined, size: 30, color: Colors.white,),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CreateOrEditATaskScreen(),
          //       ),
          //     );
          //   },
          // ),
          //
          // Divider(),
          //
          // ListTile(
          //   tileColor: Colors.lightBlueAccent,
          //   title: Text('All Profiles',
          //     style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
          //   ),
          //   trailing: Icon(Icons.person_outline, size: 30, color: Colors.white,),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ViewAllProfilesScreen(),
          //       ),
          //     );
          //   },
          // ),
          //
          // Divider(),
          //
          // ListTile(
          //   tileColor: Colors.lightBlueAccent,
          //   title: Text('New Profile',
          //     style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
          //   ),
          //   trailing: Icon(Icons.add_box_outlined, size: 30, color: Colors.white,),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CreateProfileScreen(),
          //       ),
          //     );
          //   },
          // ),
          //
          // Divider(),
          //
          // ListTile(
          //   tileColor: Colors.lightBlueAccent,
          //   title: Text('All Caregroups',
          //     style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
          //   ),
          //   trailing: Icon(Icons.people_alt, size: 30, color: Colors.white,),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => ViewAllCaregroupsScreen(),
          //       ),
          //     );
          //   },
          // ),
          //
          // Divider(),
          //
          // ListTile(
          //   tileColor: Colors.lightBlueAccent,
          //   title: Text('New Caregroup',
          //     style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
          //   ),
          //   trailing: Icon(Icons.add_box_outlined, size: 30, color: Colors.white,),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CreateCaregroupScreen(),
          //       ),
          //     );
          //   },
          // ),
          //
          const Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              BlocProvider.of<HomePageCubit>(context).navigateTo(
                ProfileSummary(
                    profile: BlocProvider.of<ProfileCubit>(context).fetchMyProfile(),
                ),
              );
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'Task Manager',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.task,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              BlocProvider.of<HomePageCubit>(context)
                  .navigateTo(const TaskManagerView());
              Navigator.pop(context);
            },
          ),

          const Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'Profile Manager',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.task,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              BlocProvider.of<HomePageCubit>(context)
                  .navigateTo(const ProfilesOverview());
              Navigator.pop(context);
            },
          ),

          const Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'Signout',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const App(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
