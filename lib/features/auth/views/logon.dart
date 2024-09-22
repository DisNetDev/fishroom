import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/usecases/email_validator.dart';
import '../../../core/usecases/password_validator.dart';
import '../../fishroom/views/fishroom.dart';

class LogonView extends StatefulWidget {
  const LogonView({super.key});

  @override
  State<LogonView> createState() => _LogonViewState();
}

class _LogonViewState extends State<LogonView> with TickerProviderStateMixin {
  int step = 1;
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
  final focusNodeEmail = FocusNode();
  final focusNodePassword1 = FocusNode();
  final focusNodePassword2 = FocusNode();

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
    focusNodeEmail.dispose();
    focusNodePassword1.dispose();
    focusNodePassword2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(30),
            const Hero(tag: "logo", child: Logo()),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  child: TextInput(
                    onEditingComplete: onEditingComplete,
                    initialValue: emailAddress,
                    focusNode: focusNodeEmail,
                    onChanged: (email) => setState(() => emailAddress = email),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    label: const Text("Email"),
                  ),
                ),
                AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: showPassword1 ? 1 : 0),
                TextInput(
                  onEditingComplete: onEditingComplete,
                  height: showPassword1 ? 50 : 0,
                  focusNode: focusNodePassword1,
                  obscureText: true,
                  onChanged: (password) => setState(() => password1 = password),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  label: const Text("Password"),
                ),
                TextInput(
                  onEditingComplete: onEditingComplete,
                  height: showPassword2 ? 50 : 0,
                  focusNode: focusNodePassword2,
                  obscureText: true,
                  onChanged: (password) => setState(() => password2 = password),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  label: const Text("Confirm Password"),
                ),
              ],
            ),
            CustomButton(
              primary: true,
              text: "Continue",
              onPressed: onEditingComplete,
              margin: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
            ),
            CustomButton(
              text: "Continue with Google",
              primary: false,
              onPressed: () {},
              margin: const EdgeInsets.symmetric(horizontal: 80),
            ),
            const Gap(30),
          ],
        ),
      ),
    );
  }

  void onEditingComplete() {
    if (isEmailValid(emailAddress)) {
      setState(() {
        showPassword1 = true;
        showPassword2 = true;
      });
      if (focusNodePassword2.hasFocus) {
        focusNodePassword2.unfocus();
      }
      if (focusNodePassword1.hasFocus) {
        focusNodePassword1.unfocus();
        focusNodePassword2.requestFocus();
        return;
      }

      if (focusNodeEmail.hasFocus) {
        focusNodeEmail.unfocus();
        focusNodePassword1.requestFocus();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid email address.")));
      return;
    }
    if (step == 2) {
      setState(() {
        PasswordValidatorObject passwordValidator =
            isPasswordsValid(password1, password2);

        if (passwordValidator.isValid) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Fishroom()));
        } else {
          if (showPassword1) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(passwordValidator.message)));
          }
          return;
        }
      });
    } else {
      setState(() => step = 2);
    }
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

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Opacity(
          opacity: 1.0,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1), // Start from the bottom
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
      },
      child: child,
    );
  }
}
