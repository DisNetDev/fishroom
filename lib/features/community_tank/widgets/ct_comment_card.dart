import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/community_tank/models/ct_comment.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../core/usecases/is_dark_mode.dart';
import '../../../core/usecases/nav_push.dart';
import '../views/report_object.dart';

class CTCommentCard extends StatelessWidget {
  const CTCommentCard(this.comment, {super.key, required this.onRemove});
  final CTComment comment;
  final VoidCallback onRemove;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${comment.username} said:",
                style: kDateTimeTextStyle.copyWith(color: Colors.grey),
              ),
              Gap(5),
              Text(comment.content),
            ],
          ),
        ),
        Positioned(
          right: 0,
          child: PopupMenuButton(
              elevation: 2,
              shadowColor: isDarkMode(context) ? Colors.white : null,
              padding: EdgeInsets.zero,
              onSelected: (value) {
                if (value == "report_post") {
                  navPush(context,
                      ReportObject(object: comment, onReport: onRemove));
                }
              },
              itemBuilder: (context) => [
                    PopupMenuItem(
                        value: "report_post", child: Text("Report Comment"))
                  ]),
        )
      ],
    );
  }
}
