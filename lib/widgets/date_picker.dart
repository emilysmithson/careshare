import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../style/style.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, required this.onDateTimeChanged}) : super(key: key);
  final Function onDateTimeChanged;

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Style.boxDecoration,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      height: 100,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (date) {
          widget.onDateTimeChanged(date);
        },
      ),
    );
  }
}
