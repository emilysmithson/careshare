import 'dart:io';

import 'package:careshare/caregroup_manager/cubit/caregroup_cubit.dart';
import 'package:careshare/caregroup_manager/models/caregroup.dart';

import 'package:careshare/caregroup_manager/presenter/caregroup_widgets/caregroup_input_field_widget.dart';

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
    return Scaffold(
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
                          .editCaregroupFieldRepository(
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
                          .editCaregroupFieldRepository(
                        caregroupField: CaregroupField.name,
                        caregroup: caregroup,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
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
