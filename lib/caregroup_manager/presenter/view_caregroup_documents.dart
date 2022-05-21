import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:flutter/material.dart';

class ViewCaregroupDocuments extends StatelessWidget {
  static const routeName = '/view-caregroup-overview';
  final Caregroup caregroup;

  const ViewCaregroupDocuments({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Documents')

        ),

      ],
    );


  }
}
