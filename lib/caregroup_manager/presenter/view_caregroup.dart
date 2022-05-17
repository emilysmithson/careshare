import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/view-caregroup_invitations.dart';
import 'package:careshare/caregroup_manager/presenter/view-caregroup_memebers.dart';
import 'package:careshare/caregroup_manager/presenter/view-caregroup_overview.dart';
import 'package:careshare/caregroup_manager/presenter/edit_caregroup.dart';
import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:careshare/profile_manager/models/profile.dart';

class ViewCaregroup extends StatefulWidget {
  static const routeName = '/view-caregroup';
  final Caregroup caregroup;

  const ViewCaregroup({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  State<ViewCaregroup> createState() => _ViewCaregroupState();
}

class _ViewCaregroupState extends State<ViewCaregroup> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {


      return Scaffold(
        appBar: AppBar(
          title: const Text('Caregroup Details'),
          actions: const [],
        ),
        // floatingActionButton: FloatingActionButton(
        //     onPressed: () async {
        //       // InviteUserToCaregroup().call(context);
        //
        //       Navigator.of(context).pushNamed(InviteUserToCaregroup.routeName,
        //           arguments: widget.caregroup);
        //
        //       setState(() {});
        //     },
        //     child: const Icon(Icons.add)),
        body: (_selectedIndex == 0) ? ViewCaregroupOverview(caregroup: widget.caregroup)
            : (_selectedIndex == 1)
            ? ViewCaregroupMembers(caregroup: widget.caregroup)
            : ViewCaregroupInvitations(caregroup: widget.caregroup),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.summarize_outlined),
              label: 'Overview',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outlined),
              label: 'Members',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mail_outline),
              label: 'Invitations',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },

        ),
      );
  }
}
