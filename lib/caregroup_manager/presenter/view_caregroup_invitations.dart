import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/invite_user_to_caregroup.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';

import 'package:careshare/invitation_manager/cubit/invitations_cubit.dart';
import 'package:careshare/invitation_manager/cubit/my_invitations_cubit.dart';
import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/profile_manager/presenter/view_profile.dart';
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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.caregroup.name),
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
        elevation: 0,
        toolbarHeight: 40,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          BellWidget(
            caregroup: widget.caregroup,
          ),
          // IconButton(
          //   icon: const Icon(Icons.more_vert),
          //   onPressed: () {},
          // ),
        ],
      ),
      body: BlocBuilder<InvitationsCubit, InvitationsState>(builder: (context, state) {
        if (state is InvitationsLoaded) {
          return ListView(
              children: state.invitationList
                  .map(
                    (invitation) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ViewProfile.routeName,
                          arguments: invitation,
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(invitation.email),
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                                'invited by: ${profileList.firstWhere((element) => element.id == invitation.invitedById).name} on ${DateFormat('d MMM yyyy').format(invitation.invitedDate)}'),
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
                      ),
                    ),
                  )
                  .toList());
        } else {
          return Container();
        }
      }),
    );
  }
}
