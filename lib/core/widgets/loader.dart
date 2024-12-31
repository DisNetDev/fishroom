import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Loader extends StatefulWidget {
  const Loader({super.key, this.height = 50, this.color});

  final double height;
  final Color? color;

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  bool _showLoader = false;

  @override
  void initState() {
    super.initState();
    // Trigger the animation after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _showLoader = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Main Widget
    Widget main =
        Lottie.asset('assets/loading_animation.json', height: widget.height);

    //Wrap with AnimatedScale
    Widget animated = AnimatedScale(
      scale: _showLoader ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: main,
    );

    //return with color overlay
    if (widget.color != null) {
      return ColorFiltered(
          colorFilter: ColorFilter.mode(
            widget.color!,
            BlendMode.srcATop,
          ),
          child: animated);
    } else {
      //return without color overlay
      return animated;
    }
  }
}
