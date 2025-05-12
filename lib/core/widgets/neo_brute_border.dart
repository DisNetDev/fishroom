import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';

class NeoBruteBorder extends StatelessWidget {
  const NeoBruteBorder(
      {super.key, required this.child, this.showShadow = true});

  final Widget child;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    Color borderColor = kTertiaryColor;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode(context) ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: borderColor,
                  offset: Offset(4, 4),
                )
              ]
            : [],
      ),
      child: child,
    );
  }
}
