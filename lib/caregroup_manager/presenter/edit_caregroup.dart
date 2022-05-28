import 'dart:io';

import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/caregroup_manager/models/caregroup_status.dart';

import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_input_field_widget.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'caregroup_widgets/upload_caregroup_photo.dart';

class EditCaregroup extends StatelessWidget {
  static const routeName = '/edit-caregroup';
  final Caregroup caregroup;

  const EditCaregroup({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double spacing = 16;

    // print(caregroup.status.status);
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (caregroup.status == CaregroupStatus.draft)
            ElevatedButton(
                onPressed: () {
                  BlocProvider.of<CaregroupCubit>(context)
                      .removeCaregroup(caregroup.id);
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
          if (caregroup.status == CaregroupStatus.draft)
            const SizedBox(width: spacing),
          if (caregroup.status == CaregroupStatus.draft)
            ElevatedButton(
                onPressed: () {
                  BlocProvider.of<CaregroupCubit>(context)
                      .editCaregroup(
                    caregroupField: CaregroupField.status,
                    caregroup: caregroup,
                    newValue: CaregroupStatus.active,
                  );

                  // add me as a carer in the caregroup
                  BlocProvider.of<MyProfileCubit>(context)
                      .addCarerInCaregroupToProfile(
                          caregroupId: caregroup.id,
                          profileId: BlocProvider.of<MyProfileCubit>(context)
                              .myProfile
                              .id);

                  Navigator.pop(context);
                },
                child: const Text('Create')),
          if (caregroup.status == CaregroupStatus.draft)
            const SizedBox(width: spacing),
          if (caregroup.status != CaregroupStatus.draft)
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save')),
        ],
      ),
      appBar: AppBar(
        title: const Text('Caregroup Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: BlocBuilder<CaregroupCubit, CaregroupState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UploadCaregroupPhotoWidget(
                    imagePickFn: (File photo) {
                      BlocProvider.of<CaregroupCubit>(context)
                          .editCaregroup(
                        caregroupField: CaregroupField.photo,
                        caregroup: caregroup,
                        newValue: photo,
                      );
                    },
                    currentPhotoUrl: caregroup.photo,
                  ),
                  const SizedBox(height: spacing),
                  CaregroupInputFieldWidget(
                    label: 'Name',
                    maxLines: 1,
                    currentValue: caregroup.name,
                    caregroup: caregroup,
                    onChanged: (value) {
                      BlocProvider.of<CaregroupCubit>(context)
                          .editCaregroup(
                        caregroupField: CaregroupField.name,
                        caregroup: caregroup,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  CaregroupInputFieldWidget(
                    label: 'Details',
                    maxLines: 6,
                    currentValue: caregroup.details,
                    caregroup: caregroup,
                    onChanged: (value) {
                      BlocProvider.of<CaregroupCubit>(context)
                          .editCaregroup(
                        caregroupField: CaregroupField.details,
                        caregroup: caregroup,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
