import 'package:careshare/global.dart';
import 'package:careshare/story_manager/presenter/view_story_screen.dart';
import 'package:flutter/material.dart';
import '../domain/models/story.dart';
import '../domain/usecases/all_story_usecases.dart';


class ViewAStoryController {
  final formKey = GlobalKey<FormState>();
  DateTime? acceptedDateTime;
  String? id;
  late Story story;

  late TextEditingController commentController;


  initialiseControllers(Story? originalStory) {
    story = originalStory!;
    id = originalStory.id;

    commentController = TextEditingController(
      text: "",
    );
  }

  ViewStoryController({
    required BuildContext context
  }) async {
    if (formKey.currentState!.validate()) {

      story.comments!.add(
        StoryComment(
          createdBy: myProfile.id,
          createdByDisplayName: myProfile.displayName,
          dateCreated: DateTime.now(),
          commment: commentController.text
        )
      );

      AllStoryUseCases.editAStory(story);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ViewStoryScreen(story: story),
        ),
      );
    }
  }
}
