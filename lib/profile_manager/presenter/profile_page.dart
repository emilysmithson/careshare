import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_controller.dart';
import 'package:careshare/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import '../../widgets/upload_photo/upload_photo_widget.dart';
import '../domain/usecases/all_profile_usecases.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final controller = ProfileController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Column(
        children: [
          CustomFormField(
            label: 'Name',
            validator: (String? text) {
              if (text == null) {
                return 'You must enter your name';
              }
              return null;
            },
          ),
          UploadPhotoWidget(),
        ],
      ),
    );
  }
}
