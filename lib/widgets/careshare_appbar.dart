import 'package:careshare/widgets/careshare_drawer.dart';
import 'package:flutter/material.dart';

class CareshareAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CareshareAppBar(this.title, {Key? key})
      : preferredSize = Size.fromHeight(50.0),
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
