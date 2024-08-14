import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          'assets/fishroom_logo.svg',
          height: 100,
        ),
        const SizedBox(height: 10),
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
      ],
    );
  }
}
