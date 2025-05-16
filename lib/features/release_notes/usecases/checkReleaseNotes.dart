import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/release_notes/cubit/release_notes_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> checkReleaseNotes(BuildContext context) async {
  ReleaseNotesCubit releaseNotesCubit = context.read<ReleaseNotesCubit>();

  bool hasReadCurrentVersion = await releaseNotesCubit.hasReadCurrentVersion();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  if (!hasReadCurrentVersion) {
    String? notes = await releaseNotesCubit.getReleaseNotes();
    if (notes != null) {
      showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => Container(
          padding: EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What's new in ${packageInfo.version}?",
                style: kHeadingTextStyle,
              ),
              Divider(color: Colors.grey.shade800),
              Gap(10),
              Text(notes, style: kPlainTextStyle),
            ],
          ),
        ),
      );
      releaseNotesCubit.setHasReadCurrentVersion();
    }
  }
}
