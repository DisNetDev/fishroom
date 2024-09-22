import 'package:fishroom/core/usecases/datetime_format.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class DateTimeText extends StatelessWidget {
  const DateTimeText({super.key, required this.dateTime});

  final String dateTime;

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDateTime(dateTime),
      style: kDateTimeTextStyle,
      overflow: TextOverflow.ellipsis,
    );
  }
}
