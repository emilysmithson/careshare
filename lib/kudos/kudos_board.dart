import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/kudos/kudos_board_widget.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/task_manager/cubit/task_cubit.dart';
import 'package:careshare/task_manager/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KudosValue {
  Profile profile;
  int kudosValue;

  KudosValue({required this.profile, required this.kudosValue});
}

class KudosBoard extends StatelessWidget {
  final List<Profile> profileList;
  final Caregroup caregroup;

  const KudosBoard({Key? key, required this.profileList, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Profile> _profileList = profileList.toList();

    List<KudosValue> _kudosValues = [];
    _profileList.forEach((profile) {
      int _kudosValue = 0;
      List<CareTask> mytaskList = BlocProvider.of<TaskCubit>(context)
          .taskList
          .where((task) => task.completedBy == profile.id && task.taskStatus.complete)
          .toList();
      for (var task in mytaskList) {
        for (var kudos in task.kudos!) {
          _kudosValue = _kudosValue + task.taskEffort.value;
        }
      }
      _kudosValues.add(KudosValue(profile: profile, kudosValue: _kudosValue));
    });
    _kudosValues.sort((a, b) => b.kudosValue.compareTo(a.kudosValue));

    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _kudosValues.map((KudosValue _kudosValue) {
              return KudosBoardWidget(
                  profile: _kudosValue.profile, kudosValue: _kudosValue.kudosValue, caregroup: caregroup);


            }).toList(),
          ),
        );
      },
    );
  }
}
