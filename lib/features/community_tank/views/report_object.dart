import 'package:fishroom/core/constants.dart';
import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/widgets/custom_button.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/community_tank/cubit/community_tank_cubit.dart';
import 'package:fishroom/features/community_tank/models/ct_comment.dart';
import 'package:fishroom/features/community_tank/models/ct_post.dart';
import 'package:fishroom/features/community_tank/models/ct_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uuid/uuid.dart';

import '../../app/cubit/app_cubit.dart';

class ReportObject extends StatefulWidget {
  const ReportObject({super.key, required this.object, required this.onReport});

  final Object object;

  final VoidCallback onReport;

  @override
  State<ReportObject> createState() => _ReportObjectState();
}

class _ReportObjectState extends State<ReportObject> {
  late CTReport report;
  AppCubit get appCubit => context.read<AppCubit>();
  CommunityTankCubit get communityTankCubit =>
      context.read<CommunityTankCubit>();
  String type = "";
  bool valid = false;

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
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        persistentFooterButtons: [
          CustomButton(
            disabled: !valid,
            text: "Report $type",
            onPressed: () {
              communityTankCubit.report(report);
              widget.onReport();
              navPop(context);
            },
            onDisabledTap: () => showToast(context,
                title: "Could not create report.",
                description: "The reason cannot be empty.",
                toastType: ToastType.info),
          )
        ],
        appBar: RootSliverAppBar(title: "Report $type"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gap(20),
                Text(
                  "Thank you for making Fishroom a better place!",
                  style: kHeadingTextStyle,
                  textAlign: TextAlign.center,
                ),
                Gap(20),
                Text(
                  "Reason for reporting this $type:",
                  style: kHeading1TextStyle,
                ),
                Gap(20),
                TextInput(
                  onChanged: (value) => setState(
                    () => report = report.copyWith(reason: value),
                  ),
                  validator: (value) {
                    if (report.reason == null || report.reason!.isEmpty) {
                      valid = false;
                      return "Please enter a reason.";
                    }
                    valid = true;
                    return null;
                  },
                  label: Text("Reason"),
                  margin: EdgeInsets.zero,
                  characterLimit: 160,
                  isMultiline: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
