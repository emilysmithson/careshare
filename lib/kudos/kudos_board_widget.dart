import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/models/profile_role_in_caregroup.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/profile_manager/presenter/view_profile.dart';
import 'package:flutter/material.dart';

class KudosBoardWidget extends StatelessWidget {
  final Profile profile;
  final Caregroup caregroup;
  const KudosBoardWidget({Key? key, required this.profile, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    RoleInCaregroup roleInCaregroup = profile.carerInCaregroups!.firstWhere((element) => element.caregroupId == caregroup.id);
    return Tooltip(
      message: profile.name,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ViewProfile.routeName,
            arguments:
            {
              'caregroup': caregroup,
              'profile': profile,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfilePhotoWidget(id: profile.id!),
              const SizedBox(width: 2),
              Column(
                mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row(
                    //     children: [
                    //       const Icon(Icons.check_box_rounded, size: 10),
                    //       const SizedBox(width: 2),
                    //       Text(roleInCaregroup.completedCount.toString()),
                    //     ]),
                    Row(
                        children: [
                          const Icon(Icons.star, size: 10),
                          const SizedBox(width: 2),
                          Text(roleInCaregroup.kudosValue.toString()),
                        ]),

                  ]

              ),
            ],
          ),
        ),
      ),
    );
  }
}
