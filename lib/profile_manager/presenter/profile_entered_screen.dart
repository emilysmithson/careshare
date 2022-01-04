import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'profile_widgets/profile_job_summary_widget.dart';
import '../domain/models/profile.dart';
import 'edit_profile_screen.dart';
import 'view_all_profiles_screen.dart';
import '../../home_page/presenter/home_page.dart';

class ProfileEnteredScreen extends StatelessWidget {
  final Profile profile;
  const ProfileEnteredScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('New Profile Created'),

      body: Column(
        children: [
          ProfileJobSummaryWidget(
            profile: profile,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()));
            },
            child: const Text('Create a new profile'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewAllProfilesScreen(),
                ),
              );
            },
            child: const Text('View all profiles'),
          ),TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }
}
