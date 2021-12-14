import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoWidget extends StatefulWidget {
  UploadPhotoWidget({Key? key}) : super(key: key);

  @override
  _UploadPhotoWidgetState createState() => _UploadPhotoWidgetState();
}

class _UploadPhotoWidgetState extends State<UploadPhotoWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.photo_camera),
      onPressed: () async {
        final ImagePicker _picker = ImagePicker();
        final XFile? photo =
            await _picker.pickImage(source: ImageSource.camera);
      },
    );
  }
}
