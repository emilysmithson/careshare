import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/story_manager_exception.dart';
import '../../domain/models/story.dart';

abstract class StoryDatasource {
  Future updateStory(Story story);
  Future<DatabaseEvent> fetchStorys({String? search});
  Future<String> createStory(Story story);
  Future<Either<StoryManagerException, bool>> saveStoryPhoto(File photo);
  Future<DatabaseEvent> fetchAStory(String id);
  Future<DatabaseEvent> fetchMyStory();
  Future removeAStory(String storyId);
  Future editStory(Story story);
}
