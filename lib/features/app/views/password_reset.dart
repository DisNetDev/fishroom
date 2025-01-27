import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:fishroom/features/splash_screen/splash_screen.dart';
import 'package:fishroom/main.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'dart:async';

import '../../../core/usecases/nav_push.dart';
import '../../../core/widgets/custom_button.dart';

class PasswordReset extends StatefulWidget {
  const PasswordReset({super.key, required this.emailAddress});

  final String emailAddress;

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  Timer? _timer;
  int _timeLeft = 120; // 2 minutes in seconds
  bool _canResendEmail = false;
  bool isLoading = false;
  String code = "";
  String password = "";
  String confirmPassword = "";

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    setState(() {
      _timeLeft = 120;
      _canResendEmail = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _canResendEmail = true;
          timer.cancel();
        }
      });
    });
  }

  String get timerText {
    final minutes = (_timeLeft / 60).floor();
    final seconds = _timeLeft % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                Text(
                  "Reset your Fishroom Password",
                  style: kHeadingTextStyle,
                  textAlign: TextAlign.center,
                ),
                Gap(30),
                Text(
                  "We've sent you an email\nwith a code to reset your password.",
                  textAlign: TextAlign.center,
                ),
                Expanded(
                  child: SizedBox(),
                ),
                TextInput(
                  initialValue: code,
                  label: Text("Code"),
                  onChanged: (value) => setState(() => code = value),
                ),
                Gap(60),
                TextInput(
                  initialValue: password,
                  label: Text("New Password"),
                  obscureText: true,
                  onChanged: (value) => setState(() => password = value),
                ),
                Gap(20),
                TextInput(
                  initialValue: confirmPassword,
                  label: Text("Confirm Password"),
                  obscureText: true,
                  onChanged: (value) => setState(() => confirmPassword = value),
                ),
                Gap(100),
                CustomButton(
                    loading: isLoading,
                    text: "Reset Password",
                    onPressed: () async {
                      if (password != confirmPassword) {
                        showToast(context,
                            title: "Passwords do not match",
                            toastType: ToastType.info);

                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        await supabase.auth.verifyOTP(
                          type: OtpType.recovery,
                          token: code,
                          email: widget.emailAddress,
                        );

                        await supabase.auth
                            .updateUser(UserAttributes(password: password));

                        setState(() => isLoading = false);

                        showToast(context,
                            title: "Password updated",
                            toastType: ToastType.success);

                        navPop(context);
                        navReplace(context, SplashScreen());
                      } catch (e) {
                        setState(() => isLoading = false);

                        showToast(context,
                            title: "Something went wrong.",
                            description: e.toString(),
                            toastType: ToastType.error);
                      }
                    }),
                Gap(20),
                CustomButton(
                  onDisabledTap: () => showToast(context,
                      title: "You can resend the email in $timerText",
                      toastType: ToastType.info),
                  disabled: !_canResendEmail,
                  text: _canResendEmail
                      ? "Send another email"
                      : "Send another email ($timerText)",
                  primary: false,
                  onPressed: () {
                    if (_canResendEmail) {
                      supabase.auth.resetPasswordForEmail(widget.emailAddress);
                      startTimer();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
