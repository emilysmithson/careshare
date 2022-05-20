import 'package:flutter/material.dart';

class LoadingPageTemplate extends StatelessWidget {
  final String loadingMessage;

  const LoadingPageTemplate({Key? key, required this.loadingMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 4,
              ),
            ),
            const SizedBox(width: 16),
            Text(loadingMessage)
          ],
        ),
      ),
    );
  }
}
