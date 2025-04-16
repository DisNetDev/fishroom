import 'package:collection/collection.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/community_tank/models/ct_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../cubit/community_tank_cubit.dart';
import '../models/ct_comment.dart';
import '../widgets/create_comment_modal.dart';
import '../widgets/ct_comment_card.dart';
import '../widgets/ct_post_card.dart';

class CTPostDetails extends StatefulWidget {
  const CTPostDetails({super.key, required this.postId});

  final String postId;

  @override
  State<CTPostDetails> createState() => _CTPostDetailsState();
}

class _CTPostDetailsState extends State<CTPostDetails> {
  DraggableScrollableController scrollController =
      DraggableScrollableController();
  bool loadingComments = false;
  CommunityTankCubit get communityTankCubit =>
      context.read<CommunityTankCubit>();
  AppCubit get appCubit => context.read<AppCubit>();

  List<CTComment> comments = [];

  Future<void> init() async {
    setState(() => loadingComments = true);
    try {
      comments = await communityTankCubit.getComments(widget.postId);
      setState(() => loadingComments = false);
    } catch (e) {
      setState(() => loadingComments = false);
      showToast(context,
          title: "Something went wrong getting comments.",
          description: e.toString(),
          toastType: ToastType.error);
    }
  }

  @override
  void initState() {
    init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityTankCubit, CommunityTankState>(
      builder: (context, state) {
        bool isMyPost = false;

        final post = state.posts
            .firstWhereOrNull((element) => element.id == widget.postId);
        if (post?.authorID == appCubit.state.user!.uuid) {
          isMyPost = true;
        }
        return Stack(
          children: [
            CustomBackground(),
            Scaffold(
              backgroundColor: Colors.transparent,
              floatingActionButton: FloatingActionButton(
                shape: CircleBorder(),
                onPressed: () async {
                  await showModalBottomSheet(
                    enableDrag: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    isDismissible: true,
                    isScrollControlled: true,
                    builder: (context) => Container(
                      color: Colors.transparent,
                      child: Container(
                        padding: MediaQuery.of(context).viewInsets,
                        child: DraggableScrollableSheet(
                          controller: scrollController,
                          expand: false,
                          snap: true,
                          minChildSize: 0.1,
                          initialChildSize: 0.5,
                          maxChildSize: 0.9,
                          snapSizes: [0.1, 0.5, 0.9],
                          builder: (context, scrollController) => Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: CreateCommentModal(
                              postId: widget.postId,
                              onCommentCreated: (comment) => setState(
                                () => comments.add(comment),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).then((value) => init());
                },
                child: const Icon(Icons.add),
              ),
              appBar: RootSliverAppBar(
                implyLeading: true,
                title: "",
                actions: isMyPost
                    ? [
                        IconButton(
                            onPressed: () async {
                              communityTankCubit.deletePost(post?.id ?? "");
                              navPop(context);
                            },
                            icon: Icon(Icons.delete))
                      ]
                    : [],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 5,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CTPostCard(
                          post: post ??
                              CTPost(
                                  id: "",
                                  title: "Error Fetching Post",
                                  content: "Error Fetching Post",
                                  authorID: "",
                                  authorName: "",
                                  createdAt: "",
                                  images: []),
                          isDetailedView: true),
                      if (loadingComments) Gap(100),
                      if (loadingComments)
                        Center(child: Loader())
                      else
                        ...comments.map((e) => CTCommentCard(e,
                            onRemove: () =>
                                setState(() => comments.remove(e)))),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
