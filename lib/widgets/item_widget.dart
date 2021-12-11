import 'package:flutter/material.dart';

Widget itemWidget(String title, String content) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        SizedBox(
          width: 150,
          child: Text(
            title + ':',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(child: Text(content)),
      ],
    ),
  );
}
