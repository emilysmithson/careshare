import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../domain/errors/category_manager_exception.dart';
import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_datasouce.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDatasource datasource;

  CategoryRepositoryImpl(this.datasource);

  @override
  Future<Either<CategoryManagerException, String>> createCategory(Category category) async {
    String response;
    try {
      response = await datasource.createCategory(category);
    } catch (error) {
      return Left(CategoryManagerException(error.toString()));
    }
    return Right(response);
  }

  @override
  Future<Either<CategoryManagerException, Category>> editCategory(Category category) async {
    try {
      datasource.editCategory(category);
    } catch (error) {
      return Left(CategoryManagerException(error.toString()));
    }
    return Right(category);
  }

  
  @override
  Future<Either<CategoryManagerException, List<Category>>> fetchAllCategories() async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchAllCategories();
    } catch (error) {
      return Left(CategoryManagerException(error.toString()));
    }
    final List<Category> categoryList = [];
    if (response.snapshot.value == null) {
      return Left(CategoryManagerException('no values'));
    } else {

      // print(response.snapshot.value);

      Map<dynamic, dynamic> returnedList =
          response.snapshot.value as Map<dynamic, dynamic>;

      returnedList.forEach(
        (key, value) {
          categoryList.add(Category.fromJson(key, value));
        },
      );
    }
    return Right(categoryList);
  }

  @override
  Future<Either<CategoryManagerException, Category>> updateCategory(
      Category category) async {
    try {
      datasource.updateCategory(category);
    } catch (error) {
      return Left(CategoryManagerException(error.toString()));
    }
    return Right(category);
  }

  @override
  Future<Either<CategoryManagerException, bool>> saveCategoryPhoto(File photo) {
    // TODO: implement saveCategoryPhoto
    throw UnimplementedError();
  }

  @override
  Future<Either<CategoryManagerException, Category>> fetchACategory(String id) async {
    DatabaseEvent response;
    try {
      response = await datasource.fetchACategory(id);
    } catch (error) {
      return Left(CategoryManagerException(error.toString()));
    }

    if (response.snapshot.value == null) {
      return Left(CategoryManagerException('no value'));
    } else {
      return Right(Category.fromJson(response.snapshot.key, response.snapshot.value));
    }

  }


  @override
  Future<Either<CategoryManagerException, bool>> removeACategory(String categoryId) async {
    try {
      datasource.removeACategory(categoryId);
    } catch (error) {
      return Left(CategoryManagerException(error.toString()));
    }
    return const Right(true);
  }

}
