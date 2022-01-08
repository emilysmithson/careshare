import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import '../../widgets/custom_form_field.dart';
import '../domain/models/story.dart';
import 'create_or_edit_story_controller.dart';

class CreateOrEditAStoryScreen extends StatefulWidget {
  final Story? story;
  const CreateOrEditAStoryScreen({
    Key? key,
    this.story,
  }) : super(key: key);

  @override
  State<CreateOrEditAStoryScreen> createState() =>
      _CreateOrEditAStoryScreenState();
}

class _CreateOrEditAStoryScreenState extends State<CreateOrEditAStoryScreen> {
  late CreateOrEditAStoryController controller = CreateOrEditAStoryController();
  bool showStoryTypeError = false;

  @override
  void initState() {
    controller.initialiseControllers(widget.story);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(controller.isCreateStory ? 'Create a New Story' : 'Edit a Story'),
      endDrawer: CustomDrawer(),
      body: SafeArea(
        child: Center(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [

                  CustomFormField(
                    controller: controller.storyController,
                    label: 'story',
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
                      controller.createAStory(
                        context: context,
                      );
                    },
                    child: Text(
                      controller.isCreateStory ? 'Create' : 'Save changes',
                    ),
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
