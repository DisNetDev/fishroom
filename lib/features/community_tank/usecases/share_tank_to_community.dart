import 'package:fishroom/core/models/tank.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/community_tank/cubit/community_tank_cubit.dart';
import 'package:fishroom/features/community_tank/models/ct_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

Future<void> shareTankToCommunity(BuildContext context, Tank tank) async {
  CommunityTankCubit cubit = context.read<CommunityTankCubit>();
  AppCubit appCubit = context.read<AppCubit>();
  CTPost post = CTPost(
    id: Uuid().v4(),
    title: tank.name ?? "Check out my Tank!",
    content: "Type: ${tank.type}\nSize: ${tank.size}",
    authorID: appCubit.state.user?.uuid ?? '',
    authorName: appCubit.state.user?.username ?? '',
    createdAt: DateTime.now().toUtc().toString(),
    images: tank.imageUrl != null ? [tank.imageUrl!] : [],
  );

  await cubit.createPost(post);
}
