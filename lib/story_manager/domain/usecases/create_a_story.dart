import 'package:dartz/dartz.dart';
import '../errors/story_manager_exception.dart';
import '../models/story.dart';
import '../repositories/story_repository.dart';
import 'package:careshare/global.dart';

class CreateAStory {
  final StoryRepository repository;

  CreateAStory(this.repository);
  Future<Either<StoryManagerException, String>> call(Story story) async {
    Story storyWithId = story;
    story.createdBy = myProfile.id;

    return repository.createStory(storyWithId);
  }
}
