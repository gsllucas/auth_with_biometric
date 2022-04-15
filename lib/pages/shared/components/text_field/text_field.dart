import 'package:flutter/material.dart';

class TextFieldAuth extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPasswordField;

  TextFieldAuth({
    Key? key,
    required this.label,
    required this.controller,
    required this.keyboardType,
    required this.isPasswordField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration:
          InputDecoration(border: OutlineInputBorder(), labelText: label),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPasswordField,
    );
  }
}
