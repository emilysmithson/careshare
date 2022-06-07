import 'package:careshare/about_page/about_page.dart';
import 'package:careshare/authentication/cubit/authentication_cubit.dart';
import 'package:careshare/authentication/presenter/authentication_page.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/edit_my_profile.dart';
import 'package:careshare/profile_manager/presenter/profile_manager.dart';
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
                EditMyProfile.routeName,
              );
            },
          ),
          const Divider(),
          // ListTile(
          //   tileColor: Colors.lightBlueAccent,
          //   title: const Text(
          //     'Task Manager',
          //     style: TextStyle(
          //       fontSize: 16.0,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.white,
          //     ),
          //   ),
          //   trailing: const Icon(
          //     Icons.task,
          //     size: 30,
          //     color: Colors.white,
          //   ),
          //   onTap: () {
          //     Navigator.pushNamed(
          //       context,
          //       TaskManagerView.routeName,
          //     );
          //   },
          // ),
          //
          // const Divider(),

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

          // ListTile(
          //   tileColor: Colors.lightBlueAccent,
          //   title: const Text(
          //     'Caregroup Manager',
          //     style: TextStyle(
          //       fontSize: 16.0,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.white,
          //     ),
          //   ),
          //   trailing: const Icon(
          //     Icons.wheelchair_pickup_sharp,
          //     size: 30,
          //     color: Colors.white,
          //   ),
          //   onTap: () {
          //     Navigator.pushNamed(
          //       context,
          //       CaregroupManager.routeName,
          //     );
          //   },
          // ),
          //
          // const Divider(),

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
            onTap: () async {

              await BlocProvider.of<AuthenticationCubit>(context).logout(
                BlocProvider.of<MyProfileCubit>(context),
                // BlocProvider.of<TaskCubit>(context),
                // BlocProvider.of<CaregroupCubit>(context),
                // BlocProvider.of<InvitationsCubit>(context),
                // BlocProvider.of<MyInvitationsCubit>(context),
              );


              Navigator.pushNamedAndRemoveUntil(
                  context, AuthenticationPage.routeName, ModalRoute.withName(AuthenticationPage.routeName));
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
