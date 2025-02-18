// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:fishroom/core/usecases/nav_push.dart';
import 'package:fishroom/core/usecases/show_toast.dart';
import 'package:fishroom/core/usecases/upload_image.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/fish_text_box.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/features/bug_report/views/thank_you.dart';
import 'package:fishroom/features/fishroom/widgets/image_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/constants.dart';
import '../../../core/usecases/pick_image.dart';
import '../../../core/widgets/custom_button.dart';
import '../../app/cubit/app_cubit.dart';
import '../models/bug_report.dart';

class BugReportView extends StatefulWidget {
  const BugReportView({super.key});

  @override
  State<BugReportView> createState() => _BugReportViewState();
}

class _BugReportViewState extends State<BugReportView> {
  File? image;
  bool loading = false;
  BugReport bugReport = BugReport(
    description: "",
    screenshotUrl: "",
    appVersion: "",
    reporter: "",
  );

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((value) => setState(() {
          bugReport = bugReport.copyWith(
            appVersion: value.version,
            reporter: context.read<AppCubit>().state.user!.uuid,
          );
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CustomBackground(),
        Scaffold(
          appBar: RootSliverAppBar(
            title: "Bug Report",
            implyLeading: true,
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                spacing: 20,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Gap(20),
                  Text("Found a bug? Tell us about it!",
                      textAlign: TextAlign.center, style: kHeadingTextStyle),
                  Text(
                      "Describe the bug in detail.\nThe more details, the better!\n\nAn example of a good bug report includes:\n- Steps to Reproduce\n- Expected Result\n- Actual Result\n- Screenshot of the bug if possible. \nAlternatively, you can type a message below and we will get back to you as soon as possible.",
                      textAlign: TextAlign.center,
                      style: kPlainTextStyle),
                  FishTextBox(
                    initialValue: bugReport.description,
                    hintText: "Describe the bug in detail.",
                    onChanged: (value) => setState(
                      () => bugReport = bugReport.copyWith(description: value),
                    ),
                  ),
                  Gap(20),
                  if (image == null)
                    CustomButton(
                      primary: false,
                      text: "Add a Screenshot.",
                      onPressed: () async {
                        image = await pickImage(context);
                        setState(() {});
                      },
                    ),
                  if (image != null)
                    ImageUploadWidget(
                      image: image,
                      unlockAspectRatio: true,
                      onImagePicked: (value) => setState(() => image = value),
                    ),
                  Gap(20),
                  CustomButton(
                    loading: loading,
                    primary: true,
                    text: "Submit",
                    onPressed: () async {
                      setState(() => loading = true);
                      try {
                        if (image != null) {
                          bugReport = bugReport.copyWith(
                              screenshotUrl:
                                  await uploadImage(context, image!));
                        }
                        await context
                            .read<AppCubit>()
                            .submitBugReport(bugReport);
                        setState(() => loading = false);
                        navReplace(context, ThankYou());
                      } catch (e) {
                        setState(() => loading = false);
                        showToast(context,
                            title: "Failed to submit bug report",
                            toastType: ToastType.error,
                            description: e.toString());
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
