import 'package:flutter/material.dart';

class EffortIcon extends StatelessWidget {
  final int effort;
  const EffortIcon({Key? key, required this.effort}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    for (int i = 0; i < 6; i++) {
      widgetList.add(
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.blue,
            ),
            color: i < effort ? Colors.blue : null,
          ),
          width: 5,
          height: 5 * (i + 1),
        ),
      );
    }
    return SizedBox(
      width: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: widgetList,
      ),
    );
  }
}
