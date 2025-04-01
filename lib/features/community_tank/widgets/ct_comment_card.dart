import 'package:fishroom/core/constants.dart';
import 'package:fishroom/features/community_tank/models/ct_comment.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CTCommentCard extends StatelessWidget {
  const CTCommentCard(this.comment, {super.key});
  final CTComment comment;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.2, color: Colors.grey)),
      ),
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
    );
  }
}
