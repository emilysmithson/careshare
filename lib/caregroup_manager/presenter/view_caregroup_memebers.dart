import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/profile_manager/presenter/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewCaregroupMembers extends StatefulWidget {
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
      body: BlocBuilder<AllProfilesCubit, AllProfilesState>(builder: (context, state) {
        if (state is AllProfilesLoaded) {
          return ListView(
              children: state.profileList
                  .map(
                    (profile) => GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ViewProfile.routeName,
                          arguments: profile,
                        );
                      },
                      child: Card(
                        child: ListTile(
                          title: Text("${profile.firstName} ${profile.lastName}"),
                          subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('email: ${profile.email}'),
                            Row(
                              children: [
                                Text(
                                    "role: ${profile.carerInCaregroups.firstWhere((element) => element.caregroupId == widget.caregroup.id).role.role}"),
                                Text(
                                    "   satus: ${profile.carerInCaregroups.firstWhere((element) => element.caregroupId == widget.caregroup.id).status.status}"),
                              ],
                            ),
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
                                value: "Block",
                              ),
                              const PopupMenuItem(
                                child: Text("Remove"),
                                value: "Remove",
                              )
                            ],
                          ),
                          leading: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: NetworkImage(profile.photo), fit: BoxFit.cover),
                            ),
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
