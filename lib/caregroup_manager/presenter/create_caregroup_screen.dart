import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_form_field.dart';
import '../domain/models/caregroup.dart';
import 'create_caregroup_controller.dart';

class CreateCaregroupScreen extends StatefulWidget {
  final Caregroup? caregroup;
  const CreateCaregroupScreen({
    Key? key,
    this.caregroup,
  }) : super(key: key);

  @override
  State<CreateCaregroupScreen> createState() =>
      _CreateCaregroupScreenState();
}

class _CreateCaregroupScreenState extends State<CreateCaregroupScreen> {
  late CreateCaregroupController controller = CreateCaregroupController();
  bool showCaregroupTypeError = false;

  @override
  void initState() {
    controller.initialiseControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar('Create A New Caregroup'),
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
                      controller.createCaregroup(
                        context: context,
                      );
                    },
                    child: Text('Create'),
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
