import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCaregroupInvitations extends StatelessWidget {
  static const routeName = '/view-caregroup-overview';
  final Caregroup caregroup;

  const ViewCaregroupInvitations({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final profileList = BlocProvider.of<AllProfilesCubit>(
        context).profileList;

    final invitationList = BlocProvider.of<InvitationsCubit>(context)
        .invitationList;



    return Column(
      children: [


        // Invitations
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Table(columnWidths: const {
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
        ),

      ],
    );





  }
}
