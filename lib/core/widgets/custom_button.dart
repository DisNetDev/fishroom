import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'loader.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.primary = true,
    this.margin,
    this.loading = false,
    this.gradient,
    this.textColor,
    this.autoPad = true,
    this.disabled = false,
    this.onDisabledTap,
  });

  final String text;
  final Function() onPressed;
  final EdgeInsets? margin;
  final bool primary;
  final bool loading;
  final Gradient? gradient;
  final Color? textColor;
  final bool autoPad;
  final bool? disabled;
  final VoidCallback? onDisabledTap;

  @override
  Widget build(BuildContext context) {
    Widget loader = isDarkMode(context) && primary
        ? const Loader(color: Colors.black)
        : const Loader();

    return GestureDetector(
      onTap: () {
        if (loading) {
          return;
        } else {
          if (disabled == true) {
            onDisabledTap?.call();
          } else {
            onPressed.call();
          }
        }
      },
      child: Container(
        constraints: autoPad
            ? const BoxConstraints(minHeight: 50, maxHeight: 50, minWidth: 100)
            : BoxConstraints(
                minHeight: 50,
                maxHeight: 50,
              ),
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        decoration: BoxDecoration(
          border: primary
              ? null
              : gradient != null
                  ? GradientBoxBorder(gradient: gradient!)
                  : Border.all(
                      color: isDarkMode(context) ? Colors.white : Colors.black,
                    ),
          gradient: primary ? kPrimaryGradient : null,
          borderRadius: BorderRadius.circular(2000),
        ),
        child: Center(
          child: loading
              ? loader
              : Text(
                  text,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor ??
                        (primary
                            ? Colors.white
                            : isDarkMode(context)
                                ? Colors.white
                                : Colors.black),
                  ),
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}
