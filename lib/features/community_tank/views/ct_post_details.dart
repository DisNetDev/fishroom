import 'package:fishroom/core/usecases/log.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../cubit/community_tank_cubit.dart';
import '../models/ct_comment.dart';
import '../widgets/ct_omment_card.dart';
import '../widgets/ct_post_card.dart';

class CTPostDetails extends StatefulWidget {
  const CTPostDetails({super.key, required this.postId});

  final String postId;

  @override
  State<CTPostDetails> createState() => _CTPostDetailsState();
}

class _CTPostDetailsState extends State<CTPostDetails> {
  bool loadingComments = false;
  CommunityTankCubit get communityTankCubit =>
      context.read<CommunityTankCubit>();

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
        final post =
            state.posts.firstWhere((element) => element.id == widget.postId);
        return Scaffold(
          appBar: RootSliverAppBar(
            implyLeading: true,
            title: "",
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                CTPostCard(post: post, isDetailedView: true),
                if (loadingComments) Gap(100),
                if (loadingComments)
                  Center(child: Loader())
                else
                  ListView.builder(
                    itemBuilder: (context, index) =>
                        CTCommentCard(comments[index]),
                    itemCount: comments.length,
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
