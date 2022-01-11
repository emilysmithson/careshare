import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_form_field.dart';
import '../domain/models/category.dart';
import 'edit_category_controller.dart';

class CreateOrEditACategoriescreen extends StatefulWidget {
  final Category? category;
  const CreateOrEditACategoriescreen({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  State<CreateOrEditACategoriescreen> createState() =>
      _CreateOrEditACategoriescreenState();
}

class _CreateOrEditACategoriescreenState extends State<CreateOrEditACategoriescreen> {
  late CreateOrEditACategoryController controller = CreateOrEditACategoryController();
  bool showCategoryTypeError = false;

  @override
  void initState() {
    controller.initialiseControllers(widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(controller.isCreateCategory ? 'Create a New Category' : 'Edit a Category'),
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
                    controller.createACategory(
                      context: context,
                    );
                  },
                  child: Text(
                    controller.isCreateCategory ? 'Create' : 'Save changes',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
