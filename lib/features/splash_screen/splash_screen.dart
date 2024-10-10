// ignore_for_file: use_build_context_synchronously

import 'package:fishroom/core/repositories/supabase_repository.dart';
import 'package:fishroom/core/widgets/logo.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:fishroom/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../auth/views/logon.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (supabase.auth.currentSession != null) {
      context.read<SupabaseRepository>().setSession();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Fishroom()));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LogonView()));
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Hero(tag: "logo", child: Logo()),
          const SizedBox(height: 100),
          Lottie.asset('assets/loading_animation.json', height: 80),
        ],
      ),
    );
  }
}
