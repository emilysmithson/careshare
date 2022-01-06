import 'package:careshare/home_page/presenter/home_page.dart';
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

      leading: IconButton(
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

      title: Text(title),

    );


  }
}