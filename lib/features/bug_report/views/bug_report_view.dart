import 'dart:io';

import 'package:fishroom/core/usecases/upload_image.dart';
import 'package:fishroom/core/widgets/custom_background.dart';
import 'package:fishroom/core/widgets/fish_text_box.dart';
import 'package:fishroom/core/widgets/loader.dart';
import 'package:fishroom/core/widgets/root_sliver_app_bar.dart';
import 'package:fishroom/core/widgets/text_input.dart';
import 'package:fishroom/features/fishroom/widgets/image_upload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../core/constants.dart';
import '../../../core/usecases/pick_image.dart';
import '../../../core/widgets/custom_button.dart';
import '../../app/cubit/app_cubit.dart';

class BugReportView extends StatefulWidget {
  const BugReportView({super.key});

  @override
  State<BugReportView> createState() => _BugReportViewState();
}

class _BugReportViewState extends State<BugReportView> {
  String bugDescription = "";
  File? image;
  bool uploading = false;
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
                  Text("Found a bug? Please describe it here.",
                      textAlign: TextAlign.center, style: kHeadingTextStyle),
                  Text("Please be as descriptive as possible.",
                      textAlign: TextAlign.center, style: kPlainTextStyle),
                  Text("Example:",
                      textAlign: TextAlign.center, style: kPlainTextStyle),
                  Gap(20),
                  FishTextBox(
                    initialValue: bugDescription,
                    onChanged: (value) {
                      setState(
                        () {
                          bugDescription = value;
                        },
                      );
                    },
                  ),
                  Gap(20),
                  Text("If you have a screenshot, please include it here.",
                      textAlign: TextAlign.center, style: kPlainTextStyle),
                  if (image == null)
                    CustomButton(
                      primary: false,
                      text: "Attach a Photo",
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
                    primary: true,
                    text: "Submit",
                    onPressed: () {},
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
