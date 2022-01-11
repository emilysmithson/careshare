import 'package:dartz/dartz.dart';

import '../errors/category_manager_exception.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

class FetchACategory {
  final CategoryRepository repository;

  FetchACategory(this.repository);
  Future<Either<CategoryManagerException, Category>> call(id) {
    return repository.fetchACategory(id);
  }
}
