import 'package:dartz/dartz.dart';

import '../errors/story_manager_exception.dart';
import '../models/story.dart';
import '../repositories/story_repository.dart';

class FetchAStory {
  final StoryRepository repository;

  FetchAStory(this.repository);
  Future<Either<StoryManagerException, Story>> call(id) {
    return repository.fetchAStory(id);
  }
}
