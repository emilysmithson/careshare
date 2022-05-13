import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/kudos/kudos_board_widget.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../my_profile/models/profile.dart';

class KudosBoard extends StatelessWidget {
  final List<Profile> profileList;
  final Caregroup caregroup;
  const KudosBoard(
      {Key? key, required this.profileList, required this.caregroup})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Profile> _profileList = profileList.toList();
    _profileList.sort(
      (a, b) => b.carerInCaregroups
          .firstWhere((element) => element.caregroupId == caregroup.id)
          .kudosValue
          .compareTo(a.carerInCaregroups
              .firstWhere((element) => element.caregroupId == caregroup.id)
              .kudosValue),
      // (a, b) => b.kudos.compareTo(a.kudos),
    );
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _profileList.map((Profile profile) {
              return KudosBoardWidget(profile: profile, caregroup: caregroup);
            }).toList(),
          ),
        );
      },
    );
  }
}
