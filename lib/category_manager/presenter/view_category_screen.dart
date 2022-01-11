import 'package:careshare/category_manager/domain/models/category.dart';
import 'package:careshare/category_manager/domain/usecases/all_category_usecases.dart';
import 'package:careshare/profile_manager/domain/models/profile.dart';
import 'package:careshare/profile_manager/domain/usecases/all_profile_usecases.dart';
import 'package:careshare/profile_manager/presenter/view_profile_screen.dart';
import 'package:careshare/style/style.dart';
import 'package:careshare/widgets/custom_app_bar.dart';
import 'package:careshare/widgets/custom_drawer.dart';
import 'package:careshare/widgets/item_widget.dart';
import 'package:flutter/material.dart';
import 'view_category_controller.dart';
import 'edit_category_screen.dart';

class ViewCategoriescreen extends StatefulWidget {
  final String categoryId;
  ViewCategoriescreen({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  
  @override
  State<ViewCategoriescreen> createState() =>
      _ViewCategoriescreenState();
}

class _ViewCategoriescreenState extends State<ViewCategoriescreen> {
  late ViewCategoryController controller = ViewCategoryController();
  bool showCategoryTypeError = false;

  bool isLoading = true;
  Category? category;

  Future fetchCategory(String id) async {
    final response = await AllCategoryUseCases.fetchACategory(id);
    response.fold(
            (l) {
          // print(">l " + l.message);

          if (l.message=='no value'){
            // print('no value for this authId');
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CreateCategoriescreen()));
          }
        },
            (r) {
              category = r;

          isLoading = false;
          setState(() {});
        });
  }


  @override
  void initState() {
    fetchCategory(widget.categoryId);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    if (isLoading){
      return Scaffold(
          body: Center(
              child: CircularProgressIndicator()
          )
      );
    }


    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar('Category: ${this.category!.name}'),
      endDrawer: CustomDrawer(),
      body: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(6),
        decoration: Style.boxDecoration,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              itemWidget(
                title: 'Name',
                content: category!.name!,
              ),
              itemWidget(
                title: 'Details',
                content: category!.details!,
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
                        AllCategoryUseCases.removeCategory(category!.id!);
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

        ),
      ),
    );
  }
}
