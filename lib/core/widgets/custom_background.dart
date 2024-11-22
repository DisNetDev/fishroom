import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: isDarkMode(context) ? Colors.black : Colors.white,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Colors.black,
            Color.fromARGB(255, 32, 32, 32),
          ])),
      // child: Opacity(
      //   opacity: isDarkMode(context) ? 0.4 : 0.5,
      //   child: SvgPicture.asset(
      //     isDarkMode(context)
      //         ? "assets/background_dark.svg"
      //         : "assets/background_light.svg",
      //     fit: BoxFit.cover,
      //   ),
      // ),
    );
  }
}
