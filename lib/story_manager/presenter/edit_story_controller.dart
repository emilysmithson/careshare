import 'package:careshare/home_page/presenter/home_page.dart';
import 'package:flutter/material.dart';

import '../domain/models/story.dart';
import '../domain/usecases/all_story_usecases.dart';
// import 'story_entered_screen.dart';

class CreateOrEditAStoryController {
  final formKey = GlobalKey<FormState>();
  bool isCreateStory = true;
  Story? storedStory;

  late TextEditingController nameController;
  late TextEditingController storyController;
  late TextEditingController careesController;

  initialiseControllers(Story? originalStory) {
    if (originalStory != null) {
      storedStory = originalStory;
      isCreateStory = false;
    }
    storyController = TextEditingController(
      text: originalStory?.story,
    );
  }

  createAStory({
    required BuildContext context,
  }) async {
    if (formKey.currentState!.validate()) {
      final Story story = storedStory!;
      story.story = storyController.text;
      story.dateCreated = DateTime.now();

      if (isCreateStory) {
        final response = await AllStoryUseCases.createAStory(story);
        response.fold((l) => null, (r) => story.id = r);
      } else {
        AllStoryUseCases.editAStory(story);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // builder: (context) => StoryEnteredScreen(story: story),
          builder: (context) => HomePage(),
        ),
      );
    }
  }
}
