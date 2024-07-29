import 'package:flutter/material.dart';

class RootSliverAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RootSliverAppBar({
    super.key,
    required this.title,
    this.implyLeading = false,
    this.sliver = false,
  });

  final String title;
  final bool implyLeading;
  final bool sliver;
  @override
  Widget build(BuildContext context) {
    return sliver
        ? SliverAppBar(
            centerTitle: false,
            automaticallyImplyLeading: implyLeading,
            title: Text(title))
        : AppBar(
            centerTitle: false,
            title: Text(title),
            surfaceTintColor: Colors.transparent,
            elevation: 20,
          );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
