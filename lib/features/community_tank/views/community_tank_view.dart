import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/root_navbar.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:flutter/material.dart';

class CommunityTankView extends StatelessWidget {
  const CommunityTankView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          navReplace(context, Fishroom()),
      child: Scaffold(
          bottomNavigationBar: RootNavbar(currentIndex: 1),
          body: Center(
            child: Text(
              "The Community Tank\nComing soon!",
              style: kHeadingTextStyle,
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}
