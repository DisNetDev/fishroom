import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/fishroom/views/my_tanks.dart';
import 'package:flutter/material.dart';

import '../../../core/usecases/email_validator.dart';
import '../../../core/usecases/password_validator.dart';

class LogonView extends StatefulWidget {
  const LogonView({super.key});

  @override
  State<LogonView> createState() => _LogonViewState();
}

class _LogonViewState extends State<LogonView> with TickerProviderStateMixin {
  int step = 0;
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
  late AnimationController _emailController;
  late AnimationController _password1Controller;
  late AnimationController _password2Controller;

  @override
  void initState() {
    super.initState();
    _emailController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _password1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _password2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _password1Controller.dispose();
    _password2Controller.dispose();
    super.dispose();
  }

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
            animator(
              controller: _emailController,
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
            animator(
              controller: _password1Controller,
              showAnimation: runAnimationPassword1,
              then: (_) {
                setState(() {
                  runAnimationPassword1 = false;
                });
              },
              child: TextInput(
                obscureText: true,
                onChanged: (password) => setState(() => password1 = password),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                label: const Text("Password"),
              ),
            ),
          if (showPassword2)
            animator(
              controller: _password2Controller,
              showAnimation: runAnimationPassword2,
              then: (_) {
                setState(() {
                  runAnimationPassword2 = false;
                });
              },
              child: TextInput(
                obscureText: true,
                onChanged: (password) => setState(() => password2 = password),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                label: const Text("Confirm Password"),
              ),
            ),
          CustomButton(
            primary: emailLogin,
            text: emailLogin ? "Continue" : "Continue with Email",
            onPressed: !emailLogin
                ? () {
                    setState(() => emailLogin = true);
                    step = 1;
                  }
                : () {
                    if (isEmailValid(emailAddress)) {
                      showPassword1 = true;
                      showPassword2 = true;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text("Please enter a valid email address.")));
                      return;
                    }
                    if (step == 2) {
                      setState(() {
                        PasswordValidatorObject passwordValidator =
                            isPasswordsValid(password1, password2);

                        if (passwordValidator.isValid) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyTanks()));
                        } else {
                          if (showPassword1) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(passwordValidator.message)));
                          }
                          return;
                        }
                      });
                    } else {
                      setState(() => step = 2);
                    }
                  },
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

  Widget animator({
    required Widget child,
    required Function(dynamic) then,
    required bool showAnimation,
    required AnimationController controller,
  }) {
    if (showAnimation) {
      controller.reset();
      controller.forward().then(then);
    }

    return AnimatedOpacity(
      opacity: emailLogin ? 1.0 : 0.0,
      duration: Duration(milliseconds: showAnimation ? 1000 : 0),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(3, 0), // Start from the bottom
          end: Offset.zero, // End at the original position
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.decelerate,
          ),
        ),
        child: child,
      ),
    );
  }
}
