import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/widgets/root_navbar.dart';
import 'package:flutter/material.dart';

class CommunityView extends StatelessWidget {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: RootNavbar(currentIndex: 1),
        body: Center(
          child: Text(
            "The Community Tank\nComing soon!",
            style: kHeadingTextStyle,
            textAlign: TextAlign.center,
          ),
        ));
  }
}
