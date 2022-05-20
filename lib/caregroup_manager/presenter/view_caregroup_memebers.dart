import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/invite_user_to_caregroup.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';

import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ViewCaregroupMembers extends StatefulWidget {
  static const routeName = '/view-caregroup-overview';
  final Caregroup caregroup;

  const ViewCaregroupMembers({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  State<ViewCaregroupMembers> createState() => _ViewCaregroupMembersState();
}

class _ViewCaregroupMembersState extends State<ViewCaregroupMembers> {
  @override
  Widget build(BuildContext context) {
    final profileList = BlocProvider.of<AllProfilesCubit>(context).profileList;
    final invitationList = BlocProvider.of<InvitationsCubit>(context).invitationList;
    BlocProvider.of<InvitationsCubit>(context).fetchInvitations(caregroupId: widget.caregroup.id);
    return BlocBuilder<InvitationsCubit, InvitationState>(builder: (context, state) {
      if (state is InvitationLoading) {
        return const LoadingPageTemplate(loadingMessage: 'Loading invitations...');
      }
      if (state is InvitationError) {
        return ErrorPageTemplate(errorMessage: state.message);
      }
      if (state is InvitationLoaded) {
        return SingleChildScrollView(
          child: Column(
            children: [
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
                            Text('Member', style: TextStyle(fontWeight: FontWeight.bold)),
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
                            Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
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
                            Text('Status', style: TextStyle(fontWeight: FontWeight.bold)),
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
                                Expanded(child: Text(profile.email)),
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
                                  .firstWhere((element) => element.caregroupId == widget.caregroup.id)
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
                                  .firstWhere((element) => element.caregroupId == widget.caregroup.id)
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
              ),

              // Invitations
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(columnWidths: const {
                  0: FlexColumnWidth(4),
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
                            Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
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
                            Text('Invited By', style: TextStyle(fontWeight: FontWeight.bold)),
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
                            Text('Invited Date', style: TextStyle(fontWeight: FontWeight.bold)),
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
                              Text(profileList.firstWhere((element) => element.id == invitation.invitedById).name),
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
                              Expanded(child: Text(DateFormat('d MMM yyyy').format(invitation.invitedDate))),
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
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return InviteUserToCaregroup(caregroup: widget.caregroup);
                            });
                      },
                      child: const Text('Invite someone else to join this group')),
                ],
              ),
            ],
          ),
        );
      }
      return Container();
    });
  }
}
