import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';

class BorderBar extends StatelessWidget {
  const BorderBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      width: MediaQuery.of(context).size.width - 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(colors: [
            isDarkMode(context) ? Colors.grey.shade300 : Colors.white,
            Colors.transparent
          ])),
    );
  }
}
