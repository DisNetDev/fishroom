import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/app/views/logon_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class SwitchToAccount extends StatelessWidget {
  const SwitchToAccount({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit appCubit = context.read<AppCubit>();
    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Expanded(child: SizedBox()),
                    Logo(),
                    Text(
                      "Switching to an Account",
                      style: kHeadingTextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Expanded(child: SizedBox()),
                    Text(
                      "Would you like to use an account?",
                      style: kHeading1TextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Creating an account allows you to sync your data across devices and access premium features. All your current data will be kept and synced.\nThis is the recommended option.",
                      style: kHeading2TextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Gap(10),
                    CustomButton(
                        text: "Switch to an Account",
                        onPressed: () {
                          appCubit.setOfflineMode(false);
                          navPush(context, const LogonView());
                        }),
                    Gap(40),
                    Text(
                      "Offline Mode:",
                      style: kHeading1TextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Stay on Offline Mode with limited features and go back to the previous screen.",
                      style: kHeading2TextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Gap(10),
                    CustomButton(
                      text: "Stay Offline",
                      onPressed: () {
                        appCubit.setOfflineMode(true);
                      },
                      primary: false,
                    ),
                    Gap(40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
