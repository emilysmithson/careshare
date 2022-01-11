import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_form_field.dart';
import '../domain/models/category.dart';
import 'create_category_controller.dart';

class CreateCategoryScreen extends StatefulWidget {
  final Category? category;
  const CreateCategoryScreen({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  State<CreateCategoryScreen> createState() =>
      _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  late CreateCategoryController controller = CreateCategoryController();
  bool showCategoryTypeError = false;

  @override
  void initState() {
    controller.initialiseControllers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar('Create A New Category'),
      endDrawer: CustomDrawer(),
      body: SafeArea(
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

                TextButton(
                  onPressed: () {
                    controller.formKey.currentState?.validate();
                    controller.createCategory(
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
    );
  }
}
