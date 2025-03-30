import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/root_navbar.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/community_tank/cubit/community_tank_cubit.dart';
import 'package:fishroom/features/fishroom/views/fishroom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

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

  @override
  Widget build(BuildContext context) {
    bool hasUsername = appCubit.state.user?.username != null;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) =>
          navReplace(context, Fishroom()),
      child: !hasUsername
          ? CreateUsernameModal()
          : Scaffold(
              appBar: RootSliverAppBar(
                title: "Community Tank",
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                shape: CircleBorder(),
                child: const Icon(Icons.add),
                onPressed: () => showModalBottomSheet(
                  enableDrag: true,
                  isScrollControlled: true,
                  scrollControlDisabledMaxHeightRatio: 0.5,
                  context: context,
                  builder: (context) => const CreatePostModal(),
                ),
              ),
              bottomNavigationBar: RootNavbar(currentIndex: 1),
              body: BlocBuilder<CommunityTankCubit, CommunityTankState>(
                builder: (context, state) {
                  if (loadingInitialPosts) {
                    return Center(child: Loader());
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await getInitialPosts(showLoading: false);
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                  post: state.posts[index], index: index),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
