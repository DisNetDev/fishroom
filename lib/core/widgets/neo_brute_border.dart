import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';

class NeoBruteBorder extends StatelessWidget {
  const NeoBruteBorder(
      {super.key,
      required this.child,
      this.showShadow = true,
      this.showBorder = true});

  final Widget child;
  final bool showShadow;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    Color borderColor = kTertiaryColor;

    return Container(
      padding: EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        color: showBorder ? borderColor : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode(context) ? borderColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: showShadow
              ? [
                  BoxShadow(
                    color: borderColor,
                    offset: Offset(5, 5),
                  )
                ]
              : [],
        ),
        child: child,
      ),
    );
  }
}
