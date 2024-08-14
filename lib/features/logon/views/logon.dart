import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:flutter/material.dart';

class LogonView extends StatefulWidget {
  const LogonView({super.key});

  @override
  State<LogonView> createState() => _LogonViewState();
}

class _LogonViewState extends State<LogonView> with TickerProviderStateMixin {
  bool emailLogin = false;
  bool runAnimationEmailField = true;
  String emailAddress = "";
  bool showPassword1 = false;
  bool runAnimationPassword1 = true;
  bool runAnimationPassword2 = true;
  bool showPassword2 = false;
  String password1 = "";
  String password2 = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          const Hero(tag: "logo", child: Logo()),
          const Expanded(flex: 2, child: SizedBox()),
          if (emailLogin)
            Animator(
              showAnimation: runAnimationEmailField,
              then: (_) {
                setState(() {
                  runAnimationEmailField = false;
                });
              },
              child: TextInput(
                onChanged: (email) => setState(() => emailAddress = email),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                label: const Text("Email"),
              ),
            ),
          if (showPassword1)
            Animator(
              showAnimation: runAnimationPassword1,
              then: (_) {
                setState(() {
                  runAnimationPassword1 = false;
                });
              },
              child: TextInput(
                onChanged: (password) => setState(() => password1 = password),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                label: const Text("Password"),
              ),
            ),
          if (showPassword2)
            Animator(
              showAnimation: runAnimationPassword2,
              then: (_) {
                setState(() {
                  runAnimationPassword2 = false;
                });
              },
              child: TextInput(
                onChanged: (password) => setState(() => password2 = password),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                label: const Text("Confirm Password"),
              ),
            ),
          CustomButton(
            primary: emailLogin,
            text: emailLogin ? "Continue" : "Continue with Email",
            onPressed: !emailLogin
                ? () => setState(() => emailLogin = true)
                : () => setState(() {
                      //TODO: check if email exists/is valid
                      showPassword1 = true;
                      showPassword2 = true;
                    }),
            margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          ),
          CustomButton(
            text: "Continue with Google",
            primary: false,
            onPressed: () {},
            margin: const EdgeInsets.symmetric(horizontal: 80),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }

  Widget Animator(
      {required Widget child,
      required Function(dynamic) then,
      required bool showAnimation}) {
    return AnimatedOpacity(
      opacity: emailLogin ? 1.0 : 0.0,
      duration: Duration(milliseconds: showAnimation ? 500 : 0),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(3, 0), // Start from the bottom
          end: Offset.zero, // End at the original position
        ).animate(
          CurvedAnimation(
            parent: AnimationController(
              vsync: this,
              duration: Duration(milliseconds: showAnimation ? 500 : 0),
            )..forward().then(then),
            curve: Curves.decelerate,
          ),
        ),
        child: child,
      ),
    );
  }
}
