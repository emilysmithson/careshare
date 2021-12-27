import 'package:flutter/material.dart';

import 'profile_widgets/profile_job_summary_widget.dart';
import '../domain/models/profile.dart';
import 'create_or_edit_profile_screen.dart';
import 'view_all_profiles_screen.dart';
import '../../home_page/presenter/home_page.dart';

class ProfileEnteredScreen extends StatelessWidget {
  final Profile profile;
  const ProfileEnteredScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thank you for entering a profile',
        ),
      ),
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
                      builder: (context) => const CreateOrEditAProfileScreen()));
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
