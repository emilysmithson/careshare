import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_form_field.dart';
import '../domain/models/profile.dart';
import 'edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  final Profile? profile;
  const EditProfileScreen({
    Key? key,
    this.profile,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late EditProfileController controller = EditProfileController();
  bool showProfileTypeError = false;

  @override
  void initState() {
    controller.initialiseControllers(widget.profile);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(controller.isCreateProfile ? 'Create a New Profile' : 'Edit a Profile'),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: Center(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomFormField(
                    controller: controller.firstNameController,
                    label: 'First Name',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a First Name';
                      }
                      return null;
                    },
                  ),

                  CustomFormField(
                    controller: controller.lastNameController,
                    label: 'Last Name',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Last Name';
                      }
                      return null;
                    },
                  ),
                  CustomFormField(
                    controller: controller.displayNameController,
                    label: 'Display Name',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Display Name';
                      }
                      return null;
                    },
                  ),

                  CustomFormField(
                    controller: controller.taskTypesController,
                    label: 'Task Types',
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter at least one Task Type';
                      }
                      return null;
                    },
                  ),

                  TextButton(
                    onPressed: () {
                      controller.formKey.currentState?.validate();
                      controller.createProfile(
                        context: context,
                      );
                    },
                    child: Text(
                      controller.isCreateProfile ? 'Create' : 'Save changes',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
