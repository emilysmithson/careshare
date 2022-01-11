import 'package:flutter/material.dart';

import '../domain/models/category.dart';
import '../domain/usecases/all_category_usecases.dart';
import 'category_entered_screen.dart';


class CreateCategoryController {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController detailsController;

  initialiseControllers() {
    nameController = TextEditingController();
    detailsController = TextEditingController();
  }

  createCategory({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      final Category category = Category(
        name: nameController.text,
        details: detailsController.text,
        dateCreated: DateTime.now(),
      );

      final response = await AllCategoryUseCases.createACategory(category);
      response.fold((l) => null, (r) => category.id = r);
      // myProfileId = category.id!;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryEnteredScreen(category: category),
        ),
      );
    }
  }
}
