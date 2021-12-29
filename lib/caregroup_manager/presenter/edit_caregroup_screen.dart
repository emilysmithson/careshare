import 'package:flutter/material.dart';

import '../../widgets/custom_form_field.dart';
import '../domain/models/caregroup.dart';
import 'edit_caregroup_controller.dart';

class CreateOrEditACaregroupScreen extends StatefulWidget {
  final Caregroup? caregroup;
  const CreateOrEditACaregroupScreen({
    Key? key,
    this.caregroup,
  }) : super(key: key);

  @override
  State<CreateOrEditACaregroupScreen> createState() =>
      _CreateOrEditACaregroupScreenState();
}

class _CreateOrEditACaregroupScreenState extends State<CreateOrEditACaregroupScreen> {
  late CreateOrEditACaregroupController controller = CreateOrEditACaregroupController();
  bool showCaregroupTypeError = false;

  @override
  void initState() {
    controller.initialiseControllers(widget.caregroup);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title:
        Text(controller.isCreateCaregroup ? 'Create a New Caregroup' : 'Edit a Caregroup'),
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomFormField(
                    controller: controller.nameController,
                    label: 'Name',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Name';
                      }
                      return null;
                    },
                  ),

                  CustomFormField(
                    controller: controller.detailsController,
                    label: 'details',
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a details';
                      }
                      return null;
                    },
                  ),

                  CustomFormField(
                    controller: controller.careesController,
                    label: 'Carees',
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
                      controller.createACaregroup(
                        context: context,
                      );
                    },
                    child: Text(
                      controller.isCreateCaregroup ? 'Create' : 'Save changes',
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
