import 'package:flutter/material.dart';

import 'caregroup_widgets/caregroup_job_summary_widget.dart';
import '../domain/models/caregroup.dart';
import 'create_or_edit_caregroup_screen.dart';
import 'view_all_caregroups_screen.dart';
import '../../home_page/presenter/home_page.dart';

class CaregroupEnteredScreen extends StatelessWidget {
  final Caregroup caregroup;
  const CaregroupEnteredScreen({Key? key, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Thank you for entering a caregroup',
        ),
      ),
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
