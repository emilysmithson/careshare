import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilesOverview extends StatelessWidget {
  const ProfilesOverview({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return SingleChildScrollView(
            child: Wrap(
              children: state.profileList
                  .map(
                    (profile) => ProfileSummary(
                      profile: profile,
                    ),
                  )
                  .toList(),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
