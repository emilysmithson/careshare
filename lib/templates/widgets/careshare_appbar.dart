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
        onPressed: () {},
      ),
      title: Text(title),
    );
  }
}
