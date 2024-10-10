import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RootSliverAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RootSliverAppBar(
      {super.key,
      required this.title,
      this.implyLeading = false,
      this.sliver = false,
      this.actions = const []});

  final String title;
  final bool implyLeading;
  final bool sliver;
  final List<Widget> actions;
  @override
  Widget build(BuildContext context) {
    return sliver
        ? SliverAppBar(
            systemOverlayStyle: isDarkMode(context)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            automaticallyImplyLeading: implyLeading,
            actions: actions,
            title: Text(title))
        : AppBar(
            systemOverlayStyle: isDarkMode(context)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            title: Text(title),
            surfaceTintColor: Colors.transparent,
            actions: actions,
            elevation: 20,
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
