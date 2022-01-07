import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/story_manager_exception.dart';
import '../../domain/models/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../datasources/story_datasouce.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryDatasource datasource;

  StoryRepositoryImpl(this.datasource);

  @override
  Future<Either<StoryManagerException, String>> createStory(Story story) async {
    String response;
    try {
      response = await datasource.createStory(story);
    } catch (error) {
      return Left(StoryManagerException(error.toString()));
    }
    return Right(response);
  }

  @override
  Future<Either<StoryManagerException, Story>> editStory(Story story) async {
    try {
      datasource.editStory(story);
    } catch (error) {
      return Left(StoryManagerException(error.toString()));
    }
    return Right(story);
  }

  
  @override
  Future<Either<StoryManagerException, List<Story>>> fetchStorys({String? search}) async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchStorys(search: search);
    } catch (error) {
      return Left(StoryManagerException(error.toString()));
    }
    final List<Story> storyList = [];
    if (response.snapshot.value == null) {
      return Left(StoryManagerException('no values'));
    } else {

      // print(response.snapshot.value);

      Map<dynamic, dynamic> returnedList =
          response.snapshot.value as Map<dynamic, dynamic>;

      returnedList.forEach(
        (key, value) {
          storyList.add(Story.fromJson(key, value));
        },
      );
    }
    storyList.sort((a,b) => a.dateCreated!.compareTo(b.dateCreated!));
    return Right(storyList);
  }

  @override
  Future<Either<StoryManagerException, Story>> updateStory(
      Story story) async {
    try {
      datasource.updateStory(story);
    } catch (error) {
      return Left(StoryManagerException(error.toString()));
    }
    return Right(story);
  }

  @override
  Future<Either<StoryManagerException, bool>> saveStoryPhoto(File photo) {
    // TODO: implement saveStoryPhoto
    throw UnimplementedError();
  }

  @override
  Future<Either<StoryManagerException, Story>> fetchAStory(String id) async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchAStory(id);
    } catch (error) {
      return Left(StoryManagerException(error.toString()));
    }

    if (response.snapshot.value == null) {
      return Left(StoryManagerException('no value'));
    } else {
      return Right(Story.fromJson(response.snapshot.key, response.snapshot.value));
    }

  }


  @override
  Future<Either<StoryManagerException, Story>> fetchMyStory() async {

    DatabaseEvent response;
    try {
      response = await datasource.fetchMyStory();
    } catch (error) {
      return Left(StoryManagerException(error.toString()));
    }

    if (response.snapshot.value == null) {
      return Left(StoryManagerException('no value'));
    } else {

      var rawStory = response.snapshot.children.first;

      return Right(Story.fromJson(rawStory.key, rawStory.value));
    }

  }

  @override
  Future<Either<StoryManagerException, bool>> removeAStory(String storyId) async {
    try {
      datasource.removeAStory(storyId);
    } catch (error) {
      return Left(StoryManagerException(error.toString()));
    }
    return const Right(true);
  }


}
