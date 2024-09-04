import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, this.horizontal = false});

  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      SvgPicture.asset(
        'assets/fishroom_logo.svg',
        height: 100,
      ),
      Gap(horizontal ? 30 : 10),
      const Material(
        color: Colors.transparent,
        child: Text(
          'Fishroom',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              fontFamily: "CheesyCats"),
        ),
      ),
    ];
    return horizontal ? Row(children: children) : Column(children: children);
  }
}
