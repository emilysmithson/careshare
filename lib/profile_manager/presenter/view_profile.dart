import 'package:careshare/profile_manager/cubit/profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/profile_manager/presenter/profile_widgets/profile_input_field_widget.dart';
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
    const double spacing = 16;
    return Scaffold(
      appBar: CareshareAppBar('Profile Details'),
      endDrawer: CareshareDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return GridView.count(crossAxisCount: 2,
                shrinkWrap: true,
                  childAspectRatio: 4,
                children: [
                  Text('Name',
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                  Text(profile.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),

                  Text('First name',
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                  Text(profile.firstName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),

                  Text('Last name',
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                  Text(profile.lastName,
                      style: const TextStyle(fontWeight: FontWeight.bold)),

                  Text('Email',
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                  Text(profile.email,
                      style: const TextStyle(fontWeight: FontWeight.bold)),

                  Text('id',
                      style: const TextStyle(fontWeight: FontWeight.normal)),
                  Text(profile.id!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),




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
