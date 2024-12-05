import 'package:fishroom/features/fishroom/cubit/tanks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/app/cubit/app_cubit.dart';

bool canAddTank(BuildContext context) {
  if (context.read<AppCubit>().state.user != null) {
    if (!context.read<AppCubit>().state.user!.premium) {
      if (context.read<TanksCubit>().state.tanks.isNotEmpty) {
        return false;
      }
    }
  } else {
    return false;
  }

  return true;
}
