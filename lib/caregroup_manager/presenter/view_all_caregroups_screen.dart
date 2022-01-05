import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'caregroup_widgets/caregroup_job_summary_widget.dart';
import '../domain/models/caregroup.dart';
import 'view_all_caregroups_controller.dart';

class ViewAllCaregroupsScreen extends StatefulWidget {
  const ViewAllCaregroupsScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllCaregroupsScreen> createState() => _ViewAllCaregroupsScreenState();
}

class _ViewAllCaregroupsScreenState extends State<ViewAllCaregroupsScreen> {
  final controller = ViewAllCaregroupsController();

  @override
  void initState() {
    controller.fetchCaregroups();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('All Caregroups'),
      endDrawer: CustomDrawer(),
      body: ValueListenableBuilder(
        valueListenable: controller.status,
        builder: (context, status, _) {
          if (status == PageStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (status == PageStatus.error) {
            return const Center(child: Text('Couldn'' load caregroups'));
          }
          return SingleChildScrollView(
            child: Column(
                children: controller.caregroupList.map((Caregroup caregroup) {
                  return CaregroupJobSummaryWidget(caregroup: caregroup);
                }).toList()),
          );
        },
      ),
    );
  }
}
