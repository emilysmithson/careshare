import 'dart:io';

import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePhotoWidget extends StatefulWidget {
  final double? size;
  final Profile profile;

  const EditProfilePhotoWidget({Key? key, required this.profile, this.size}) : super(key: key);

  @override
  State<EditProfilePhotoWidget> createState() => _EditProfilePhotoWidgetState();
}

class _EditProfilePhotoWidgetState extends State<EditProfilePhotoWidget> {
  File? _pickedImage;
  int _selectedAvatar = -1;
  List<Widget> _avatars = [];

  void _chooseProfilePhoto() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(6.0) ,
            title: const Text(
              'Where would like you to fetch your photo from?',
            ),
            actionsAlignment: MainAxisAlignment.center,
            content: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _photoSourceChoiceWidget(
                      pickImage: _pickImage,
                      fromGallery: false,
                      icon: Icons.photo_camera,
                      context: context,
                    ),
                    _photoSourceChoiceWidget(
                      pickImage: _pickImage,
                      fromGallery: true,
                      icon: Icons.photo_library,
                      context: context,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "\u{00A0}" * 20,
                      style: new TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const Text(" or "),
                    Text(
                      "\u{00A0}" * 20,
                      style: new TextStyle(
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                  child: Text("If your hair isn't quite right, choose from one of our flattering avatars:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.blue)),
                ),
                const SizedBox(height: 10),
                Wrap(
                  children: _avatars.toList(),
                ),
              ],
            ),
          );
        });
  }

  void _pickImage(bool fromGallery) async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
      maxWidth: 1024,
      maxHeight: 1024,
    );
    setState(() {
      if (pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);

          BlocProvider.of<MyProfileCubit>(context)
              .editMyProfile(
            profileField: ProfileField.photo,
            profile: widget.profile,
            newValue: _pickedImage,
          );

      }
    });

    // widget.imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    final photoURL = widget.profile.photo;

    if (_avatars.isEmpty) {
      List<Avatar> _avatarList = Avatar.avatarList;
      for (var i = 0; i < _avatarList.length; i++) {
        _avatars.add(
          GestureDetector(
            onTap: () {
              // BlocProvider.of<MyProfileCubit>(context).editProfileFieldRepository(
              //   profileField: ProfileField.photoUrl,
              //   profile: widget.profile,
              //   newValue: Avatar.avatarList[i].url,
              // );

              BlocProvider.of<MyProfileCubit>(context).editMyProfile(
                  profile: widget.profile, profileField: ProfileField.photoUrl, newValue: Avatar.avatarList[i].url);

              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: NetworkImage(Avatar.avatarList[i].url, scale: 0.60), fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        );
      }
    }

    return BlocBuilder<MyProfileCubit, MyProfileState>(builder: (context, state) {
      if (state is MyProfileLoaded) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _chooseProfilePhoto();
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: widget.size ?? 40,
                    width: widget.size ?? 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: NetworkImage(photoURL), fit: BoxFit.cover),
                    ),
                  ),
                  const Positioned(
                    bottom: 10,
                    right: 5,
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.blueGrey,
                      size: 40,
                    ),
                  ),
                  const Positioned(
                    bottom: 10,
                    right: 5,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white70,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return Container();
      }
    });
  }
}

_photoSourceChoiceWidget({
  required Function pickImage,
  required bool fromGallery,
  required IconData icon,
  required BuildContext context,
}) {
  return InkWell(
    onTap: () {
      pickImage(fromGallery);
      Navigator.pop(context);
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 40,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(fromGallery ? 'Gallery' : 'Take Photo')
      ],
    ),
  );
}
