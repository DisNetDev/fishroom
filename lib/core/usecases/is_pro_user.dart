import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/app/cubit/app_cubit.dart';

bool isProUser(BuildContext context) {
  if (context.read<AppCubit>().state.user != null) {
    return context.read<AppCubit>().state.user!.premium;
  } else {
    return false;
  }
}
