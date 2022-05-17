import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/invite_user_to_caregroup.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCaregroupMembers extends StatelessWidget {
  static const routeName = '/view-caregroup-overview';
  final Caregroup caregroup;

  const ViewCaregroupMembers({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final profileList = BlocProvider.of<AllProfilesCubit>(
        context).profileList;


    return Column(
      children: [
        Hero(
          tag: 'Caregroup',
          child: Container(
            width: double.infinity,
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Caregroup: ${caregroup.name}',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(
            // border: TableBorder.all(
            //     width: 4.0, color: Colors.white),
              columnWidths: const {
                0: FlexColumnWidth(4),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1),
              }, children: [
            TableRow(children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Text('Member',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Text('Role',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const <Widget>[
                      Text('Status',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const TableCell(
                child: SizedBox(width: 10),
              ),
            ]),
            for (Profile profile in profileList)
              TableRow(children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        if (profile.firstName != "" || profile.lastName != "")
                          Expanded(child: Text('${profile.firstName} ${profile.lastName}'))
                        else
                          Expanded(child: Text(profile.email))                  ,
                      ],
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(profile.carerInCaregroups
                            .firstWhere((element) =>
                        element.caregroupId ==
                            caregroup.id)
                            .role
                            .role),
                      ],
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(profile.carerInCaregroups
                            .firstWhere((element) =>
                        element.caregroupId ==
                            caregroup.id)
                            .status
                            .status),
                      ],
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: PopupMenuButton(
                    child: Container(
                      height: 36,
                      width: 48,
                      alignment: Alignment.centerRight,
                      child: const Icon(
                        Icons.more_vert,
                      ),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case "View Profile":
                          {
                            Navigator.pushNamed(
                              context,
                              EditProfile.routeName,
                              arguments: profile,
                            );
                          }
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("View Profile"),
                        value: "View Profile",
                      ),
                      const PopupMenuItem(
                        child: Text("Block"),
                        value: 2,
                      ),
                      const PopupMenuItem(
                        child: Text("Remove"),
                        value: 2,
                      )
                    ],
                  ),
                ),
              ])
          ]
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, InviteUserToCaregroup.routeName,
                      arguments: caregroup);
                },
                child: const Text('Invite someone to join this group')),
          ],
        ),

      ],
    );


  }
}
