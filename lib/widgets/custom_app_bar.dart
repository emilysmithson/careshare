import 'package:careshare/home_page/presenter/home_page.dart';
import '../task_manager/presenter/create_or_edit_task_screen.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CustomAppBar(
      this.title,
      { Key? key,}) : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // return AppBar(
    //   title: Text(
    //     title,
    //     style: TextStyle(color: Colors.black),
    //   ),
    //   backgroundColor: Colors.white,
    //   automaticallyImplyLeading: true,
    // );

    return AppBar(
      automaticallyImplyLeading: false,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          IconButton(
            icon: Image.asset('images/CareShareLogo50.jpg'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage()
                  ),
                );
            },
          ),


          Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(title)
          ),

        ],
      ),
      actions: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateOrEditATaskScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add))
      ],
    );


  }
}