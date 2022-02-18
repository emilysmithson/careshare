import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSummary extends StatelessWidget {
  static const String routeName = "/profile-summary";
  final Profile profile;

  const ProfileSummary({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          EditProfile.routeName,
          arguments: profile,
        );
      },
      child: Container(
        width: 190,
        height: 250,
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfilePhotoWidget(id: profile.id!, size: 80),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(profile.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Text('First name: ${profile.firstName}'),
                      Text('Last name: ${profile.lastName}'),
                      Text('e-mail: ${profile.email}'),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }
}
