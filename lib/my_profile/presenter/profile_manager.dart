import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_summary.dart';
import 'package:careshare/templates/page_scaffold.dart';
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
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        if (state is ProfilesLoaded) {
          return PageScaffold(
            body: SingleChildScrollView(
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
          );
        }
        // print('show circular progress indicator C3');
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
