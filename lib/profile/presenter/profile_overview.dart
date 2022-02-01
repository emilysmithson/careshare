import 'package:careshare/profile/models/profile.dart';
import 'package:careshare/profile/presenter/profile_widgets/profile_summary.dart';
import 'package:flutter/material.dart';

class ProfilesOverview extends StatelessWidget {
  final List<Profile> profileList;
  const ProfilesOverview({Key? key, required this.profileList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        children: profileList
            .map(
              (profile) => ProfileSummary(
                profile: profile,
              ),
            )
            .toList(),
      ),
    );
  }
}
