// ignore_for_file: use_build_context_synchronously

import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/usecases/email_validator.dart';
import '../../../core/usecases/nav_push.dart';
import '../../../core/usecases/password_validator_object.dart';
import '../../../main.dart';
import 'password_reset.dart';

class LogonView extends StatefulWidget {
  const LogonView({super.key});

  @override
  State<LogonView> createState() => _LogonViewState();
}

class _LogonViewState extends State<LogonView> with TickerProviderStateMixin {
  //if userShouldLogIn is null, should only show email field.
  //if false, should show password1 and password2 for signup.
  //if true, should only show password1 and login
  bool? userShouldLogIn;
  bool runAnimationEmailField = true;
  String emailAddress = "";
  bool showPassword1 = false;
  bool runAnimationPassword1 = true;
  bool runAnimationPassword2 = true;
  bool showPassword2 = false;
  String password1 = "";
  String password2 = "";
  bool loading = false;
  bool googleLoading = false;
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
                    onChanged: (email) => setState(() {
                      emailAddress = email;
                      userShouldLogIn = null;
                      showPassword1 = false;
                      showPassword2 = false;
                    }),
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
              loading: loading,
              text: userShouldLogIn == null
                  ? "Continue"
                  : userShouldLogIn!
                      ? "Login"
                      : "Sign Up",
              onPressed: onEditingComplete,
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 80),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 50),
            //   child: SupaSocialsAuth(
            //     socialProviders: [OAuthProvider.google],
            //     onSuccess: (user) {
            //       print(user);
            //     },
            //   ),
            // ),
            CustomButton(
              text: "Sign in with Google",
              loading: googleLoading,
              primary: false,
              onPressed: () async {
                login(google: true);
              },
              margin: const EdgeInsets.symmetric(horizontal: 80),
            ),
            const Gap(30),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: showPassword1 && !showPassword2
                  ? TextButton(
                      onPressed: () {
                        supabase.auth.resetPasswordForEmail(emailAddress);
                        navPush(
                            context, PasswordReset(emailAddress: emailAddress));
                      },
                      child: const Text("Forgot Password"),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  bool checkIfEmailIsValid() {
    if (isEmailValid(emailAddress)) {
      return true;
    } else {
      showToast(
        context,
        title: "Invalid Email",
        description: "Please enter a valid email",
        toastType: ToastType.error,
      );

      return false;
    }
  }

  bool checkIfPasswordIsValid() {
    PasswordValidatorObject isValid = isPasswordsValid(password1, password2);
    if (isValid.isValid) {
      return true;
    } else {
      showToast(
        context,
        title: "Invalid Password",
        description: isValid.message,
        toastType: ToastType.error,
      );

      return false;
    }
  }

  void signUp() async {
    setState(() => loading = true);
    await context
        .read<AppCubit>()
        .signUpWithPassword(email: emailAddress, password: password1);
    await context
        .read<AppCubit>()
        .signInWithPassword(email: emailAddress, password: password1);
    if (context.read<AppCubit>().state.user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Fishroom()));
    } else {
      String message = "Something went wrong singing you up. Please try again.";
      setState(() => loading = false);
      showToast(
        context,
        title: "Something went wrong.",
        description: message,
        toastType: ToastType.error,
      );
    }
  }

  void login({bool google = false}) async {
    if (google) {
      setState(() => googleLoading = true);
    } else {
      setState(() => loading = true);
    }
    try {
      if (google) {
        await context.read<AppCubit>().nativeGoogleSignIn();
      } else {
        await context
            .read<AppCubit>()
            .signInWithPassword(email: emailAddress, password: password1);
      }
      if (context.read<AppCubit>().state.user != null) {
        navReplace(context, const Fishroom());
      } else {
        String message =
            "Something went wrong logging you in. Please try again.";

        setState(() {
          loading = false;
          googleLoading = false;
        });
        showToast(
          context,
          title: "Something went wrong.",
          description: message,
          toastType: ToastType.error,
        );
      }
    } catch (e) {
      setState(() {
        loading = false;
        googleLoading = false;
      });

      showToast(context,
          title: "Something went wrong.",
          toastType: ToastType.error,
          description: e.toString());
    }
    setState(() {
      loading = false;
      googleLoading = false;
    });
  }

  void onEditingComplete() async {
    switch (userShouldLogIn) {
      case null:
        if (checkIfEmailIsValid()) {
          setState(() => loading = true);
          bool userIsSignedUp =
              await context.read<AppCubit>().checkIfEmailExists(emailAddress);
          if (userIsSignedUp) {
            showPassword1 = true;
            userShouldLogIn = true;
          } else {
            showPassword1 = true;
            showPassword2 = true;
            userShouldLogIn = false;
          }
          focusNodeEmail.unfocus();
          focusNodePassword1.requestFocus();
        }
        setState(() => loading = false);
        break;

      case false:
        if (focusNodePassword1.hasFocus) {
          focusNodePassword2.requestFocus();
        } else if (focusNodePassword2.hasFocus) {
          if (checkIfEmailIsValid()) {
            if (checkIfPasswordIsValid()) {
              setState(() => loading = true);
              signUp();
            }
          }
        } else {
          focusNodeEmail.unfocus();
          focusNodePassword1.unfocus();
          focusNodePassword2.unfocus();
        }
        break;

      case true:
        if (checkIfEmailIsValid()) {
          setState(() => loading = true);
          login();
        }
        break;
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
                curve: Curves.bounceIn,
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
