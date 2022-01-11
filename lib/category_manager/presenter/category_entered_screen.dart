import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';

import 'category_widgets/category_summary_widget.dart';
import '../domain/models/category.dart';
import 'edit_category_screen.dart';
import 'view_all_categories_screen.dart';
import '../../home_page/presenter/home_page.dart';

class CategoryEnteredScreen extends StatelessWidget {
  final Category category;
  const CategoryEnteredScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('Category Created'),
      endDrawer: CustomDrawer(),
      body: Column(
        children: [
          CategorySummaryWidget(
            category: category,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateOrEditACategoriescreen()));
            },
            child: const Text('Create a new category'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ViewAllCategoriesScreen(),
                ),
              );
            },
            child: const Text('View all categories'),
          ),TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(),
                ),
              );
            },
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }
}
