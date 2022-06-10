import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/profile_manager/presenter/view_profile_in_caregroup.dart';
import 'package:flutter/material.dart';

import 'package:careshare/profile_manager/models/profile.dart';

class KudosBoardWidget extends StatelessWidget {
  final Profile profile;
  final int kudosValue;
  final Caregroup caregroup;

  const KudosBoardWidget({Key? key, required this.profile, required this.kudosValue, required this.caregroup}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Tooltip(
      message: profile.displayName,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            ViewProfileInCaregroup.routeName,
            arguments: {
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
              ProfilePhotoWidget(id: profile.id),
              const SizedBox(width: 2),
              Column(mainAxisSize: MainAxisSize.min, children: [

                Row(children: [
                  const Icon(Icons.star, size: 10),
                  const SizedBox(width: 2),
                  Text(kudosValue.toString()),
                ]),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
