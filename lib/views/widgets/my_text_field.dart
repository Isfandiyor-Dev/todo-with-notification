import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String labelText;
  final String? Function(String?) validation;
  final int maxLines;
  final TextEditingController textEditingController;
  const MyTextField({
    super.key,
    required this.labelText,
    required this.validation,
    required this.textEditingController,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditingController,
      validator: validation,
      minLines: 1,
      maxLines: maxLines,
      maxLength: maxLines > 1 ? 150 : null,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
