import 'package:careshare/style/style.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:careshare/widgets/item_widget.dart';

import 'package:flutter/material.dart';
import '../domain/models/story.dart';
import 'view_story_controller.dart';
import 'package:intl/intl.dart';
import 'create_or_edit_story_screen.dart';
import '../domain/usecases/all_story_usecases.dart';
import '../../widgets/custom_app_bar.dart';

class ViewStoryScreen extends StatefulWidget {
  final Story story;
  const ViewStoryScreen({
    Key? key,
    required this.story,
  }) : super(key: key);

  @override
  State<ViewStoryScreen> createState() =>
      _ViewStoryScreenState();
}

class _ViewStoryScreenState extends State<ViewStoryScreen> {
  late ViewAStoryController controller = ViewAStoryController();
  bool showStoryTypeError = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar('Story Details'),
      endDrawer: CustomDrawer(),
      body: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: Style.boxDecoration,
        child: SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                itemWidget(
                  title: 'Story',
                  content: widget.story.story!,
                ),
                itemWidget(
                  title: 'Created',
                  content:
                  DateFormat('dd-MM-yyyy – kk:mm').format(widget.story.dateCreated!),
                ),

                itemWidget(
                  title: 'Created By',
                  content: widget.story.createdByDisplayName ?? 'Anonymous',
                ),

                if (widget.story.comments != null) Text("Comments"),
                if (widget.story.comments != null) Column(
                  children: widget.story.comments!.map((e) => Text(e.toString())).toList(),
                ),

                Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateOrEditAStoryScreen(
                                story: widget.story,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          AllStoryUseCases.removeAStory(widget.story.id!);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.grey,
                        ),
                      ),


                    ],
                  ),
                ),

              ],
            ),

        ),
      ),
    );
  }
}
