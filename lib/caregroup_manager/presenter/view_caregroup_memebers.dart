import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/notification_manager/presenter/widgets/bell_widget.dart';
import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/profile_manager/presenter/view_profile_in_caregroup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
      body: BlocBuilder<AllProfilesCubit, AllProfilesState>(builder: (context, state) {
        if (state is AllProfilesLoaded) {
          List<Profile> _profileList = state.profileList;
          _profileList.sort((a, b) => a.displayName.compareTo(b.displayName));

          return ListView(
              children: _profileList.map(
            (profile) {
              String _caregroupId = widget.caregroup.id;
              String _role = "unknown";
              String _status = "unknown";
              String _lastLogin = "unknown";

              print("profile: {$profile.toString()}");
              print(
                  "indexWhere: ${profile.carerInCaregroups.indexWhere((element) => element.caregroupId == _caregroupId)}");
              if (profile.carerInCaregroups.indexWhere((element) => element.caregroupId == _caregroupId) != -1) {
                RoleInCaregroup _roleInCaregroup =
                    profile.carerInCaregroups.firstWhere((element) => element.caregroupId == _caregroupId);
                _role = _roleInCaregroup.role.role;
                _status = _roleInCaregroup.status.status;
                if (_roleInCaregroup.lastLogin != null) {
                  _lastLogin = DateFormat('E d MMM yyyy').add_jm().format(_roleInCaregroup.lastLogin!);
                }
              } else {
                print("Profile: '${profile.id}' not found in caregroup: '${widget.caregroup.id}'");
              }

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ViewProfileInCaregroup.routeName,
                    arguments: {
                      'caregroup': widget.caregroup,
                      'profile': profile,
                    },
                  );
                },
                child: Card(
                  child: ListTile(
                    title: Text(profile.displayName),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(profile.email),
                      Text("role: $_role  status: $_status"),
                      Text("last login: $_lastLogin"),
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
              );
            },
          ).toList());
        } else {
          return Container();
        }
      }),
    );
  }
}
