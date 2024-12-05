import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:toastification/toastification.dart';

void showToast(
  BuildContext context, {
  required String title,
  String? description,
  required ToastType toastType,
}) {
  toastification.showCustom(
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 5),
    builder: (BuildContext context, ToastificationItem holder) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: GradientBoxBorder(gradient: toastType.gradient),
            color: isDarkMode(context) ? Colors.black : Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: kHeading1TextStyle,
            ),
            if (description != null)
              Text(
                description,
                style: kPlainTextStyle,
              )
          ],
        ),
      );
    },
  );
}

// ignore: prefer-match-file-name
enum ToastType {
  error(kErrorGradient),
  info(kPrimaryGradient),
  success(kSuccessGradient);

  final LinearGradient gradient;
  const ToastType(this.gradient);
}
