import 'package:careshare/category_manager/domain/errors/category_manager_exception.dart';
import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/category_manager/domain/usecases/create_a_category.dart';
import 'package:careshare/category_manager/domain/usecases/edit_a_category.dart';
import 'package:careshare/category_manager/domain/usecases/remove_a_category.dart';
import 'package:careshare/category_manager/domain/usecases/fetch_categories.dart';
import 'package:careshare/category_manager/domain/usecases/fetch_a_category.dart';
import 'package:careshare/category_manager/domain/usecases/update_category.dart';
import 'package:careshare/category_manager/external/category_datasource_impl.dart';

import 'package:careshare/category_manager/infrastructure/repositories/category_repository_impl.dart';
import 'package:dartz/dartz.dart';


class AllCategoryUseCases {
  static Category? category;

  static Future<Either<CategoryManagerException, String>> createACategory(Category category) {
    final CategoryDatasourceImpl datasource = CategoryDatasourceImpl();
    final CategoryRepositoryImpl repository = CategoryRepositoryImpl(datasource);
    final CreateACategory createACategoryUseCase = CreateACategory(repository);
    return createACategoryUseCase(category);
  }

  static Future<Either<CategoryManagerException, Category>> editACategory(Category category) {
    final CategoryDatasourceImpl datasource = CategoryDatasourceImpl();
    final CategoryRepositoryImpl repository = CategoryRepositoryImpl(datasource);
    final EditACategory editACategoryUseCase = EditACategory(repository);
    return editACategoryUseCase(category);
  }


  static Future<Either<CategoryManagerException, List<Category>>> fetchAllCategories() async {
    final CategoryDatasourceImpl datasource = CategoryDatasourceImpl();
    final CategoryRepositoryImpl repository = CategoryRepositoryImpl(datasource);
    final FetchAllCategories fetchAllCategoriesDatasource = FetchAllCategories(repository);

    return fetchAllCategoriesDatasource();
  }

  static Future<Either<CategoryManagerException, Category>> fetchACategory(String id) async {
    final CategoryDatasourceImpl datasource = CategoryDatasourceImpl();
    final CategoryRepositoryImpl repository = CategoryRepositoryImpl(datasource);
    final FetchACategory fetchACategoryDatasource = FetchACategory(repository);

    return fetchACategoryDatasource(id);
  }

  static Future<Either<CategoryManagerException, Category>> updateCategory(
      Category category) async {
    final CategoryDatasourceImpl datasource = CategoryDatasourceImpl();
    final CategoryRepositoryImpl repository = CategoryRepositoryImpl(datasource);
    final UpdateCategory updateCategoryUseCase = UpdateCategory(repository);
    final Either<CategoryManagerException, Category> response =
        await updateCategoryUseCase(category);
    response.fold((l) => null, (r) => category = r);
    return response;
  }

  static Future<Either<CategoryManagerException, bool>> removeCategory(
      String id,
      ) {
    final CategoryDatasourceImpl datasource = CategoryDatasourceImpl();
    final CategoryRepositoryImpl repository = CategoryRepositoryImpl(datasource);
    final RemoveCategory removeACategoryUseCase = RemoveCategory(repository);
    return removeACategoryUseCase(id);
  }
  
  
}
