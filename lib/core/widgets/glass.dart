import 'dart:ui';

import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';

class Glass extends StatelessWidget {
  const Glass({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: isDarkMode(context)
              ? Colors.white.withAlpha(10)
              : Colors.black.withAlpha(10),
          child: child,
        ),
      ),
    );
  }
}
