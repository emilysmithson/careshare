import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:careshare/profile_manager/models/profile.dart';
import 'package:intl/intl.dart';

class ViewProfileInCaregroup extends StatelessWidget {
  final Caregroup caregroup;
  final Profile profile;
  static const routeName = '/view-profile';

  const ViewProfileInCaregroup({
    Key? key,
    required this.caregroup,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;
    RoleInCaregroup roleInCaregroup = profile.carerInCaregroups
        .firstWhere((element) => element.caregroupId == caregroup.id);


    int tasksValue = 0;
    int tasksCount = 0;
    int kudosValue = 0;
    int kudosCount = 0;

    List<CareTask> mytaskList = BlocProvider.of<TaskCubit>(context)
        .taskList
        .where((task) => task.completedBy == profile.id && task.taskStatus.complete)
        .toList();
    for (var task in mytaskList) {
      tasksCount = tasksCount + 1;
      tasksValue = tasksValue + task.taskEffort.value;

      for (var kudos in task.kudos!) {
        kudosCount = kudosCount + 1;
        kudosValue = kudosValue + task.taskEffort.value;
      }
    }

    // const double spacing = 16;
    return BlocBuilder<MyProfileCubit, MyProfileState>(
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
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(image: NetworkImage(profile.photo), fit: BoxFit.fitWidth),
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(
                      flex: 4,
                      child: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(profile.displayName,
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
                      child: Text('Last accessed',
                          style: TextStyle(fontWeight: FontWeight.normal)),
                    ),
                    Expanded(
                      flex: 6,
                      child: (roleInCaregroup.lastLogin == null) ?Text("") : Text(DateFormat('E d MMM yyyy').add_jm().format(roleInCaregroup.lastLogin!),
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
                      child: Text(tasksCount.toString(),
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
                      child: Text(tasksValue.toString(),
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
                      child: Text(kudosCount.toString(),
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
                      child: Text(kudosValue.toString(),
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
                                    BlocProvider.of<MyProfileCubit>(context)
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
