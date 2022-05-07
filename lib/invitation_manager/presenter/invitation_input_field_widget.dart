import 'dart:async';

import 'package:careshare/invitation_manager/models/invitation.dart';

import 'package:flutter/material.dart';

class InvitationInputFieldWidget extends StatefulWidget {
  final Invitation invitation;
  final String? currentValue;
  final Function onChanged;
  final int maxLines;
  final String label;
  final TextStyle? textStyle;
  const InvitationInputFieldWidget({
    Key? key,
    required this.invitation,
    required this.label,
    this.currentValue,
    required this.onChanged,
    this.textStyle,
    this.maxLines = 1,
  }) : super(
    key: key,
  );

  @override
  State<InvitationInputFieldWidget> createState() => _InvitationInputFieldWidgetState();
}

class _InvitationInputFieldWidgetState extends State<InvitationInputFieldWidget> {
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
      style: widget.textStyle,
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
