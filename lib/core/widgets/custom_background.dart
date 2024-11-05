import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../usecases/is_dark_mode.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isDarkMode(context) ? Colors.black : Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Opacity(
        opacity: isDarkMode(context) ? 0.4 : 0.5,
        child: SvgPicture.asset(
          isDarkMode(context)
              ? "assets/background_dark.svg"
              : "assets/background_light.svg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
