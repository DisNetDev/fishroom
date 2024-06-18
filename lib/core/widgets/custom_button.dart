import 'package:flutter/material.dart';

import 'material_container.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key, required this.text, required this.onPressed, this.margin});

  final String text;
  final Function() onPressed;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return MaterialContainer(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      onTap: onPressed,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text),
    );
  }
}
