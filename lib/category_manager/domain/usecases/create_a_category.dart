import 'package:dartz/dartz.dart';
import '../errors/category_manager_exception.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';
import 'package:careshare/global.dart';

class CreateACategory {
  final CategoryRepository repository;

  CreateACategory(this.repository);
  Future<Either<CategoryManagerException, String>> call(Category category) async {
    Category categoryWithId = category;
    category.createdBy = myProfile.id;

    return repository.createCategory(categoryWithId);
  }
}
