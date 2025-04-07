import 'dart:ui';

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/community_tank/views/community_tank_view.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../usecases/is_dark_mode.dart';

class RootNavbar extends StatelessWidget {
  RootNavbar({super.key, required this.currentIndex});

  final int currentIndex;

  static Color unselectedColor = Colors.white;

  final List<BottomNavigationBarItem> _navbarItems = [
    BottomNavigationBarItem(
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: SvgPicture.asset(
          "assets/icons/home.svg",
          colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
        ),
      ),
      icon: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: SvgPicture.asset(
          "assets/icons/home.svg",
          colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
        ),
      ),
      label: "Home",
    ),
    BottomNavigationBarItem(
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: SvgPicture.asset(
            "assets/icons/chat.svg",
            colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.srcIn),
          ),
        ),
        icon: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: SvgPicture.asset(
            "assets/icons/chat.svg",
            colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
          ),
        ),
        label: "The Community Tank"),
  ];

  final List<Widget> _viewList = const [
    Fishroom(),
    CommunityTankView(),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              height: 80,
              color: isDarkMode(context)
                  ? Colors.black54
                  : Colors.black.withAlpha(50),
              child: BottomNavigationBar(
                unselectedItemColor: Colors.white,
                selectedItemColor: kPrimaryColor,
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: currentIndex,
                items: _navbarItems,
                useLegacyColorScheme: true,
                selectedLabelStyle: kHeadingTextStyle.copyWith(fontSize: 13),
                unselectedLabelStyle: kHeadingTextStyle.copyWith(fontSize: 12),
                onTap: (index) {
                  if (index != currentIndex) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => _viewList[index]));
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
