import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/root_navbar.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/community_tank/cubit/community_tank_cubit.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../core/widgets/loader.dart';
import '../../app/cubit/app_cubit.dart';
import '../widgets/create_post_modal.dart';
import '../widgets/create_username_modal.dart';
import '../widgets/ct_post_card.dart';

class CommunityTankView extends StatefulWidget {
  const CommunityTankView({super.key});

  @override
  State<CommunityTankView> createState() => _CommunityTankViewState();
}

class _CommunityTankViewState extends State<CommunityTankView> {
  AppCubit get appCubit => context.read<AppCubit>();
  CommunityTankCubit get communityTankCubit =>
      context.read<CommunityTankCubit>();

  bool loadingInitialPosts = false;
  bool loadingMorePosts = false;

  Future<void> getInitialPosts({bool showLoading = true}) async {
    try {
      if (showLoading) setState(() => loadingInitialPosts = true);
      await communityTankCubit.getPosts(initial: true);
      setState(() => loadingInitialPosts = false);
    } catch (e) {
      setState(() => loadingInitialPosts = false);
      showToast(context,
          title: "Something went wrong while loading posts:",
          description: e.toString(),
          toastType: ToastType.error);
    }
  }

  Future<void> getMorePosts() async {
    try {
      setState(() => loadingMorePosts = true);
      await communityTankCubit.getPosts();
      setState(() => loadingMorePosts = false);
    } catch (e) {
      setState(() => loadingMorePosts = false);
      showToast(context,
          title: "Something went wrong while loading more posts:",
          description: e.toString(),
          toastType: ToastType.error);
    }
  }

  @override
  void initState() {
    super.initState();
    getInitialPosts();
  }

  DraggableScrollableController scrollableController =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    bool hasUsername = appCubit.state.user?.username != null &&
        appCubit.state.user!.username!.isNotEmpty;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          navReplace(context, Fishroom()),
      child: !hasUsername
          ? CreateUsernameModal()
          : Stack(
              children: [
                CustomBackground(),
                Scaffold(
                  extendBody: true,
                  backgroundColor: Colors.transparent,
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  floatingActionButton: FloatingActionButton(
                    elevation: 0,
                    shape: CircleBorder(),
                    child: const Icon(Icons.add),
                    onPressed: () => showMaterialModalBottomSheet(
                      enableDrag: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      isDismissible: true,
                      builder: (context) => Container(
                        color: Colors.transparent,
                        child: Container(
                          padding: MediaQuery.of(context).viewInsets,
                          child: DraggableScrollableSheet(
                            controller: scrollableController,
                            expand: false,
                            snap: true,
                            initialChildSize: 0.9,
                            maxChildSize: 1,
                            snapSizes: [0.9],
                            builder: (context, scrollController) => Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                ),
                                child: CreatePostModal()),
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar:
                      Hero(tag: "navbar", child: RootNavbar(currentIndex: 1)),
                  body: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      RootSliverAppBar(
                        title: "Community Tank",
                        sliver: true,
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        sliver:
                            BlocBuilder<CommunityTankCubit, CommunityTankState>(
                          builder: (context, state) {
                            if (loadingInitialPosts) {
                              return SliverFillRemaining(
                                child: Center(child: Loader()),
                              );
                            }
                            return SliverToBoxAdapter(
                              child: RefreshIndicator(
                                onRefresh: () async {
                                  await getInitialPosts(showLoading: false);
                                },
                                child: Column(
                                  spacing: 10,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (communityTankCubit.state.posts.isEmpty)
                                      Center(
                                        child: Text(
                                          "Welcome to the Community Tank! \nThe tank seems to be empty. \nCreate a post to get started.",
                                          style: kHeadingTextStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ...List.generate(
                                      state.posts.length,
                                      (index) => Animate(
                                        effects: [FadeEffect(duration: 500.ms)],
                                        child: CTPostCard(
                                            post: state.posts[index],
                                            index: index),
                                      ),
                                    ),
                                    Gap(200),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
