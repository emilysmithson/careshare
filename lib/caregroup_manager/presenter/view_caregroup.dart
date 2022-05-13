import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/invite_user_to_caregroup.dart';
import 'package:careshare/invitation_manager/cubit/invitation_cubit.dart';
import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../my_profile/models/profile.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(builder: (context, state) {
      if (state is ProfilesLoaded) {
        final profileList = state.profileList.where((profile) =>
            profile.carerInCaregroups.indexWhere(
                (element) => element.caregroupId == widget.caregroup.id) !=
            -1);

        final invitationList = BlocProvider.of<InvitationCubit>(context)
            .invitationList
            .where(
                (invitation) => invitation.caregroupId == widget.caregroup.id);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Caregroup Details'),
            actions: const [],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // InviteUserToCaregroup().call(context);

                Navigator.of(context).pushNamed(InviteUserToCaregroup.routeName,
                    arguments: widget.caregroup);

                setState(() {});
              },
              child: const Icon(Icons.add)),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: NetworkImage(widget.caregroup.photo!),
                        fit: BoxFit.cover),
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Caregroup',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(widget.caregroup.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Type',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(widget.caregroup.type.type,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Created',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(widget.caregroup.createdDate.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),

                const SizedBox(height: 16),

                // Members
                Table(
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
                              Text('${profile.firstName} ${profile.lastName}'),
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
                                      widget.caregroup.id)
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
                                      widget.caregroup.id)
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
                ]),

                const SizedBox(height: 16),

                // Invitations
                Table(columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
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
                            Text('Email',
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
                            Text('Invited By',
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
                            Text('Invited Date',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const TableCell(
                      child: (SizedBox(width: 1)),
                    ),
                  ]),
                  for (Invitation invitation in invitationList)
                    TableRow(children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                invitation.email,
                                overflow: TextOverflow.fade,
                              )),
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(profileList
                                  .firstWhere((element) =>
                                      element.id == invitation.invitedById)
                                  .name),
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  child:
                                      Text(invitation.invitedDate.toString())),
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
                          onSelected: (value) {},
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              child: Text("View Profile"),
                              value: 1,
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
                ]),

                // const SizedBox(height: 16),
                // Row(
                //   children: [
                //     ElevatedButton(
                //         onPressed: () {
                //           Navigator.pushReplacementNamed(
                //               context, EditCaregroup.routeName,
                //               arguments:
                //               caregroup);
                //         },
                //         child: const Text('Edit')),
                //   ],
                // ),
              ],
            ),
          ),
        );
      }
      return const Center(child: CircularProgressIndicator());
    });
  }
}
