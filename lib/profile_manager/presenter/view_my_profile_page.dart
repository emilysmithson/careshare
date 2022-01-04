import 'package:careshare/profile_manager/presenter/view_my_profile_controller.dart';
import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import '../../widgets/upload_photo/upload_photo_widget.dart';

class ViewMyProfilePage extends StatefulWidget {
  const ViewMyProfilePage({Key? key}) : super(key: key);

  @override
  _ViewMyProfilePageState createState() => _ViewMyProfilePageState();
}

class _ViewMyProfilePageState extends State<ViewMyProfilePage> {
  final controller = ViewMyProfileController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('My Profile'),
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
