import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/community_tank/models/ct_comment.dart';
import 'package:fishroom/features/community_tank/models/ct_post.dart';
import 'package:fishroom/features/community_tank/models/ct_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../app/cubit/app_cubit.dart';

class ReportObject extends StatefulWidget {
  const ReportObject({super.key, required this.object});

  final Object object;

  @override
  State<ReportObject> createState() => _ReportObjectState();
}

class _ReportObjectState extends State<ReportObject> {
  late CTReport report;
  AppCubit get appCubit => context.read<AppCubit>();
  String type = "";

  @override
  void initState() {
    report = CTReport(
      id: Uuid().v4(),
      createdAt: DateTime.now().toString(),
      reporterId: appCubit.state.user?.uuid ?? "",
    );

    if (widget.object is CTPost) {
      report = report.copyWith(postId: (widget.object as CTPost).id);
      setState(() => type = "Post");
    }
    if (widget.object is CTComment) {
      report = report.copyWith(commentId: (widget.object as CTComment).id);
      setState(() => type = "Comment");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RootSliverAppBar(title: "Report $type"),
      body: Column(
        children: [],
      ),
    );
  }
}
