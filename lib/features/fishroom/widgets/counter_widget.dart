import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/neo_brute_border.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
        child: NeoBruteBorder(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                if (icon != null) icon!,
                Gap(5),
                if (loading) Gap(5),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: loading
                      ? const Center(
                          child: Loader(
                            height: 24,
                          ),
                        )
                      : Text(
                          counter.toString(),
                          style: kHeadingTextStyle,
                        ),
                ),
                Text(
                  heading,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: kDateTimeTextStyle,
                ),
              ],
            ),
          ),
        ));
  }
}
