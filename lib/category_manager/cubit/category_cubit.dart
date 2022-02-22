import 'package:bloc/bloc.dart';
import 'package:careshare/category_manager/models/category.dart';

import 'package:equatable/equatable.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
part 'category_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());
  addCategory({
    required String name,
    required String id,
  }) {
    final category = CareCategory(
      id: id,
      name: name,
    );
    try {
      DatabaseReference reference =
          FirebaseDatabase.instance.ref('categories');

      reference.child(category.id!).set(category.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  final List<CareCategory> categoryList = [];
  Future fetchCategories() async {
    try {
      emit(CategoriesLoading());
      DatabaseReference reference =
          FirebaseDatabase.instance.ref('categories');
      final response = reference.onValue;
      response.listen((event) {
        emit(CategoriesLoading());
        if (event.snapshot.value == null) {
          if (kDebugMode) {
            print('empty list');
          }
          return;
        } else {
          Map<dynamic, dynamic> returnedList =
              event.snapshot.value as Map<dynamic, dynamic>;
          categoryList.clear();
          returnedList.forEach(
            (key, value) {
              categoryList.add(CareCategory.fromJson(value));
            },
          );

          emit(CategoriesLoaded(categoryList));
        }
      });
    } catch (error) {
      emit(
        CategoriesError(
          error.toString(),
        ),
      );
    }
  }

  clearList() {
    categoryList.clear();
  }

  String? getName(String id) {
    String? name;
    try {
      name = categoryList.firstWhere((element) => element.id == id).name;
    } catch (e) {
      return 'no name found';
    }
    return name;
  }
}
