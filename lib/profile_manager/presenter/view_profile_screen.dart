import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_summary_widget.dart';
import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';


class ViewProfileScreen extends StatefulWidget {
  final Profile? profile;
  const ViewProfileScreen({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Profile: ${widget.profile!.displayName}'),
      endDrawer: CustomDrawer(),
      body: ProfileSummaryWidget(profile: widget.profile!)
    );
  }
}
