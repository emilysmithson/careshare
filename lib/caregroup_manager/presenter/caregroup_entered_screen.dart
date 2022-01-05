import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import 'caregroup_widgets/caregroup_job_summary_widget.dart';
import '../domain/models/caregroup.dart';
import 'edit_caregroup_screen.dart';
import 'view_all_caregroups_screen.dart';
import '../../home_page/presenter/home_page.dart';

class CaregroupEnteredScreen extends StatelessWidget {
  final Caregroup caregroup;
  const CaregroupEnteredScreen({Key? key, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Caregroup Created'),
      endDrawer: CustomDrawer(),
      body: Column(
        children: [
          CaregroupJobSummaryWidget(
            caregroup: caregroup,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateOrEditACaregroupScreen()));
            },
            child: const Text('Create a new caregroup'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewAllCaregroupsScreen(),
                ),
              );
            },
            child: const Text('View all caregroups'),
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
