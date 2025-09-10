import 'package:fishroom/features/IAP/purchase_service.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/app/models/fish_user.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> checkAndSetPro(BuildContext context) async {
  FishUser? accountHolder = context.read<AppCubit>().state.user;
  if (accountHolder == null) {
    return;
  }

  String? baseID = await PurchaseService().isUserPro(
    activeSubscription: accountHolder.activeSubscription,
    nextProCheck: accountHolder.nextProCheck,
  );

  if (baseID != null) {
    context.read<AppCubit>().upgradeUserToPro();
  } else {
    context.read<AppCubit>().upgradeUserToPro(isPro: false);
  }
}
