import 'package:dartz/dartz.dart';

import '../errors/story_manager_exception.dart';
import '../models/story.dart';
import '../repositories/story_repository.dart';

class FetchStorys {
  final StoryRepository repository;

  FetchStorys(this.repository);
  Future<Either<StoryManagerException, List<Story>>> call({String? search}) {
    return repository.fetchStorys(search: search);
  }
}
