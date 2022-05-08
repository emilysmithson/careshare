import 'package:careshare/about_page/about_page.dart';
import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/authentication/presenter/authentication_page.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/profile_manager/presenter/profile_manager.dart';
import 'package:careshare/task_manager/presenter/task_manager_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),

          const Divider(),

          //
          // ListTile(
          //   tileColor: Colors.lightBlueAccent,
          //   title: Text('New Task',
          //     style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500,color: Colors.white,),
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
          //     style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500,color: Colors.white,),
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
          //     style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500,color: Colors.white,),
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
          //     style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500,color: Colors.white,),
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
          //     style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.w500,color: Colors.white,),
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
          // const Divider(),

          // ListTile(
          //   tileColor: Colors.lightBlueAccent,
          //   title: const Text(
          //     'Home',
          //     style: TextStyle(
          //       fontSize: 16.0,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.white,
          //     ),
          //   ),
          //   trailing: const Icon(
          //     Icons.home,
          //     size: 30,
          //     color: Colors.white,
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.pushNamed(
          //       context,
          //         TaskManagerView.routeName,
          //     );
          //   },
          // ),
          // const Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'My Profile',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                EditProfile.routeName,
                arguments: BlocProvider.of<ProfileCubit>(context).myProfile,
              );
            },
          ),
          const Divider(),
          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'Task Manager',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.task,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                TaskManagerView.routeName,
              );
            },
          ),

          const Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'Profile Manager',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.wc,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                ProfilesManager.routeName,
              );
            },
          ),

          const Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'Caregroup Manager',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.wheelchair_pickup_sharp,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              // Navigator.pushNamed(
              //   context,
              //   CaregroupsManager.routeName,
              // );
            },
          ),

          const Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'Signout',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.logout,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              BlocProvider.of<AuthenticationCubit>(context).logout(
                BlocProvider.of<ProfileCubit>(context),
              );
              Navigator.pushNamedAndRemoveUntil(
                  context,
                  AuthenticationPage.routeName,
                  ModalRoute.withName(AuthenticationPage.routeName));
            },
          ),

          const Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: const Text(
              'About',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            trailing: const Icon(
              Icons.info_outlined,
              size: 30,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AboutPage.routeName,
              );
            },
          ),
        ],
      ),
    );
  }
}
