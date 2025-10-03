import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/community_tank/views/community_tank_view.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:fishroom/features/offline_mode/views/switch_to_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RootNavbar extends StatelessWidget {
  RootNavbar({super.key, required this.currentIndex});

  final int currentIndex;

  static Color unselectedColor = const Color.fromARGB(255, 173, 173, 173);

  final List<BottomNavigationBarItem> _navbarItems = [
    BottomNavigationBarItem(
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset(
          "assets/icons/home.svg",
          colorFilter: ColorFilter.mode(kTertiaryColor, BlendMode.srcIn),
        ),
      ),
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5),
        child: SvgPicture.asset(
          "assets/icons/home.svg",
          colorFilter: ColorFilter.mode(unselectedColor, BlendMode.srcIn),
        ),
      ),
      label: "Home",
    ),
    BottomNavigationBarItem(
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            "assets/icons/chat.svg",
            colorFilter: ColorFilter.mode(kTertiaryColor, BlendMode.srcIn),
          ),
        ),
        icon: Padding(
          padding: EdgeInsets.only(bottom: 5),
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
    AppCubit appCubit = context.read<AppCubit>();
    return SafeArea(
      child: ClipRRect(
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(),
          child: NeoBruteBorder(
            child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: BottomNavigationBar(
                  selectedFontSize: 14,
                  elevation: 5,
                  selectedItemColor: kTertiaryColor,
                  unselectedItemColor: unselectedColor,
                  selectedLabelStyle: kHeadingTextStyle.copyWith(
                      fontSize: 14, color: kTertiaryColor),
                  unselectedLabelStyle: kHeadingTextStyle.copyWith(
                      fontSize: 12, color: unselectedColor),
                  items: _navbarItems,
                  currentIndex: currentIndex,
                  onTap: (index) {
                    if (_viewList[index].runtimeType == CommunityTankView &&
                        appCubit.state.isOfflineMode) {
                      navPush(context, const SwitchToAccount());
                      return;
                    }
                    if (index == currentIndex) return;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => _viewList[index]));
                  },
                )),
          ),
        ),
      ),
    );
  }
}
