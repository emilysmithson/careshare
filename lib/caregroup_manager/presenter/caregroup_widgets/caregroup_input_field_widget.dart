import 'dart:async';

import 'package:careshare/caregroup_manager/models/caregroup.dart';

import 'package:flutter/material.dart';

class CaregroupInputFieldWidget extends StatefulWidget {
  final Caregroup caregroup;
  final String? currentValue;
  final Function onChanged;
  final int maxLines;
  final String label;
  const CaregroupInputFieldWidget({
    Key? key,
    required this.caregroup,
    required this.label,
    this.currentValue,
    required this.onChanged,
    this.maxLines = 1,
  }) : super(
          key: key,
        );

  @override
  State<CaregroupInputFieldWidget> createState() => _CaregroupInputFieldWidgetState();
}

class _CaregroupInputFieldWidgetState extends State<CaregroupInputFieldWidget> {
  TextEditingController controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    if (widget.currentValue != null) {
      controller.text = widget.currentValue!;
    }
    super.initState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.maxLines,
      controller: controller,
      onChanged: (value) async {
        if (_debounce?.isActive ?? false) _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 500), () {
          widget.onChanged(value);
        });
      },
      decoration: InputDecoration(
        

        label: Text(widget.label),
      ),
    );
  }
}
