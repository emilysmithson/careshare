import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../../domain/models/profile.dart';
import '../../domain/usecases/all_profile_usecases.dart';
import '../edit_profile_screen.dart';
import '../../../widgets/item_widget.dart';

class ProfileJobSummaryWidget extends StatelessWidget {
  final Profile profile;
  const ProfileJobSummaryWidget({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(6),
      decoration: Style.boxDecoration,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              itemWidget(
                title: 'First Name',
                content: profile.firstName!,
              ),
              itemWidget(
                title: 'Last Name',
                content: profile.lastName!,
              ),
              itemWidget(
                title: 'Display Name',
                content: profile.displayName!,
              ),

              itemWidget(
                title: 'Task Types',
                content: profile.taskTypes!,
              ),

              itemWidget(
                title: 'authId',
                content: profile.authId!,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfileScreen(
                              profile: profile,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AllProfileUseCases.removeAProfile(profile.id!);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),


                  ],
                ),
              ),

            ],
          ),



        ],
      ),
    );
  }
}
