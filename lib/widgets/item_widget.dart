import 'package:flutter/material.dart';

Widget itemWidget(
    {required String title, required String content, Widget? trailing}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            title + ':',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Text(content),
        ),
        trailing ?? Container()
      ],
    ),
  );
}
