import 'package:careshare/story_manager/domain/errors/story_manager_exception.dart';
import 'package:careshare/story_manager/domain/models/story.dart';
import 'package:careshare/story_manager/domain/usecases/create_a_story.dart';
import 'package:careshare/story_manager/domain/usecases/edit_a_story.dart';
import 'package:careshare/story_manager/domain/usecases/remove_a_story.dart';
import 'package:careshare/story_manager/domain/usecases/fetch_stories.dart';
import 'package:careshare/story_manager/domain/usecases/fetch_a_story.dart';
import 'package:careshare/story_manager/domain/usecases/update_story.dart';
import 'package:careshare/story_manager/external/story_datasource_impl.dart';

import 'package:careshare/story_manager/infrastructure/repositories/story_repository_impl.dart';
import 'package:dartz/dartz.dart';


class AllStoryUseCases {
  static Story? story;

  static Future<Either<StoryManagerException, String>> createAStory(Story story) {
    final StoryDatasourceImpl datasource = StoryDatasourceImpl();
    final StoryRepositoryImpl repository = StoryRepositoryImpl(datasource);
    final CreateAStory createAStoryUseCase = CreateAStory(repository);
    return createAStoryUseCase(story);
  }

  static Future<Either<StoryManagerException, Story>> editAStory(Story story) {
    final StoryDatasourceImpl datasource = StoryDatasourceImpl();
    final StoryRepositoryImpl repository = StoryRepositoryImpl(datasource);
    final EditAStory editAStoryUseCase = EditAStory(repository);
    return editAStoryUseCase(story);
  }


  static Future<Either<StoryManagerException, List<Story>>> fetchStorys({String? search}) async {
    final StoryDatasourceImpl datasource = StoryDatasourceImpl();
    final StoryRepositoryImpl repository = StoryRepositoryImpl(datasource);
    final FetchStorys fetchStorysDatasource = FetchStorys(repository);

    return fetchStorysDatasource(search: search);
  }

  static Future<Either<StoryManagerException, Story>> fetchAStory(String id) async {
    final StoryDatasourceImpl datasource = StoryDatasourceImpl();
    final StoryRepositoryImpl repository = StoryRepositoryImpl(datasource);
    final FetchAStory fetchAStoryDatasource = FetchAStory(repository);

    return fetchAStoryDatasource(id);
  }


  static Future<Either<StoryManagerException, Story>> updateStory(
      Story story) async {
    final StoryDatasourceImpl datasource = StoryDatasourceImpl();
    final StoryRepositoryImpl repository = StoryRepositoryImpl(datasource);
    final UpdateStory updateStoryUseCase = UpdateStory(repository);
    final Either<StoryManagerException, Story> response =
        await updateStoryUseCase(story);
    response.fold((l) => null, (r) => story = r);
    return response;
  }

  static Future<Either<StoryManagerException, bool>> removeAStory(
      String id,
      ) {
    final StoryDatasourceImpl datasource = StoryDatasourceImpl();
    final StoryRepositoryImpl repository = StoryRepositoryImpl(datasource);
    final RemoveAStory removeAStoryUseCase = RemoveAStory(repository);
    return removeAStoryUseCase(id);
  }
  
  
}
