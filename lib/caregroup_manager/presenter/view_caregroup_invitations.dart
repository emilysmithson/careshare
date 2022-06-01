import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/invite_user_to_caregroup.dart';

import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ViewCaregroupInvitations extends StatefulWidget {
  final Caregroup caregroup;

  const ViewCaregroupInvitations({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  State<ViewCaregroupInvitations> createState() => _ViewCaregroupInvitationsState();
}

class _ViewCaregroupInvitationsState extends State<ViewCaregroupInvitations> {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<InvitationsCubit>(context).fetchInvitations(caregroupId: widget.caregroup.id);

    // profiles
    final profileList = BlocProvider.of<AllProfilesCubit>(context).profileList;
    print("profileList: ${profileList.length}");

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.caregroup.name),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        elevation: 0,
        toolbarHeight: 40,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.search),
          //   onPressed: () {},
          // ),
          BellWidget(
            caregroup: widget.caregroup,
          ),
          // IconButton(
          //   icon: const Icon(Icons.more_vert),
          //   onPressed: () {},
          // ),
        ],
      ),
      bottomSheet: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InviteUserToCaregroup(caregroup: widget.caregroup);
                      });
                },
                child: const Text('Invite someone else to join this group')

            ),
          ),
        ],
      ),

      body: BlocBuilder<InvitationsCubit, InvitationsState>(builder: (context, state) {
        if (state is InvitationsLoaded) {
          return ListView(
              children: state.invitationList
                  .map(
                    (invitation) {
                      print("invitation.invitedById: ${invitation.invitedById}");
                      String _inviter = "unknown";
                      if (profileList.indexWhere((element) => element.id == invitation.invitedById) != -1){
                        _inviter = profileList.firstWhere((element) => element.id == invitation.invitedById).name;
                      }

                      return Card(
                        child: ListTile(
                          title: Text(invitation.email),
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                                'invited by: $_inviter on ${DateFormat('d MMM yyyy').format(invitation.invitedDate)}'),
                          ]),
                          trailing: PopupMenuButton(
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
                                child: Text("Resend Invitation"),
                                value: "Resend Invitation",
                              ),
                              const PopupMenuItem(
                                child: Text("Cancel Invitation"),
                                value: "Cancel Invitation",
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  )
                  .toList());
        } else {
          return Container();
        }
      }),
    );
  }
}

// Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// ElevatedButton(
// onPressed: () {
// showDialog(
// context: context,
// builder: (BuildContext context) {
// return InviteUserToCaregroup(caregroup: widget.caregroup);
// });
// },
// child: const Text('Invite someone else to join this group')),
// ],
// ),
