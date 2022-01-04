import 'package:flutter/material.dart';

class SelectCaregroup extends StatefulWidget {
  final List<String> caregroupOptions;
  final String? currentCaregroup;
  final Function onSelect;

  const SelectCaregroup({Key? key, required this.caregroupOptions, this.currentCaregroup, required this.onSelect})
      : super(key: key);

  @override
  _SelectCaregroupState createState() => _SelectCaregroupState();
}

class _SelectCaregroupState extends State<SelectCaregroup> {

    @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      isExpanded: true,
      hint: const Text('Select a task Caregroup'),
      value: widget.currentCaregroup,
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
      items: widget.caregroupOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
