import 'package:fishroom/core/usecases/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/show_toast.dart';
import '../../../main.dart';
import '../../app/cubit/app_cubit.dart';

Future<void> sendWelcomeEmail(BuildContext context) async {
  if (context.read<AppCubit>().state.user?.welcomeEmailSent == false) {
    try {
      fishLog("Sending welcome email...");
      //This is technically the reauthenticate email, but I adjusted it on the server side to be a welcome email. Its dumb but it works.
      await supabase.auth.reauthenticate();
      fishLog("Welcome Email Sent. Updating field...");
      await context.read<AppCubit>().setWelcomeEmailSent(true);
    } catch (e) {
      showToast(context,
          title: "Error Sending Email",
          toastType: ToastType.error,
          description: e.toString());
    }
  }
}
