import 'package:flutter/material.dart';

import '../domain/models/category.dart';
import '../domain/usecases/all_category_usecases.dart';
import '../domain/usecases/remove_a_category.dart';
import '../external/category_datasource_impl.dart';
import '../infrastructure/repositories/category_repository_impl.dart';

enum PageStatus {
  loading,
  error,
  success,
}

class ViewAllCategoriesController {
  final List<Category> categoryList = [];
  final ValueNotifier<PageStatus> status = ValueNotifier<PageStatus>(PageStatus.loading);

  fetchAllCategories() async {
    final response = await AllCategoryUseCases.fetchAllCategories();

    response.fold((l) {
      status.value = PageStatus.error;
      print('##############################');
      print(l.message);
    }, (r) {
      categoryList.clear();
      categoryList.addAll(r);
      status.value = PageStatus.success;
    });
  }

  removeACategory(String? categoryId) {
    if (categoryId == null) {
      return;
    }
    final CategoryDatasourceImpl datasource = CategoryDatasourceImpl();
    final CategoryRepositoryImpl repository = CategoryRepositoryImpl(datasource);
    final RemoveCategory remove = RemoveCategory(repository);
    remove(categoryId);
    status.value = PageStatus.loading;
    fetchAllCategories();
  }
}
