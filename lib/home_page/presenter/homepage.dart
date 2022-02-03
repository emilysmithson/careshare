import 'package:careshare/home_page/cubit/home_page_cubit.dart';
import 'package:careshare/widgets/careshare_appbar.dart';
import 'package:careshare/widgets/careshare_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../task_manager/presenter/task_widgets/add_task_floating_action_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageCubit, HomePageState>(
      builder: (context, state) {
        return Scaffold(
            appBar: CareshareAppBar('CareShare'),
            endDrawer: CareshareDrawer(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                AddTaskBottomSheet().call(context);
              },
              child: const Icon(Icons.add),
            ),

            // bottomNavigationBar: BottomNavigationBar(
            //   items: const [
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.home),
            //       label: 'Home',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.all_inbox),
            //       label: 'All Tasks',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.compare_outlined),
            //       label: 'Completed',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.my_library_add),
            //       label: 'My Tasks',
            //     ),
            //   ],
            //   type: BottomNavigationBarType.fixed,
            // ),
            body: state.content);
      },
    );
  }
}
