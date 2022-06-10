import 'dart:async';

import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';

import 'package:careshare/profile_manager/presenter/profile_widgets/profile_input_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'profile_widgets/edit_profile_photo_widget.dart';
import 'package:intl/intl.dart';

class EditMyProfile extends StatefulWidget {
  static const routeName = '/edit-my-profile';

  const EditMyProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<EditMyProfile> createState() => _EditMyProfileState();
}

class _EditMyProfileState extends State<EditMyProfile> {

  Timer? _debounce;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();



  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    const double spacing = 16;


    return BlocBuilder<MyProfileCubit, MyProfileState>(builder: (context, state) {
      if (state is MyProfileLoaded) {
        Profile myProfile = state.myProfile!;

        emailController.text = myProfile.email;

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: BlocBuilder<MyProfileCubit, MyProfileState>(
                builder: (context, state) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    child: Column(
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
                            BlocProvider.of<MyProfileCubit>(context).editMyProfile(
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
                            BlocProvider.of<MyProfileCubit>(context).editMyProfile(
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
                            BlocProvider.of<MyProfileCubit>(context).editMyProfile(
                              profileField: ProfileField.phoneCountry,
                              profile: myProfile,
                              newValue: value.countryISOCode,
                            );

                            BlocProvider.of<MyProfileCubit>(context).editMyProfile(
                              profileField: ProfileField.phoneCountryCode,
                              profile: myProfile,
                              newValue: value.countryCode,
                            );

                            BlocProvider.of<MyProfileCubit>(context).editMyProfile(
                              profileField: ProfileField.phoneNumber,
                              profile: myProfile,
                              newValue: value.number,
                            );
                          },
                        ),
                        const SizedBox(height: spacing),

                        TextFormField(
                          controller: emailController,
                          maxLines: 1,
                          onChanged: (value) async {
                            if (_debounce?.isActive ?? false) _debounce?.cancel();
                            _debounce = Timer(const Duration(milliseconds: 500), () {

                              // is email valid?
                              if (value != "" && RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[-a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                                BlocProvider.of<MyProfileCubit>(context).editMyProfile(
                                  profileField: ProfileField.email,
                                  profile: myProfile,
                                  newValue: value,
                                );
                              }

                            });
                          },
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email),
                            disabledBorder: (OutlineInputBorder(borderSide: BorderSide(color: Colors.black38))),
                            label: Text('Email'),
                            // errorText: "Please enter a valid email address",
                          ),
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter your Email address';
                            }
                            bool emailValid =
                                RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[-a-zA-Z0-9]+\.[a-zA-Z]+")
                                    // r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                            if (!emailValid) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),


                        const SizedBox(height: spacing),
                        TextFormField(
                          initialValue: DateFormat('E d MMM yyyy').format(myProfile.dateOfBirth!),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your date of birth';
                            }
                            return null;
                          },
                          // style: widget.textStyle,
                          maxLines: 1,

                          onChanged: (value) async {
                            BlocProvider.of<MyProfileCubit>(context).editMyProfile(
                              profileField: ProfileField.dateOfBirth,
                              profile: myProfile,
                              newValue: value,
                            );
                          },

                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            disabledBorder: (OutlineInputBorder(borderSide: BorderSide(color: Colors.black38))),
                            label: Text('Date Of Birth'),
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );

                            if (pickedDate != null) {
                              BlocProvider.of<MyProfileCubit>(context).editMyProfile(
                                profileField: ProfileField.dateOfBirth,
                                profile: myProfile,
                                newValue: pickedDate,
                              );
                            } else {
                              print("Date is not selected");
                            }
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
                    ),
                  );
                },
              ),
            ),
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
