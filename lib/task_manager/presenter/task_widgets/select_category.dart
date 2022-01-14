import 'package:flutter/material.dart';

class SelectCategory extends StatefulWidget {
  final List<String> categoryOptions;
  final String? currentCategory;
  final Function onSelect;

  const SelectCategory({Key? key, required this.categoryOptions, this.currentCategory, required this.onSelect})
      : super(key: key);

  @override
  _SelectCategoryState createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {

    @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    widget.categoryOptions.sort((String a, String b) => a.compareTo(b));

    return DropdownButton<String>(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      isExpanded: true,
      hint: const Text('Select a task Category'),
      value: widget.currentCategory,
      underline: Container(),
      icon: const RotatedBox(
        quarterTurns: 3,
        child: Icon(Icons.chevron_left),
      ),
      onChanged: (String? newValue) {
        setState(() {
          widget.onSelect(newValue);
        });
      },
      items: widget.categoryOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
