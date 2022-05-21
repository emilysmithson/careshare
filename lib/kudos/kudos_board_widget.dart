import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/profile_manager/presenter/view_profile_in_caregroup.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:flutter/material.dart';

import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KudosBoardWidget extends StatelessWidget {
  final Profile profile;
  final Caregroup caregroup;

  const KudosBoardWidget({Key? key, required this.profile, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int kudosValue = 0;

    if (false) {
      RoleInCaregroup roleInCaregroup =
          profile.carerInCaregroups.firstWhere((element) => element.caregroupId == caregroup.id);

      int kudosValue = roleInCaregroup.kudosValue;
    } else {
      List<CareTask> mytaskList = BlocProvider.of<TaskCubit>(context)
          .taskList
          .where((task) => task.completedBy == profile.id && task.taskStatus.complete)
          .toList();
      mytaskList.forEach((task) {
        task.kudos!.forEach((kudos) {
          kudosValue = kudosValue + task.taskEffort.value;
        });

      });
    }

    return Tooltip(
      message: profile.name,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ViewProfileInCaregroup.routeName,
            arguments: {
              'caregroup': caregroup,
              'profile': profile,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfilePhotoWidget(id: profile.id),
              const SizedBox(width: 2),
              Column(mainAxisSize: MainAxisSize.min, children: [
                // Row(
                //     children: [
                //       const Icon(Icons.check_box_rounded, size: 10),
                //       const SizedBox(width: 2),
                //       Text(roleInCaregroup.completedCount.toString()),
                //     ]),
                Row(children: [
                  const Icon(Icons.star, size: 10),
                  const SizedBox(width: 2),
                  Text(kudosValue.toString()),
                ]),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
