import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/profile_manager/presenter/view_profile_in_caregroup.dart';
import 'package:flutter/material.dart';

import 'package:careshare/profile_manager/models/profile.dart';

class KudosBoardWidget extends StatelessWidget {
  final Profile profile;
  final int kudosValue;
  final Caregroup caregroup;

  const KudosBoardWidget({Key? key, required this.profile, required this.kudosValue, required this.caregroup})
      : super(key: key);

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
          padding: const EdgeInsets.fromLTRB(2.0, 6.0, 24.0, 6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ProfilePhotoWidget(id: profile.id),
                  Positioned(
                    bottom: -4,
                    right: -22,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[50], shape: BoxShape.circle, border: Border.all(color: Colors.blue[100]!)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text('*${kudosValue.toString()}',style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
