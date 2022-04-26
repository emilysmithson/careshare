import 'package:careshare/home_page/home_page.dart';
import 'package:careshare/notifications/presenter/widgets/bell_widget.dart';
import 'package:careshare/task_manager/presenter/task_manager_view.dart';
import 'package:careshare/task_manager/presenter/task_overview/tasks_overview.dart';
import 'package:flutter/material.dart';

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
          Navigator.of(context).pushNamed(
              TaskManagerView.routeName
          );
        },
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), const BellWidget()],
      ),
    );
  }
}
