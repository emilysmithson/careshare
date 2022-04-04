import 'package:careshare/kudos/kudos_board_widget.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter/material.dart';

class KudosBoard extends StatelessWidget {
  final List<Profile> profileList;
  const KudosBoard({Key? key, required this.profileList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    profileList.sort(
      (a, b) => b.kudos.compareTo(a.kudos),
    );
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          spacing: 8,
          alignment: WrapAlignment.spaceAround,
          children: profileList
              .map((Profile profile) => KudosBoardWidget(profile: profile))
              .toList(),
        ),
      ),
    );
  }
}
