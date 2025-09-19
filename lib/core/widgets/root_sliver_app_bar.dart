import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

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
    List<Widget> actionsToUse = actions ?? [];
    actionsToUse = [
      for (var action in actionsToUse) ...[action, Gap(10)],
    ];

    return sliver
        ? SliverAppBar(
            systemOverlayStyle: isDarkMode(context)
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            backgroundColor: Colors.transparent,
            centerTitle: false,
            automaticallyImplyLeading: implyLeading,
            actions: actions.isNotEmpty ? actionsToUse : null,
            floating: false,
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
            actions: actions.isNotEmpty ? actionsToUse : null,
            flexibleSpace: flexibleSpace,
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
