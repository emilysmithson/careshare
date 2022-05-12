import 'package:flutter/material.dart';

class ErrorPageTemplate extends StatelessWidget {
  final String errorMessage;
  const ErrorPageTemplate({Key? key, required this.errorMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          errorMessage,
        ),
      ),
    );
  }
}
