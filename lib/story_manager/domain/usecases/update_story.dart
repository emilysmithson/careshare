import 'package:careshare/story_manager/domain/errors/story_manager_exception.dart';
import 'package:careshare/story_manager/domain/models/story.dart';
import 'package:careshare/story_manager/domain/repositories/story_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateStory {
  final StoryRepository repository;

  UpdateStory(this.repository);
  Future<Either<StoryManagerException, Story>> call(Story story) {
    return repository.updateStory(story);
  }
}
