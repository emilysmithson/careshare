import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/edit_profile.dart';
import 'package:careshare/widgets/careshare_appbar.dart';
import 'package:careshare/widgets/careshare_drawer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewProfile extends StatelessWidget {
  final Profile profile;

  const ViewProfile({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const double spacing = 16;
    return Scaffold(
      appBar: CareshareAppBar('Profile Details'),
      endDrawer: CareshareDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text('Name',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(profile.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text('First Name',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(profile.firstName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text('Last Name',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(profile.lastName,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Expanded(
                        flex: 4,
                        child: Text('Email',
                            style: TextStyle(fontWeight: FontWeight.normal)),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(profile.email,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<ProfileCubit>(context),
                                child: EditProfile(
                                  profile:
                                      BlocProvider.of<ProfileCubit>(context)
                                          .fetchMyProfile(),
                                ),
                              ),
                            ));
                          },
                          child: const Text('Edit')),
                    ],
                  ),
                ],
              );

              //   Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(profile.name,
              //         style: const TextStyle(fontWeight: FontWeight.bold)),
              //
              //     const SizedBox(height: spacing),
              //     ProfileInputFieldWidget(
              //       label: 'First Name',
              //       maxLines: 1,
              //       currentValue: profile.firstName,
              //       profile: profile,
              //       onChanged: (value) {
              //         BlocProvider.of<ProfileCubit>(context)
              //             .editProfileFieldRepository(
              //           profileField: ProfileField.firstName,
              //           profile: profile,
              //           newValue: value,
              //         );
              //       },
              //     ),
              //     const SizedBox(height: spacing),
              //     ProfileInputFieldWidget(
              //       label: 'Last Name',
              //       maxLines: 1,
              //       currentValue: profile.lastName,
              //       profile: profile,
              //       onChanged: (value) {
              //         BlocProvider.of<ProfileCubit>(context)
              //             .editProfileFieldRepository(
              //           profileField: ProfileField.lastName,
              //           profile: profile,
              //           newValue: value,
              //         );
              //       },
              //     ),
              //
              //     const SizedBox(height: spacing),
              //     ProfileInputFieldWidget(
              //       label: 'Email',
              //       maxLines: 1,
              //       currentValue: profile.email,
              //       profile: profile,
              //       onChanged: (value) {
              //         BlocProvider.of<ProfileCubit>(context)
              //             .editProfileFieldRepository(
              //           profileField: ProfileField.email,
              //           profile: profile,
              //           newValue: value,
              //         );
              //       },
              //
              //     ),
              //
              //
              //     const SizedBox(height: spacing),
              //     Row(
              //       children: [
              //         ElevatedButton(
              //             onPressed: () {
              //               Navigator.pop(context);
              //             },
              //             child: const Text('Save')),
              //       ],
              //     ),
              //   ],
              // );
            },
          ),
        ),
      ),
    );
  }
}
