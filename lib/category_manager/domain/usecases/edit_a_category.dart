import 'package:careshare/category_manager/domain/errors/category_manager_exception.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/category_manager/domain/repositories/category_repository.dart';
import 'package:dartz/dartz.dart';

class EditACategory {
  final CategoryRepository repository;

  EditACategory(this.repository);

  Future<Either<CategoryManagerException, Category>> call(Category category) {
    return repository.editCategory(category);
  }
}
