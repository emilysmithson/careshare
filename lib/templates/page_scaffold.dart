import 'package:careshare/templates/widgets/careshare_appbar.dart';
import 'package:careshare/templates/widgets/careshare_drawer.dart';
import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  const PageScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CareshareAppBar('CareShare'),
      endDrawer: CareshareDrawer(),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
