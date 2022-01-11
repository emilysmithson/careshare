import 'dart:io';

import 'package:dartz/dartz.dart';

import '../errors/category_manager_exception.dart';
import '../models/category.dart';

abstract class CategoryRepository {
  Future<Either<CategoryManagerException, Category>> updateCategory(Category category);
  Future<Either<CategoryManagerException, Category>> editCategory(Category category);
  Future<Either<CategoryManagerException, List<Category>>> fetchAllCategories();
  Future<Either<CategoryManagerException, Category>> fetchACategory(String id);
  Future<Either<CategoryManagerException, String>> createCategory(Category category);
  Future<Either<CategoryManagerException, bool>> saveCategoryPhoto(File photo);
  Future<Either<CategoryManagerException, bool>> removeACategory(String categoryId);


}
