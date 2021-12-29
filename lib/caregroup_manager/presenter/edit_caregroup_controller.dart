import 'package:flutter/material.dart';

import '../domain/models/caregroup.dart';
import '../domain/usecases/all_caregroup_usecases.dart';
import 'caregroup_entered_screen.dart';

class CreateOrEditACaregroupController {
  final formKey = GlobalKey<FormState>();
  bool isCreateCaregroup = true;
  Caregroup? storedCaregroup;

  late TextEditingController nameController;
  late TextEditingController detailsController;
  late TextEditingController careesController;

  initialiseControllers(Caregroup? originalCaregroup) {
    if (originalCaregroup != null) {
      storedCaregroup = originalCaregroup;
      isCreateCaregroup = false;
    }
    nameController = TextEditingController(
      text: originalCaregroup?.name,
    );
    detailsController = TextEditingController(
      text: originalCaregroup?.details,
    );
    careesController = TextEditingController(
      text: originalCaregroup?.carees,
    );
  }

  createACaregroup({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      final Caregroup caregroup = storedCaregroup!;
      caregroup.name = nameController.text;
      caregroup.details = detailsController.text;
      caregroup.dateCreated = DateTime.now();
      caregroup.carees = careesController.text;

      if (isCreateCaregroup) {
        final response = await AllCaregroupUseCases.createACaregroup(caregroup);
        response.fold((l) => null, (r) => caregroup.id = r);
      } else {
        AllCaregroupUseCases.editACaregroup(caregroup);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CaregroupEnteredScreen(caregroup: caregroup),
        ),
      );
    }
  }
}
