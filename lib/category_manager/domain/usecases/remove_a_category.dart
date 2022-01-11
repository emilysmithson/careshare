import 'package:careshare/category_manager/domain/errors/category_manager_exception.dart';
import 'package:careshare/category_manager/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class RemoveCategory {
  final CategoryRepository repository;

  RemoveCategory(this.repository);

  Future<Either<CategoryManagerException, bool>> call(String categoryId) {
    return repository.removeACategory(categoryId);
  }
}
