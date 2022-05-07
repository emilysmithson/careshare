import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/presenter/invite_user_to_caregroup.dart';
import 'package:careshare/invitation_manager/cubit/invitation_cubit.dart';
import 'package:careshare/invitation_manager/models/invitation.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCaregroup extends StatelessWidget {
  static const routeName = '/view-caregroup';
  final Caregroup caregroup;

  const ViewCaregroup({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {

            final profileList = state.profileList
                .where((profile) => profile.carerInCaregroups!.indexWhere((element) => element.caregroupId==caregroup.id)!= -1);

            final invitationList = BlocProvider.of<InvitationCubit>(context).invitationList
                .where((invitation) => invitation.caregroupId == caregroup.id);

            return Scaffold(

              floatingActionButton: FloatingActionButton(
                  onPressed: () async {
                    // InviteUserToCaregroup().call(context);

                    Navigator.of(context).pushNamed(
                        InviteUserToCaregroup.routeName,
                        arguments: caregroup
                    );

                  },
                  child: const Icon(Icons.add)),


              appBar: AppBar(
                title: const Text('Caregroup Details'),
                actions: [],
              ),
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
                            image: NetworkImage(caregroup.photo!),
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
                          child: Text(caregroup.name,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
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
                          child: Text(caregroup.type.type,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
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
                          child: Text(caregroup.createdDate.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Members
                    Table(
                        // border: TableBorder.all(
                        //     width: 4.0, color: Colors.white),

                        children: [
                          TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Text('Member',style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Text('Role',style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Text('Status',style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),

                              ]),
                          for (Profile profile in profileList) TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${profile.firstName} ${profile.lastName}'),
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
                                        Text(profile.carerInCaregroups!.firstWhere((element) => element.caregroupId==caregroup.id).role.role),
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
                                        Text(profile.carerInCaregroups!.firstWhere((element) => element.caregroupId==caregroup.id).status.status),
                                      ],
                                    ),
                                  ),
                                ),

                              ])
                        ]
                    ),

                    const SizedBox(height: 16),

                    // Invitations
                    Table(
                        children: [
                          TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Text('Email',style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Text('Invited By',style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Text('Invited Date',style: TextStyle(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),


                              ]),
                          for (Invitation invitation in invitationList) TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(invitation.email),
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
                                        Text(profileList.firstWhere((element) => element.id==invitation.invitedById).name),
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
                                        Text(invitation.invitedDate.toString()),
                                      ],
                                    ),
                                  ),
                                ),

                              ])
                        ]
                    ),

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
        }
    );
  }
}