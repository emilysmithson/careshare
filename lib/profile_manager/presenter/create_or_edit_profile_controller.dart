import 'package:flutter/material.dart';

import '../domain/models/profile.dart';
import '../domain/usecases/all_profile_usecases.dart';
import 'profile_entered_screen.dart';

class CreateOrEditAProfileController {
  final formKey = GlobalKey<FormState>();
  bool isCreateProfile = true;

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  String? id;

  initialiseControllers(Profile? originalProfile) {
    if (originalProfile != null) {
      isCreateProfile = false;
      id = originalProfile.id;
    }
    nameController = TextEditingController(
      text: originalProfile?.name,
    );
  }

  createAProfile({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      final Profile profile = Profile(
        name: nameController.text,
      );
      if (isCreateProfile) {
        final response = await AllProfileUseCases.createAProfile(profile);
        response.fold((l) => null, (r) => profile.id = r);
      } else {
        profile.id = id;
        AllProfileUseCases.editAProfile(profile);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileEnteredScreen(profile: profile),
        ),
      );
    }
  }
}
