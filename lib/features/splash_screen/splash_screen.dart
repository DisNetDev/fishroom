import 'package:fishroom/core/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../auth/views/logon.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogonView()),
      );
    });
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Hero(tag: "logo", child: Logo()),
          const SizedBox(height: 100),
          Lottie.asset('assets/loading_animation.json', height: 80),
        ],
      ),
    );
  }
}
