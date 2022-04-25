import 'package:careshare/kudos/kudos_board_widget.dart';
import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KudosBoard extends StatelessWidget {
  final List<Profile> profileList;
  const KudosBoard({Key? key, required this.profileList}) : super(key: key);

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
          child: Row(
            children: _profileList
                .map((Profile profile) => KudosBoardWidget(profile: profile))
                .toList(),
          ),
        );
      },
    );
  }
}
