import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/category_manager_exception.dart';
import '../../domain/models/category.dart';

abstract class CategoryDatasource {
  Future updateCategory(Category category);
  Future<DatabaseEvent> fetchAllCategories();
  Future<String> createCategory(Category category);
  Future<Either<CategoryManagerException, bool>> saveCategoryPhoto(File photo);
  Future<DatabaseEvent> fetchACategory(String id);
  Future removeACategory(String categoryId);
  Future editCategory(Category category);
}
