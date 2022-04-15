import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String name;
  final bool? fullSized;
  final Function() onPressed;

  const Button({
    Key? key,
    required this.name,
    required this.onPressed,
    this.fullSized,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(child: Text(name, style: TextStyle(color: Colors.white),), onPressed: onPressed);
  }
}
