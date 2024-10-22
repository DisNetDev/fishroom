import 'package:flutter/material.dart';

import '../usecases/is_dark_mode.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkMode(context) ? Colors.black : Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
    );
  }
}
