import 'package:careshare/caregroup_manager/models/caregroup.dart';
import 'package:careshare/category_manager/cubit/category_cubit.dart';
import 'package:careshare/core/presentation/error_page_template.dart';
import 'package:careshare/core/presentation/loading_page_template.dart';
import 'package:careshare/profile_manager/presenter/fetch_profiles_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class FetchCategoriesPage extends StatelessWidget {
  static const routeName = '/fetch-categories-page';
  final Caregroup caregroup;
  const FetchCategoriesPage({
    Key? key,
    required this.caregroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('fetching categories for caregroup: ${caregroup.name}');


    BlocProvider.of<CategoriesCubit>(context).fetchCategories();

    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const LoadingPageTemplate(
              loadingMessage: 'Loading caregroups...');
        }
        if (state is CategoriesError) {
          return ErrorPageTemplate(errorMessage: state.message);
        }
        if (state is CategoriesLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) =>
              Navigator.pushReplacementNamed(context, FetchProfilesPage.routeName,
                  arguments: caregroup));
          return Container();
        }
        return Container();
      },
    );
  }
}
