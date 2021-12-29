import 'package:careshare/caregroup_manager/presenter/view_my_caregroup_controller.dart';
import 'package:careshare/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import '../../widgets/upload_photo/upload_photo_widget.dart';

class ViewMyCaregroupPage extends StatefulWidget {
  const ViewMyCaregroupPage({Key? key}) : super(key: key);

  @override
  _ViewMyCaregroupPageState createState() => _ViewMyCaregroupPageState();
}

class _ViewMyCaregroupPageState extends State<ViewMyCaregroupPage> {
  final controller = ViewMyCaregroupController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Caregroup'),
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
