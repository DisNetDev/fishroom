import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:glass/glass.dart';

import '../../../core/constants.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget(
      {super.key,
      required this.heading,
      required this.counter,
      this.icon,
      this.onTap,
      this.loading = false});

  final String heading;
  final int counter;
  final Widget? icon;
  final VoidCallback? onTap;
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              heading,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: kHeading2TextStyle,
            ),
            Gap(5),
            if (icon != null) icon!,
            Gap(5),
            if (loading) Gap(5),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: loading
                  ? const Center(
                      child: Loader(
                        height: 26,
                      ),
                    )
                  : Text(
                      counter.toString(),
                      style: kHeadingTextStyle,
                    ),
            ),
          ],
        ),
      ).asGlass(
        tintColor: isDarkMode(context)
            ? const Color.fromARGB(255, 50, 50, 50)
            : Colors.white,
        clipBorderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
