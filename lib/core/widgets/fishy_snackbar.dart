import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

SnackBar fishySnackBar({
  required String title,
  required String message,
  required ContentType contentType,
  Color? color,
}) {
  return SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      clipBehavior: Clip.none,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
        color: color,
      ));
}
