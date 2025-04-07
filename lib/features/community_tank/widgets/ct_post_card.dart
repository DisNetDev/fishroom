import 'package:cached_network_image/cached_network_image.dart';
import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/widgets/glass.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/features/community_tank/cubit/community_tank_cubit.dart';
import 'package:fishroom/features/community_tank/models/ct_post.dart';
import 'package:fishroom/features/community_tank/views/report_object.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/usecases/nav_push.dart';
import '../../../core/usecases/show_toast.dart';
import '../views/ct_post_details.dart';
import 'ct_post_card_action_button.dart';

class CTPostCard extends StatelessWidget {
  const CTPostCard({
    super.key,
    required this.post,
    this.index,
    this.isDetailedView = false,
  });

  final CTPost post;
  final int? index;
  final bool isDetailedView;
  @override
  Widget build(BuildContext context) {
    final CommunityTankCubit communityTankCubit =
        context.read<CommunityTankCubit>();

    return Glass(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  splashColor: kPrimaryColor,
                  radius: 10,
                  onTap: () {
                    if (!isDetailedView) {
                      navPush(context, CTPostDetails(postId: post.id));
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Text(post.title, style: kHeading1TextStyle),
                      ),
                      if (post.images.isNotEmpty)
                        CachedNetworkImage(
                          placeholder: (context, url) => AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Center(
                              child: Loader(color: Colors.black),
                            ),
                          ),
                          errorWidget: (context, error, stackTrace) =>
                              AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Icon(Icons.error),
                          ),
                          imageUrl: post.images.first,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      if (isDetailedView)
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(post.content))
                    ],
                  ),
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
                    Row(
                      children: [
                        CTPActionButton(
                            count: post.commentCount,
                            icon: Symbols.mode_comment_rounded,
                            onTap: () {
                              if (!isDetailedView) {
                                navPush(
                                    context, CTPostDetails(postId: post.id));
                              }
                            },
                            color: Colors.grey),
                        CTPActionButton(
                          count: post.upVotes,
                          icon: Icons.arrow_upward,
                          color: post.isUpvoted == true
                              ? kPrimaryColor
                              : Colors.grey,
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
                        ),
                        CTPActionButton(
                          count: post.downVotes,
                          icon: Icons.arrow_downward,
                          color: post.isUpvoted == false
                              ? Colors.deepOrange
                              : Colors.grey,
                          onTap: () {
                            try {
                              communityTankCubit.downvotePost(post.id);
                            } catch (e) {
                              showToast(context,
                                  title:
                                      "Something went wrong while downvoting:",
                                  description: e.toString(),
                                  toastType: ToastType.error);
                            }
                          },
                        ),
                      ],
                    ),
                    Gap(20),
                  ],
                ),
                Gap(10),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: PopupMenuButton(
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  if (value == "report_post") {
                    navPush(context, ReportObject(object: post));
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                          value: "report_post", child: Text("Report Post"))
                    ]),
          )
        ],
      ),
    );
  }
}
