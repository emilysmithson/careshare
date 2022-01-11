import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_database/firebase_database.dart';
import '../domain/errors/category_manager_exception.dart';
import '../domain/models/category.dart';
import '../infrastructure/datasources/category_datasouce.dart';

class CategoryDatasourceImpl implements CategoryDatasource {

  @override
  Future<String> createCategory(Category category) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("categories");
    final String newkey = reference.push().key as String;
    reference.child(newkey).set(category.toJson());

    return newkey;
  }

  @override
  Future editCategory(Category category) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("categories/${category.id}");

    await reference.set(category.toJson());
  }


  // FirebaseFirestore.instance
  //     .collection('users')
  //     .where('age', isGreaterThan: 20)
  //     .get()
  //     .then(...);

  @override
  Future<DatabaseEvent> fetchAllCategories() async {
    DatabaseReference reference;
    reference = FirebaseDatabase.instance.ref("categories");
    final response = await reference.once();
    return response;
  }

  @override
  Future updateCategory(Category category) async {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref("categories/${category.id}");

    await reference.set(category.toJson());
  }

  @override
  Future<DatabaseEvent> fetchACategory(String id) async {
    DatabaseReference reference = FirebaseDatabase.instance.ref("categories/$id");

    final response = await reference.once();

    return response;
  }


  @override
  Future removeACategory(String categoryId) async {
    DatabaseReference reference =
    FirebaseDatabase.instance.ref("categories/$categoryId");
    reference.remove();
  }

  @override
  Future<Either<CategoryManagerException, bool>> saveCategoryPhoto(File photo) {
    // TODO: implement saveCategoryPhoto
    throw UnimplementedError();
  }
}
