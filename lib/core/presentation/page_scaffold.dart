import 'package:careshare/core/presentation/careshare_drawer.dart';
import 'package:careshare/home_page/home_page.dart';
import 'package:careshare/notifications/presenter/widgets/bell_widget.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:careshare/profile_manager/presenter/profile_widgets/profile_photo_widget.dart';
import 'package:careshare/profile_manager/presenter/view_profile.dart';
import 'package:careshare/task_manager/presenter/task_search/task_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final String searchScope;
  final String searchType;

  PageScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.searchScope = "",
    this.searchType = "",
  }) : super(key: key);

  GlobalKey<ScaffoldState> _key = GlobalKey(); // add this

  @override
  Widget build(BuildContext context) {
    Profile myProfile = BlocProvider.of<MyProfileCubit>(context).myProfile;

    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset('images/CareShareLogo50.jpg'),
          onPressed: () {
            Navigator.of(context).pushNamed(HomePage.routeName);
          },
        ),
        title: Text('CareShare'),
        actions: [
          if (searchType != "")
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                if (searchType == "Tasks") {
                  Navigator.pushNamed(context, TaskSearch.routeName, arguments: searchScope);
                }
              },
            ),
          const BellWidget(),
          Tooltip(
            message: myProfile.name,
            child: GestureDetector(
              onTap: () {
                _key.currentState!.openEndDrawer(); // this opens drawer
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProfilePhotoWidget(id: myProfile.id),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // appBar: CareshareAppBar('CareShare', searchScope, searchType),
      endDrawer: CareshareDrawer(),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
