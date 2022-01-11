import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:flutter/material.dart';


enum PageStatus {
  loading,
  error,
  success,
}



class ViewCategoryController {

  final List<Category> categoryList = [];
  final ValueNotifier<PageStatus> status = ValueNotifier<PageStatus>(PageStatus.loading);

}
