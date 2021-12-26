import 'package:flutter/material.dart';

import '../../widgets/custom_form_field.dart';
import '../domain/models/profile.dart';
import 'create_or_edit_profile_controller.dart';

class CreateOrEditAProfileScreen extends StatefulWidget {
  final Profile? profile;
  const CreateOrEditAProfileScreen({
    Key? key,
    this.profile,
  }) : super(key: key);

  @override
  State<CreateOrEditAProfileScreen> createState() =>
      _CreateOrEditAProfileScreenState();
}

class _CreateOrEditAProfileScreenState extends State<CreateOrEditAProfileScreen> {
  late CreateOrEditAProfileController controller = CreateOrEditAProfileController();
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
      appBar: AppBar(
        title:
        Text(controller.isCreateProfile ? 'Create a New Profile' : 'Edit a Profile'),
      ),
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
                      controller.createAProfile(
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
