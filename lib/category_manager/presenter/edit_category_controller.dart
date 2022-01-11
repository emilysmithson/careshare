import 'package:flutter/material.dart';

import '../domain/models/category.dart';
import '../domain/usecases/all_category_usecases.dart';
import 'category_entered_screen.dart';

class CreateOrEditACategoryController {
  final formKey = GlobalKey<FormState>();
  bool isCreateCategory = true;
  Category? storedCategory;

  late TextEditingController nameController;
  late TextEditingController detailsController;

  initialiseControllers(Category? originalCategory) {
    if (originalCategory != null) {
      storedCategory = originalCategory;
      isCreateCategory = false;
    }
    nameController = TextEditingController(
      text: originalCategory?.name,
    );
    detailsController = TextEditingController(
      text: originalCategory?.details,
    );
  }

  createACategory({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      final Category category = storedCategory!;
      category.name = nameController.text;
      category.details = detailsController.text;
      category.dateCreated = DateTime.now();

      if (isCreateCategory) {
        final response = await AllCategoryUseCases.createACategory(category);
        response.fold((l) => null, (r) => category.id = r);
      } else {
        AllCategoryUseCases.editACategory(category);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CategoryEnteredScreen(category: category),
        ),
      );
    }
  }
}
