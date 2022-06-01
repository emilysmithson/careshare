import 'dart:io';

import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/profile_manager/presenter/profile_widgets/profile_input_field_widget.dart';
import 'package:careshare/widgets/upload_profile_photo.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class EditMyProfile extends StatelessWidget {
  static const routeName = '/edit-my-profile';

  const EditMyProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double spacing = 16;

    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
                        profile: myProfile,
                        newValue: photo,
                      );
                    },
                    currentPhotoUrl: myProfile.photo,
                  ),
                  const SizedBox(height: spacing),
                  ProfileInputFieldWidget(
                    label: 'Username',
                    maxLines: 1,
                    currentValue: myProfile.name,
                    profile: myProfile,
                    onChanged: (value) {
                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.name,
                        profile: myProfile,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  ProfileInputFieldWidget(
                    label: 'First Name',
                    maxLines: 1,
                    currentValue: myProfile.firstName,
                    profile: myProfile,
                    onChanged: (value) {
                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.firstName,
                        profile: myProfile,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),
                  ProfileInputFieldWidget(
                    label: 'Last Name',
                    maxLines: 1,
                    currentValue: myProfile.lastName,
                    profile: myProfile,
                    onChanged: (value) {
                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.lastName,
                        profile: myProfile,
                        newValue: value,
                      );
                    },
                  ),
                  const SizedBox(height: spacing),


                  IntlPhoneField(
                    initialCountryCode: (myProfile.phoneCountryCode!="") ? myProfile.phoneCountryCode : "GB",
                    initialValue: myProfile.phoneNumber,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    onChanged: (value) {
                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.phoneCountry,
                        profile: myProfile,
                        newValue: value.countryISOCode,
                      );

                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.phoneCountryCode,
                        profile: myProfile,
                        newValue: value.countryCode,
                      );

                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.phoneNumber,
                        profile: myProfile,
                        newValue: value.number,
                      );
                    },
                  ),

                  const SizedBox(height: spacing),
                  ProfileInputFieldWidget(
                    label: 'Email',
                    maxLines: 1,
                    currentValue: myProfile.email,
                    profile: myProfile,
                    onChanged: (value) {
                      BlocProvider.of<MyProfileCubit>(context)
                          .editProfileFieldRepository(
                        profileField: ProfileField.email,
                        profile: myProfile,
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
