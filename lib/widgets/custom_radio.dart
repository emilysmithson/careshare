import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final List<String> options;
  final Function onSelect;
  final int? selected;
  const CustomRadio({
    Key? key,
    required this.options,
    required this.onSelect,
    this.selected,
  }) : super(key: key);

  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  int selected = -1;
  @override
  void initState() {
    if (widget.selected != null) {
      selected = widget.selected!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selected = index;
                });
                widget.onSelect(index);
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: index == selected ? Colors.blue[300] : Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Text(widget.options[index]),
              ),
            );
          }),
    );
  }
}
