import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:fishroom/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/auth_cubit.dart';
import '../views/logon.dart';

void logOut(BuildContext context) {
  supabase.auth.signOut();
  context.read<AuthCubit>().clearCubit();
  context.read<TanksCubit>().clear();
  while (Navigator.canPop(context)) {
    Navigator.pop(context);
  }
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LogonView()));
}
