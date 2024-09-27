import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showToast(
    {required String title,
    String? description,
    ToastificationType type = ToastificationType.info}) {
  toastification.show(
    title: Text(title),
    description: Text(description ?? ""),
    type: type,
    alignment: Alignment.bottomCenter,
    autoCloseDuration: const Duration(seconds: 5),
  );
}
