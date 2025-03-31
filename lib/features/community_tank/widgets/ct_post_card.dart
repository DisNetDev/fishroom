import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/community_tank/cubit/community_tank_cubit.dart';
import 'package:fishroom/features/community_tank/models/ct_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/usecases/show_toast.dart';

class CTPostCard extends StatelessWidget {
  const CTPostCard({
    super.key,
    required this.post,
    this.index,
  });

  final CTPost post;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: index == 0
              ? BorderSide(color: Colors.grey.withAlpha(40))
              : BorderSide.none,
          bottom: BorderSide(color: Colors.grey.withAlpha(40)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              post.title,
              style: kHeading1TextStyle,
            ),
          ),
          if (post.images.isNotEmpty)
            CachedNetworkImage(
              errorWidget: (context, error, stackTrace) => AspectRatio(
                aspectRatio: 16 / 9,
                child: Icon(Icons.error),
              ),
              imageUrl: post.images.first,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Gap(10),
          Row(
            children: [
              Gap(10),
              Icon(
                Icons.person,
                color: Colors.grey,
                size: 20,
              ),
              Gap(5),
              Text(
                post.authorName,
                style: kDateTimeTextStyle.copyWith(
                    fontSize: 12, color: Colors.grey),
              ),
              Expanded(child: Container()),
              CTPostCardActions(post: post),
              Gap(20),
            ],
          ),
          Gap(10),
        ],
      ),
    );
  }
}

class CTPostCardActions extends StatelessWidget {
  const CTPostCardActions({super.key, required this.post});

  final CTPost post;

  @override
  Widget build(BuildContext context) {
    final CommunityTankCubit communityTankCubit =
        context.read<CommunityTankCubit>();
    return Row(
      children: [
        InkWell(
          onTap: () {
            try {
              communityTankCubit.upvotePost(post.id);
            } catch (e) {
              showToast(context,
                  title: "Something went wrong while upvoting:",
                  description: e.toString(),
                  toastType: ToastType.error);
            }
          },
          child: Row(
            children: [
              Icon(Icons.arrow_upward,
                  color: post.isUpvoted == true ? Colors.blue : Colors.grey,
                  size: 20),
              Gap(5),
              Text(post.upVotes.toString(),
                  style: kDateTimeTextStyle.copyWith(fontSize: 12)),
              Gap(10),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            try {
              communityTankCubit.downvotePost(post.id);
            } catch (e) {
              showToast(context,
                  title: "Something went wrong while downvoting:",
                  description: e.toString(),
                  toastType: ToastType.error);
            }
          },
          child: Row(
            children: [
              Icon(Icons.arrow_downward,
                  color: post.isUpvoted == false ? Colors.blue : Colors.grey,
                  size: 20),
              Gap(5),
              Text(post.downVotes.toString(),
                  style: kDateTimeTextStyle.copyWith(fontSize: 12)),
              Gap(10),
            ],
          ),
        ),
      ],
    );
  }
}
