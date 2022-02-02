import 'package:careshare/task_manager/presenter/task_manager_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_page/cubit/home_page_cubit.dart';

class CareshareAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CareshareAppBar(this.title, {Key? key})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Image.asset('images/CareShareLogo50.jpg'),
        onPressed: () {
          BlocProvider.of<HomePageCubit>(context)
              .navigateTo(const TaskManagerView());
        },
      ),
      title: Text(title),
    );
  }
}
