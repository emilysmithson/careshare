import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadProfilePhotoWidget extends StatefulWidget {
  final void Function(File imageUrl) imagePickFn;
  final String? currentPhotoUrl;
  const UploadProfilePhotoWidget({
    Key? key,
    required this.imagePickFn,
    this.currentPhotoUrl,
  }) : super(key: key);

  @override
  State<UploadProfilePhotoWidget> createState() =>
      _UploadProfilePhotoWidgetState();
}

class _UploadProfilePhotoWidgetState extends State<UploadProfilePhotoWidget> {
  File? _pickedImage;

  void _choosePhotoUploadType() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Where would like you to fetch your photo from?',
            ),
            actionsAlignment: MainAxisAlignment.center,
            content: Row(
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
          );
        });
  }

  void _pickImage(bool fromGallery) async {
    final imagePicker = ImagePicker();
    final pickedImageFile = await imagePicker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
      maxHeight: 150,
    );
    setState(() {
      if (pickedImageFile != null) {
        _pickedImage = File(pickedImageFile.path);
      }
    });

    widget.imagePickFn(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? currentImage;

    if (widget.currentPhotoUrl != null) {
      currentImage = NetworkImage(widget.currentPhotoUrl!);
    }
    if (_pickedImage != null) {
      currentImage = FileImage(_pickedImage!);
    }

    return SizedBox(
      width: double.infinity,
      child: Center(
        child: GestureDetector(
          onTap: () {
            _choosePhotoUploadType();
          },
          child: CircleAvatar(
              radius: 40,
              child: currentImage == null
                  ? const Icon(
                      Icons.person_add,
                      size: 40,
                    )
                  : Container(),
              backgroundImage: currentImage),
        ),
      ),
    );
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
