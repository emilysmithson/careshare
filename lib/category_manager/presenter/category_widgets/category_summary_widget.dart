import 'package:flutter/material.dart';

import '../../../style/style.dart';
import '../../domain/models/category.dart';
import '../../domain/usecases/all_category_usecases.dart';
import '../edit_category_screen.dart';
import '../../../widgets/item_widget.dart';
import '../view_category_screen.dart';

class CategorySummaryWidget extends StatelessWidget {
  final Category category;
  const CategorySummaryWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6),
      padding: const EdgeInsets.all(6),
      decoration: Style.boxDecoration,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              itemWidget(
                title: 'Name',
                content: category.name!,
              ),
              itemWidget(
                title: 'Details',
                content: category.details!,
              ),


              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewCategoriescreen(categoryId: category.id!),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.remove_red_eye,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateOrEditACategoriescreen(
                              category: category,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AllCategoryUseCases.removeCategory(category.id!);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.grey,
                      ),
                    ),


                  ],
                ),
              ),

            ],
          ),



        ],
      ),
    );
  }
}
