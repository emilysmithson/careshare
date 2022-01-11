import 'package:dartz/dartz.dart';

import '../errors/category_manager_exception.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

class FetchAllCategories {
  final CategoryRepository repository;

  FetchAllCategories(this.repository);
  Future<Either<CategoryManagerException, List<Category>>> call() {
    return repository.fetchAllCategories();
  }
}
