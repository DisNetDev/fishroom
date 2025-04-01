import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/app/cubit/app_cubit.dart';
import 'package:fishroom/features/community_tank/cubit/community_tank_cubit.dart';
import 'package:fishroom/features/community_tank/models/ct_comment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/usecases/show_toast.dart';

class CreateCommentModal extends StatefulWidget {
  const CreateCommentModal({
    super.key,
    required this.postId,
    required this.onCommentCreated,
  });

  final String postId;
  final Function(CTComment) onCommentCreated;
  @override
  State<CreateCommentModal> createState() => _CreateCommentModalState();
}

class _CreateCommentModalState extends State<CreateCommentModal> {
  CommunityTankCubit get cubit => context.read<CommunityTankCubit>();
  AppCubit get appCubit => context.read<AppCubit>();
  String commentString = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          TextInput(
            label: Text("Comment"),
            isMultiline: true,
            onChanged: (value) => setState(() => commentString = value),
          ),
          Expanded(child: SizedBox()),
          CustomButton(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            text: "Comment",
            loading: loading,
            onPressed: () async {
              if (commentString.isEmpty) {
                showToast(
                  context,
                  title: "Please enter a comment.",
                  toastType: ToastType.error,
                );
                return;
              }
              try {
                setState(() => loading = true);
                CTComment comment = CTComment(
                  id: const Uuid().v4(),
                  postId: widget.postId,
                  content: commentString,
                  createdAt: DateTime.now().toString(),
                  userId: appCubit.state.user!.uuid,
                  username: appCubit.state.user!.username ?? "",
                );
                await cubit.createComment(widget.postId, comment);
                widget.onCommentCreated(comment);
                setState(() => loading = false);
                navPop(context);
              } catch (e) {
                setState(() => loading = false);
                showToast(
                  context,
                  title: "Something went wrong.",
                  description: e.toString(),
                  toastType: ToastType.error,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
