import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/cubit/auth_cubit.dart';

bool canAddTank(BuildContext context) {
  if (context.read<AuthCubit>().state.user != null) {
    if (!context.read<AuthCubit>().state.user!.premium) {
      if (context.read<TanksCubit>().state.tanks.isNotEmpty) {
        return false;
      }
    }
  } else {
    return false;
  }
  return true;
}
