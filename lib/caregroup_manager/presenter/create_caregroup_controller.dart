import 'package:careshare/caregroup_manager/domain/models/caregroup_status.dart';
import 'package:flutter/material.dart';

import '../domain/models/caregroup.dart';
import '../domain/usecases/all_caregroup_usecases.dart';
import 'caregroup_entered_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:careshare/global.dart';

class CreateCaregroupController {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController detailsController;
  late TextEditingController careesController;

  initialiseControllers() {
    nameController = TextEditingController();
    detailsController = TextEditingController();
    careesController = TextEditingController();
  }

  createCaregroup({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      final Caregroup caregroup = Caregroup(
        name: nameController.text,
        details: detailsController.text,
        status: CaregroupStatus.active,
        dateCreated: DateTime.now(),
        carees: careesController.text,
      );

      final response = await AllCaregroupUseCases.createACaregroup(caregroup);
      response.fold((l) => null, (r) => caregroup.id = r);
      myProfileId = caregroup.id;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CaregroupEnteredScreen(caregroup: caregroup),
        ),
      );
    }
  }
}
