import 'package:careshare/templates/widgets/careshare_appbar.dart';
import 'package:careshare/templates/widgets/careshare_drawer.dart';
import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final String searchScope;
  final String searchType;

  const PageScaffold({
    Key? key,
    required this.body,
    this.floatingActionButton,
    this.searchScope = "",
    this.searchType = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CareshareAppBar('CareShare', searchScope, searchType),
      endDrawer: CareshareDrawer(),
      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
