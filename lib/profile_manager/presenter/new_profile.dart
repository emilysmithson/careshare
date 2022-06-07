import 'dart:io';

import 'package:careshare/home_page/home_page.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_input_field_widget.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/upload_profile_photo.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewProfile extends StatefulWidget {
  static const routeName = '/new-profile';

  const NewProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<NewProfile> createState() => _NewProfileState();
}

class _NewProfileState extends State<NewProfile> {
  int _index = 0;
  int _selectedAvatar = -1;

  @override
  Widget build(BuildContext context) {
    const double spacing = 16;

    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;

    List<Widget> _avatars = [];
    List<Avatar> _avatarList = Avatar.avatarList;
    for (var i = 0; i < _avatarList.length; i++) {
      _avatars.add(
        GestureDetector(
          onTap: () {
            BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
              profileField: ProfileField.photoUrl,
              profile: myProfile,
              newValue: Avatar.avatarList[i].url,
            );

            setState(() {
              _selectedAvatar = i;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                border: Border.all(color: (_selectedAvatar == i) ? Colors.blue : Colors.white, width: 5),
                shape: BoxShape.circle,
              ),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage(Avatar.avatarList[i].url, scale: 0.60), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Careshare!'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stepper(
          type: StepperType.vertical,
          // controlsBuilder: (BuildContext context, ControlsDetails details) {
          //   return Row(
          //     children: <Widget>[
          //       OutlinedButton(
          //         onPressed: details.onStepContinue,
          //         child: Text('NEXT $_index'),
          //       ),
          //       OutlinedButton(
          //         onPressed: details.onStepCancel,
          //         child: const Text('BACK'),
          //       ),
          //     ],
          //   );
          // },
          currentStep: _index,
          onStepCancel: () {
            print("onStepCancel _index: $_index");
            // if (_index > 0) {
            //   setState(() {
            //     _index -= 1;
            //   });
            // }
          },
          onStepContinue: () {
            print("onStepContinue _index: $_index");
            //
            if (_index == 2) {
              print("onStepContinue _index: $_index");

              //mark setup as complete and navigate to the home page
              BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
                profileField: ProfileField.setupComplete,
                profile: myProfile,
                newValue: true,
              );

              Navigator.pushReplacementNamed(
                context,
                HomePage.routeName,
              );
            } else {
              setState(() {
                _index = _index + 1;
              });
            }
          },
          onStepTapped: (int index) {
            print("onStepTapped _index: $_index");

            // setState(() {
            //   _index = index;
            // });
          },
          steps: [
            Step(
              //Step 0
              title: const Text("Let's get started..."),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 18.0),
                    child: const Text('Please tell us a bit about yourself:',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                  ),
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
                    currentValue: (_selectedAvatar != -1) ? Avatar.avatarList[_selectedAvatar].url : myProfile.lastName,
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
                ],
              ),
            ),
            Step(
              //Step 1
              title: const Text("Show us your good side..."),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 18.0),
                    child: const Text('Lights, camera, action...',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                  ),
                  UploadProfilePhotoWidget(
                    imagePickFn: (File photo) {
                      BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
                        profileField: ProfileField.photo,
                        profile: myProfile,
                        newValue: photo,
                      );
                    },
                    currentPhotoUrl: myProfile.photo,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "\u{00A0}" * 20,
                        style: new TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(" or "),
                      Text(
                        "\u{00A0}" * 20,
                        style: new TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 18.0),
                    child: const Text("If your hair isn't quite right, choose from one of our flattering avatars:",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    children: _avatars.toList(),
                  )
                ],
              ),
            ),
            // Step(
            //   title: const Text("Tell us how you can help..."),
            //   content: Container(alignment: Alignment.centerLeft, child: const Text('What are you great at?')),
            // ),
            Step(
              //Step 2
              title: const Text("All done!"),
              content: Container(
                alignment: Alignment.centerLeft,
                child: const Text("Let's find out where you can help"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
