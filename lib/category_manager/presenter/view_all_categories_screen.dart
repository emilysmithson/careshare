import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'category_widgets/category_summary_widget.dart';
import '../domain/models/category.dart';
import 'view_all_categories_controller.dart';

class ViewAllCategoriesScreen extends StatefulWidget {
  const ViewAllCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllCategoriesScreen> createState() => _ViewAllCategoriesScreenState();
}

class _ViewAllCategoriesScreenState extends State<ViewAllCategoriesScreen> {
  final controller = ViewAllCategoriesController();

  @override
  void initState() {
    controller.fetchAllCategories();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('All Categories'),
      endDrawer: CustomDrawer(),
      body: ValueListenableBuilder(
        valueListenable: controller.status,
        builder: (context, status, _) {
          if (status == PageStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (status == PageStatus.error) {
            return const Center(child: Text('Couldn''t find any categories'));
          }
          return SingleChildScrollView(
            child: Column(
                children: controller.categoryList.map((Category category) {
                  return CategorySummaryWidget(category: category);
                }).toList()),
          );
        },
      ),
    );
  }
}
