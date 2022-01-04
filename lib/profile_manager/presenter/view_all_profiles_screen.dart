import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'profile_widgets/profile_job_summary_widget.dart';
import '../domain/models/profile.dart';
import 'view_all_profiles_controller.dart';

class ViewAllProfilesScreen extends StatefulWidget {
  const ViewAllProfilesScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllProfilesScreen> createState() => _ViewAllProfilesScreenState();
}

class _ViewAllProfilesScreenState extends State<ViewAllProfilesScreen> {
  final controller = ViewAllProfilesController();

  @override
  void initState() {
    controller.fetchProfiles();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('All Profiles'),
      body: ValueListenableBuilder(
        valueListenable: controller.status,
        builder: (context, status, _) {
          if (status == PageStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (status == PageStatus.error) {
            return const Center(child: Text('Couldn'' load profiles'));
          }
          return SingleChildScrollView(
            child: Column(
                children: controller.profileList.map((Profile profile) {
                  return ProfileJobSummaryWidget(profile: profile);
                }).toList()),
          );
        },
      ),
    );
  }
}
