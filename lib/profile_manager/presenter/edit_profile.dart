import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/profile_manager/presenter/profile_widgets/profile_input_field_widget.dart';
import 'package:careshare/profile_manager/presenter/view_profile.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatelessWidget {
  final Profile profile;

  const EditProfile({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double spacing = 16;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: spacing),
                  ProfileInputFieldWidget(
                    label: 'Name',
                    maxLines: 1,
                    currentValue: profile.name,
                    profile: profile,
                    onChanged: (value) {
                      BlocProvider.of<ProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.name,
                        profile: profile,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  ProfileInputFieldWidget(
                    label: 'First Name',
                    maxLines: 1,
                    currentValue: profile.firstName,
                    profile: profile,
                    onChanged: (value) {
                      BlocProvider.of<ProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.firstName,
                        profile: profile,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  ProfileInputFieldWidget(
                    label: 'Last Name',
                    maxLines: 1,
                    currentValue: profile.lastName,
                    profile: profile,
                    onChanged: (value) {
                      BlocProvider.of<ProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.lastName,
                        profile: profile,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  ProfileInputFieldWidget(
                    label: 'Email',
                    maxLines: 1,
                    currentValue: profile.email,
                    profile: profile,
                    onChanged: (value) {
                      BlocProvider.of<ProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.email,
                        profile: profile,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<ProfileCubit>(context),
                                child: ViewProfile(
                                  profile:
                                      BlocProvider.of<ProfileCubit>(context)
                                          .myProfile,
                                ),
                              ),
                            ));
                          },
                          child: const Text('Save')),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
