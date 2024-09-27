import 'package:fishroom/core/constants.dart';
import 'package:flutter/material.dart';

import 'loader.dart';
import 'material_container.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.primary = true,
    this.margin,
    this.loading = false,
  });

  final String text;
  final Function() onPressed;
  final EdgeInsets? margin;
  final bool primary;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Widget loader = isDarkMode && primary
        ? const Loader(color: Colors.black)
        : const Loader();

    return MaterialContainer(
      constraints:
          const BoxConstraints(minHeight: 50, maxHeight: 50, minWidth: 100),
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      onTap: onPressed,
      decoration: BoxDecoration(
        border: primary
            ? null
            : Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
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
                  color: primary
                      ? Colors.white
                      : Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
      ),
    );
  }
}
