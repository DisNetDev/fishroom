import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatelessWidget {
  const Loader({super.key, this.height = 50, this.color});

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    //Main Widget
    Widget main = Lottie.asset('assets/loading_animation.json', height: height);

    //return with color overlay
    if (color != null) {
      return ColorFiltered(
          colorFilter: ColorFilter.mode(
            color!,
            BlendMode.srcATop,
          ),
          child: main);
    } else {
      //return without color overlay
      return main;
    }
  }
}
