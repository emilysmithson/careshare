import 'package:careshare/templates/page_scaffold.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/home-page";
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      body: Wrap(
        children: const [Text('HomePage')],
      ),
    );
  }
}
