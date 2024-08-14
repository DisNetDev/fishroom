import 'package:fishroom/core/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../logon/views/logon.dart';

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
          // const SizedBox(height: 20),
          // StreamBuilder<String>(
          //   stream: Stream.periodic(
          //       const Duration(seconds: 3), (_) => _getLoadingText()),
          //   builder: (context, snapshot) {
          //     return AnimatedSwitcher(
          //       duration: const Duration(milliseconds: 500),
          //       child: Text(
          //         snapshot.data ?? _getLoadingText(),
          //         key: ValueKey<String>(snapshot.data ?? _getLoadingText()),
          //         textAlign: TextAlign.center,
          //         style: const TextStyle(fontSize: 12, color: Colors.grey),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  String _getLoadingText() {
    List<String> loadingTexts = [
      'Cleaning glass...',
      'Dosing ferts...',
      'Feeding fish...',
      'Changing water...',
      'Checking pH...',
      'Adjusting temperature...',
      'Adding plants...',
      'Testing water quality...',
      'Acclimating new fish...',
      'Maintaining filter...',
      'Trimming plants...',
      'Measuring salinity...',
      'Treating tap water...',
      'Cycling tank...',
    ];
    return loadingTexts[DateTime.now().second % loadingTexts.length];
  }
}
