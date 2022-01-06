import 'package:careshare/story_manager/domain/errors/story_manager_exception.dart';
import 'package:careshare/story_manager/domain/repositories/story_repository.dart';
import 'package:dartz/dartz.dart';

class RemoveAStory {
  final StoryRepository repository;

  RemoveAStory(this.repository);

  Future<Either<StoryManagerException, bool>> call(String storyId) {
    return repository.removeAStory(storyId);
  }
}
