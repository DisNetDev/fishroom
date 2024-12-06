import 'package:fishroom/features/community/views/community_view.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class RootNavbar extends StatelessWidget {
  RootNavbar({super.key, required this.currentIndex});

  final int currentIndex;

  final List<BottomNavigationBarItem> _navbarItems = [
    BottomNavigationBarItem(
        icon: Icon(
          Symbols.home,
        ),
        label: "Home"),
    BottomNavigationBarItem(
        icon: Icon(Symbols.communities), label: "The Community Tank"),
  ];

  final List<Widget> _viewList = const [
    Fishroom(),
    CommunityView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          height: 80,
          child: Hero(
            tag: "bottomNavBar",
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              items: _navbarItems,
              onTap: (index) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => _viewList[index]));
              },
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
