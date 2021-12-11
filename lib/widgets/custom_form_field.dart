import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;
  final FormFieldValidator<String> validator;
  final bool obscureText;
  final TextEditingController? controller;
  final Widget? trailing;
  final int? maxLines;
  final String? initialValue;

  CustomFormField(
      {Key? key,
      required this.label,
      required this.validator,
      this.keyboardType,
      this.obscureText = false,
      this.controller,
      this.trailing,
      this.maxLines,
      this.initialValue})
      : super(key: key);

  final BoxDecoration boxDecoration = BoxDecoration(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: boxDecoration,
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              maxLines: maxLines,
              onChanged: (value) {},
              controller: controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                label: Text(label),
              ),
              obscureText: obscureText,
              keyboardType: keyboardType ?? TextInputType.text,
              validator: validator,
            ),
          ),
          trailing ?? Container()
        ],
      ),
    );
  }
}
