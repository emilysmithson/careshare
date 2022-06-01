import 'package:careshare/core/presentation/careshare_drawer.dart';
import 'package:careshare/home_page/home_page.dart';
import 'package:careshare/profile_manager/cubit/my_profile_cubit.dart';
import 'package:careshare/profile_manager/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PageScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  PageScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
    this.bottomNavigationBar,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> _key = GlobalKey(); // add this

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
        title: const Text('CareShare'),
        actions: [
          // if (searchType != "")
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {
          //       if (searchType == "Tasks") {
          //         Navigator.pushNamed(context, TaskSearch.routeName, arguments: searchScope);
          //       }
          //     },
          //   ),
          // const BellWidget(),
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
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(myProfile.photo), fit: BoxFit.cover),
                      ),
                    ),
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
