import 'package:flutter/material.dart';

class Style {
  static BoxDecoration boxDecoration = BoxDecoration(
    borderRadius: const BorderRadius.all(
      Radius.circular(20),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 3,
        blurRadius: 5,
        offset: const Offset(1, 1),
      )
    ],
    color: Colors.white,
  );
}
