import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RootSliverAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RootSliverAppBar(
      {super.key,
      required this.title,
      this.implyLeading = false,
      this.sliver = false,
      this.actions = const [],
      this.flexibleSpace});

  final String title;
  final bool implyLeading;
  final bool sliver;
  final List<Widget> actions;
  final Widget? flexibleSpace;

  @override
  Widget build(BuildContext context) {
    return sliver
        ? SliverAppBar(
            elevation: 5,
            systemOverlayStyle: isDarkMode(context)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            backgroundColor: Colors
                .transparent, //isDarkMode(context) ? Colors.black : Colors.white,
            centerTitle: false,
            automaticallyImplyLeading: implyLeading,
            actions: actions,
            floating: true,
            surfaceTintColor: Colors.transparent,
            title: Text(
              title,
              style: kHeadingTextStyle,
            ),
            flexibleSpace: flexibleSpace)
        : AppBar(
            systemOverlayStyle: isDarkMode(context)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: implyLeading,
            centerTitle: false,
            title: Text(
              title,
              style: kHeadingTextStyle,
            ),
            surfaceTintColor: Colors.transparent,
            actions: actions,
            elevation: 5,
            flexibleSpace: flexibleSpace,
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
