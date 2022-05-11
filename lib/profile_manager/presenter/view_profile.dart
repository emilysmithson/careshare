import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewProfile extends StatelessWidget {
  final Caregroup caregroup;
  final Profile profile;
  static const routeName = '/view-profile';

  const ViewProfile({
    Key? key,
    required this.caregroup,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Profile myProfile = BlocProvider.of<ProfileCubit>(context).myProfile;
    RoleInCaregroup roleInCaregroup = profile.carerInCaregroups!
        .firstWhere((element) => element.caregroupId == caregroup.id);

    // const double spacing = 16;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('User Details'),
            actions: const [],
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
                        image: NetworkImage(profile.photo), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Username',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(profile.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('First Name',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(profile.firstName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Last Name',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(profile.lastName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Email',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(profile.email,
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
                      child: Text(profile.createdDate.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
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
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Role',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(roleInCaregroup.role.role,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Tasks Completed',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(roleInCaregroup.completedCount.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Value Of Tasks Completed',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(roleInCaregroup.completedValue.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Kudos Count',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(roleInCaregroup.kudosCount.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Kudos Value',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(roleInCaregroup.kudosValue.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                if (profile == myProfile)
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, EditProfile.routeName,
                                arguments:
                                    BlocProvider.of<ProfileCubit>(context)
                                        .myProfile);
                          },
                          child: const Text('Edit')),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
