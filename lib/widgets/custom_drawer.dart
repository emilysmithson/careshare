import 'package:careshare/caregroup_manager/presenter/create_caregroup_screen.dart';
import 'package:careshare/caregroup_manager/presenter/view_all_caregroups_screen.dart';
import 'package:careshare/profile_manager/presenter/create_profile_screen.dart';
import 'package:careshare/profile_manager/presenter/view_all_profiles_screen.dart';
import 'package:careshare/profile_manager/presenter/view_my_profile_page.dart';
import 'package:careshare/task_manager/presenter/create_or_edit_task_screen.dart';
import 'package:careshare/task_manager/presenter/view_all_tasks_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../main.dart';


class CustomDrawer extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;


  CustomDrawer({ Key? key,}) : preferredSize = Size.fromHeight(50.0),super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(

      child: ListView(
        children:  [
          const ListTile(
            tileColor: Colors.blueAccent,
            title: Text('Menu',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),

          Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: Text('All Tasks',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
            ),
            trailing: Icon(Icons.list_alt, size: 30, color: Colors.white,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewAllTasksScreen(),
                ),
              );
            },
          ),

          Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: Text('New Task',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
            ),
            trailing: Icon(Icons.add_box_outlined, size: 30, color: Colors.white,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateOrEditATaskScreen(),
                ),
              );
            },
          ),

          Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: Text('All Profiles',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
            ),
            trailing: Icon(Icons.person_outline, size: 30, color: Colors.white,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewAllProfilesScreen(),
                ),
              );
            },
          ),

          Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: Text('New Profile',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
            ),
            trailing: Icon(Icons.add_box_outlined, size: 30, color: Colors.white,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateProfileScreen(),
                ),
              );
            },
          ),

          Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: Text('All Caregroups',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
            ),
            trailing: Icon(Icons.people_alt, size: 30, color: Colors.white,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewAllCaregroupsScreen(),
                ),
              );
            },
          ),

          Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: Text('New Caregroup',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
            ),
            trailing: Icon(Icons.add_box_outlined, size: 30, color: Colors.white,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateCaregroupScreen(),
                ),
              );
            },
          ),

          Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: Text('Settings',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
            ),
            trailing: Icon(Icons.settings, size: 30, color: Colors.white,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewMyProfilePage(),
                ),
              );
            },
          ),

          Divider(),

          ListTile(
            tileColor: Colors.lightBlueAccent,
            title: Text('Signout',
              style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w800,color: Colors.white,),
            ),
            trailing: Icon(Icons.logout, size: 30, color: Colors.white,),
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