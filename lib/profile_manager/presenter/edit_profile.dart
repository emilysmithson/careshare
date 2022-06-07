import 'dart:io';

import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/profile_manager/presenter/profile_widgets/profile_input_field_widget.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/upload_profile_photo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class EditProfile extends StatelessWidget {
  static const routeName = '/edit-profile';
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
          child: BlocBuilder<MyProfileCubit, MyProfileState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UploadProfilePhotoWidget(
                    imagePickFn: (File photo) {
                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.photo,
                        profile: profile,
                        newValue: photo,
                      );
                    },
                    currentPhotoUrl: profile.photo,
                  ),
                  const SizedBox(height: spacing),
                  ProfileInputFieldWidget(
                    label: 'First Name',
                    maxLines: 1,
                    currentValue: profile.firstName,
                    profile: profile,
                    onChanged: (value) {
                      BlocProvider.of<MyProfileCubit>(context)
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
                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.lastName,
                        profile: profile,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),


                  IntlPhoneField(
                    initialCountryCode: (profile.phoneCountry!="") ? profile.phoneCountry : "GB",
                    initialValue: profile.phoneNumber,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    onChanged: (value) {
                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.phoneCountry,
                        profile: profile,
                        newValue: value.countryISOCode,
                      );

                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.phoneCountryCode,
                        profile: profile,
                        newValue: value.countryCode,
                      );

                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.phoneNumber,
                        profile: profile,
                        newValue: value.number,
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
                      BlocProvider.of<MyProfileCubit>(context)
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
