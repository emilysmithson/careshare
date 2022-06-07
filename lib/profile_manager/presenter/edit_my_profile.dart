import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/profile_manager/presenter/profile_widgets/profile_input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'profile_widgets/edit_profile_photo_widget.dart';

class EditMyProfile extends StatefulWidget {
  static const routeName = '/edit-my-profile';

  const EditMyProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<EditMyProfile> createState() => _EditMyProfileState();
}

class _EditMyProfileState extends State<EditMyProfile> {
  @override
  Widget build(BuildContext context) {
    const double spacing = 16;

    return BlocBuilder<MyProfileCubit, MyProfileState>(builder: (context, state) {
      if (state is MyProfileLoaded) {
        Profile myProfile = state.myProfile!;

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
                      EditProfilePhotoWidget(
                        profile: myProfile,
                        size: 140.0,
                      ),
                      const SizedBox(height: spacing),
                      ProfileInputFieldWidget(
                        label: 'First Name',
                        maxLines: 1,
                        currentValue: myProfile.firstName,
                        profile: myProfile,
                        onChanged: (value) {
                          BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
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
                          BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
                            profileField: ProfileField.lastName,
                            profile: myProfile,
                            newValue: value,
                          );
                        },
                      ),
                      const SizedBox(height: spacing),
                      IntlPhoneField(
                        initialCountryCode: (myProfile.phoneCountry != "") ? myProfile.phoneCountry : "GB",
                        initialValue: myProfile.phoneNumber,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        onChanged: (value) {
                          BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
                            profileField: ProfileField.phoneCountry,
                            profile: myProfile,
                            newValue: value.countryISOCode,
                          );

                          BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
                            profileField: ProfileField.phoneCountryCode,
                            profile: myProfile,
                            newValue: value.countryCode,
                          );

                          BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
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
                          BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
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
      else {
        return Container(
          child: Text("profile loading"),
        );
      }
    });

  }
}
