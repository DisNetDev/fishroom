import 'dart:ui';

import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/community_tank/views/community_tank_view.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RootNavbar extends StatelessWidget {
  RootNavbar({super.key, required this.currentIndex});

  final int currentIndex;

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
          colorFilter: ColorFilter.mode(Colors.grey.shade400, BlendMode.srcIn),
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
            colorFilter:
                ColorFilter.mode(Colors.grey.shade400, BlendMode.srcIn),
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
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, -1), blurRadius: 6, color: Colors.black12),
            ],
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
              color: Colors.black54,
              child: Hero(
                tag: "bottomNavBar",
                child: BottomNavigationBar(
                  selectedItemColor: kPrimaryColor,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  currentIndex: currentIndex,
                  items: _navbarItems,
                  selectedLabelStyle: kHeadingTextStyle.copyWith(fontSize: 13),
                  unselectedLabelStyle:
                      kHeadingTextStyle.copyWith(fontSize: 12),
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
      ),
    );
  }
}

// class _Item extends StatelessWidget {
//   const _Item(
//       {super.key,
//       required this.selected,
//       required this.icon,
//       required this.label});

//   final bool selected;
//   final IconData icon;
//   final String label;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(icon, color: selected ? kPrimaryColor : null),
//         Text(label, style: TextStyle(color: selected ? kPrimaryColor : null)),
//       ],
//     );
//   }
// }
