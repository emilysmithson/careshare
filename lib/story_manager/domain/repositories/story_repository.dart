import 'dart:io';

import 'package:dartz/dartz.dart';

import '../errors/story_manager_exception.dart';
import '../models/story.dart';

abstract class StoryRepository {
  Future<Either<StoryManagerException, Story>> updateStory(Story story);
  Future<Either<StoryManagerException, Story>> editStory(Story story);
  Future<Either<StoryManagerException, List<Story>>> fetchStorys({String? search});
  Future<Either<StoryManagerException, Story>> fetchAStory(String id);
  Future<Either<StoryManagerException, Story>> fetchMyStory();
  Future<Either<StoryManagerException, String>> createStory(Story story);
  Future<Either<StoryManagerException, bool>> saveStoryPhoto(File photo);
  Future<Either<StoryManagerException, bool>> removeAStory(String storyId);


}
