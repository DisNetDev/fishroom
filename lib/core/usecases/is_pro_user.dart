import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/cubit/auth_cubit.dart';

bool isProUser(BuildContext context) {
  if (context.read<AuthCubit>().state.user != null) {
    return context.read<AuthCubit>().state.user!.premium;
  } else {
    return false;
  }
}
