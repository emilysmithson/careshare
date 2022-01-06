import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/models/story.dart';
import '../../domain/usecases/all_story_usecases.dart';
import '../../domain/usecases/remove_a_story.dart';
import '../../external/story_datasource_impl.dart';
import '../../infrastructure/repositories/story_repository_impl.dart';

enum PageStatus {
  loading,
  error,
  success,
}

class NewsFeedController {
  final List<Story> storyList = [];
  final ValueNotifier<PageStatus> status = ValueNotifier<PageStatus>(PageStatus.loading);

  fetchStorys() async {
    final response = await AllStoryUseCases.fetchStorys();

    response.fold((l) {
      status.value = PageStatus.error;
    }, (r) {
      storyList.clear();
      storyList.addAll(r);
      status.value = PageStatus.success;
    });
  }

  removeAStory(String? storyId) {
    if (storyId == null) {
      return;
    }
    final StoryDatasourceImpl datasource = StoryDatasourceImpl();
    final StoryRepositoryImpl repository = StoryRepositoryImpl(datasource);
    final RemoveAStory remove = RemoveAStory(repository);
    remove(storyId);
    status.value = PageStatus.loading;
    fetchStorys();
  }
}
