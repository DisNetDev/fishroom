import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/is_dark_mode.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:toastification/toastification.dart';
import 'dart:async';

void showToast(
  BuildContext context, {
  required String title,
  String? description,
  required ToastType toastType,
}) {
  Duration autoCloseDuration = Duration(seconds: 5);
  if (toastType == ToastType.error) {
    autoCloseDuration = Duration(seconds: 15);
  }

  String descriptionToShow = description ?? "";

  if (descriptionToShow.contains("message:")) {
    descriptionToShow =
        "${descriptionToShow.split("message: ")[1].split(".")[0]}.";
  }

  // Add a timer to manage the countdown

  toastification.showCustom(
    dismissDirection: DismissDirection.horizontal,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: autoCloseDuration,
    builder: (BuildContext context, ToastificationItem holder) {
      return CountdownToast(
        duration: autoCloseDuration - Duration(seconds: 1),
        title: title,
        description: descriptionToShow,
        toastType: toastType,
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

class CountdownToast extends StatefulWidget {
  const CountdownToast({
    super.key,
    required this.duration,
    required this.title,
    required this.description,
    required this.toastType,
  });

  final Duration duration;
  final String title;
  final String? description;
  final ToastType toastType;

  @override
  State<CountdownToast> createState() => _CountdownToastState();
}

class _CountdownToastState extends State<CountdownToast> {
  Duration get duration => widget.duration;
  String get title => widget.title;
  String? get description => widget.description;
  ToastType get toastType => widget.toastType;

  int countdown = 0;

  double get borderRadius => 10;

  @override
  void initState() {
    countdown = duration.inMilliseconds;
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (countdown <= 0) {
        timer.cancel();
      } else {
        countdown -= 10;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 10,
          right: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            bottom: 0,
            child: LinearProgressIndicator(
              borderRadius: BorderRadius.circular(borderRadius),
              value: countdown / duration.inMilliseconds,
              backgroundColor: Colors.transparent,
              valueColor:
                  AlwaysStoppedAnimation(toastType.gradient.colors.first),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(color: Colors.transparent),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                    color: isDarkMode(context) ? Colors.black : Colors.white),
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
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
                        description!,
                        style: kPlainTextStyle,
                      )
                  ],
                ),
              ),
            ),
          ),
          // Countdown border
        ],
      ),
    );
  }
}
