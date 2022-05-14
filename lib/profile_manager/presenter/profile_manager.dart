import 'package:careshare/profile_manager/cubit/all_profiles_cubit.dart';

import 'package:careshare/profile_manager/presenter/profile_widgets/profile_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Called from the menu bar
class ProfilesManager extends StatelessWidget {
  static const String routeName = "/profiles-manager";
  const ProfilesManager({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllProfilesCubit, AllProfilesState>(
      builder: (context, state) {
        if (state is AllProfilesLoaded) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profiles Manager'),
              actions: const [],
            ),body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  child: Wrap(
                  children: state.profileList
                      .map(
                        (profile) => ProfileSummary(
                          profile: profile,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        }
        // print('show circular progress indicator C3');
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
