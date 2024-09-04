import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';

import 'material_container.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.primary = true,
      this.margin});

  final String text;
  final Function() onPressed;
  final EdgeInsets? margin;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return MaterialContainer(
      height: 50,
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      onTap: onPressed,
      decoration: BoxDecoration(
        border: primary
            ? null
            : Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
        gradient: primary ? kPrimaryGradient : null,
        borderRadius: BorderRadius.circular(2000),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: primary
                ? Colors.white
                : Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
