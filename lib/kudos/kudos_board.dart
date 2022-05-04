import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/kudos/kudos_board_widget.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KudosBoard extends StatelessWidget {
  final List<Profile> profileList;
  final Caregroup caregroup;
  const KudosBoard({Key? key, required this.profileList, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Profile> _profileList = profileList.toList();
    _profileList.sort(
      (a, b) => b.kudos.compareTo(a.kudos),
    );
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
          Row(
            children:
            _profileList.map((Profile profile) {
              return KudosBoardWidget(profile: profile, caregroup: caregroup);
            }).toList(),
          ),
        );
      },
    );
  }
}
